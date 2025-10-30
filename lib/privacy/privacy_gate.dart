// lib/privacy/privacy_gate.dart
import 'dart:async';
import 'dart:ui' as ui show Locale, PlatformDispatcher;

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PRRegion { eea, uk, ch, us, other }
// 앱에서 노출할(선택할) 광고 콘텐츠 등급
enum PRAdRating { g, pg, t, ma }

class PRivacy {
  PRivacy._();
  static final PRivacy instance = PRivacy._();

  // ─────────────────────────────────────────────────────────────
  // 상태
  // ─────────────────────────────────────────────────────────────
  PRRegion _region = PRRegion.other;

  bool _npaAlways = false;          // 항상 비개인화 광고
  bool _usRdp = false;              // 미국 Restricted Data Processing
  bool _childDirected = false;      // COPPA
  bool _underAgeOfConsent = false;  // UAC

  // v6 기준: SDK가 광고요청 가능 판단 / UMP 엔트리 필요 여부
  bool _umpCanRequestAds = false;
  bool _privacyEntryRequired = false;

  // 광고 콘텐츠 등급(선택적). null이면 미설정.
  PRAdRating? _maxAdRating;

  // EEA/UK/CH에서 UMP 미연동 시 NPA 폴백
  static const bool _kFallbackNpaInEeaLike = true;

  // SharedPreferences 키
  static const _kPrefNpa        = 'pref_npa_always';
  static const _kPrefRdp        = 'pref_us_rdp';
  static const _kPrefCoppa      = 'pref_child_directed';
  static const _kPrefUac        = 'pref_under_age';
  static const _kPrefMaxRating  = 'pref_max_ad_rating'; // g/pg/t/ma

  // ─────────────────────────────────────────────────────────────
  // 초기화: 토글 복원 → 전역 구성 반영 → UMP 동기화
  // ─────────────────────────────────────────────────────────────
  Future<void> INit() async {
    _region = _DEtectRegionFromLocale(ui.PlatformDispatcher.instance.locale);

    // 토글 로드
    try {
      final sp = await SharedPreferences.getInstance();
      _npaAlways         = sp.getBool(_kPrefNpa)   ?? _npaAlways;
      _usRdp             = sp.getBool(_kPrefRdp)   ?? _usRdp;
      _childDirected     = sp.getBool(_kPrefCoppa) ?? _childDirected;
      _underAgeOfConsent = sp.getBool(_kPrefUac)   ?? _underAgeOfConsent;

      final mr = sp.getString(_kPrefMaxRating);
      _maxAdRating = _PArseAdRating(mr);
    } catch (_) {}

    // AdMob 전역 구성(COPPA/UAC/등급) 반영
    await UPdateAdMobRequestConfiguration();

    // UMP 동기화(콜백 기반)
    await REfreshConsentWithUmp();
  }

  // 내부: 지역 추정(로케일의 countryCode 기준)
  PRRegion _DEtectRegionFromLocale(ui.Locale? loc) {
    final cc = (loc?.countryCode ?? '').toUpperCase();
    if (cc.isEmpty) return PRRegion.other;

    const eea = {
      // EU
      'AT','BE','BG','HR','CY','CZ','DK','EE','FI','FR','DE','GR','HU',
      'IE','IT','LV','LT','LU','MT','NL','PL','PT','RO','SK','SI','ES','SE',
      // EEA
      'IS','LI','NO',
    };
    if (eea.contains(cc)) return PRRegion.eea;
    if (cc == 'GB') return PRRegion.uk;
    if (cc == 'CH') return PRRegion.ch;
    if (cc == 'US') return PRRegion.us;
    return PRRegion.other;
  }

  bool _IsEeaLike() =>
      _region == PRRegion.eea || _region == PRRegion.uk || _region == PRRegion.ch;

  // 공개 게터(메인 게이트용)
  bool GEisEeaLike() => _IsEeaLike();
  bool GEcanRequestAds() => _umpCanRequestAds;
  bool GEtsPrivacyEntryRequired() => _privacyEntryRequired;

  // 전역 구성(COPPA/UAC/등급) 즉시 반영
  Future<void> UPdateAdMobRequestConfiguration() async {
    final String? rating = _childDirected
        ? MaxAdContentRating.g
        : _MApToSdkRating(_maxAdRating); // String? (v6)

    final config = RequestConfiguration(
      tagForChildDirectedTreatment: _childDirected
          ? TagForChildDirectedTreatment.yes
          : TagForChildDirectedTreatment.unspecified,
      tagForUnderAgeOfConsent: _underAgeOfConsent
          ? TagForUnderAgeOfConsent.yes
          : TagForUnderAgeOfConsent.unspecified,
      maxAdContentRating: rating,
    );
    await MobileAds.instance.updateRequestConfiguration(config);
  }

  // UMP 동의 동기화(콜백형 API)
  Future<void> REfreshConsentWithUmp() async {
    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
            () async {
          await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
          _umpCanRequestAds = await ConsentInformation.instance.canRequestAds();
          final st = await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
          _privacyEntryRequired = st == PrivacyOptionsRequirementStatus.required;
        },
            (FormError _) async {
          _umpCanRequestAds = await ConsentInformation.instance.canRequestAds();
          final st = await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
          _privacyEntryRequired = st == PrivacyOptionsRequirementStatus.required;
        },
      );
    } catch (_) {
      _umpCanRequestAds = false;
      _privacyEntryRequired = false;
    }
  }

  // 설정 화면에서 호출: 개인정보 옵션 폼 띄우기
  Future<void> SHowPrivacyOptionsForm() async {
    await ConsentForm.showPrivacyOptionsForm((_) {});
    _umpCanRequestAds = await ConsentInformation.instance.canRequestAds();
    final st = await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
    _privacyEntryRequired = st == PrivacyOptionsRequirementStatus.required;
  }

  // ── 게이트: 광고 요청 가능한 상태가 되거나(NPA 폴백 확정) 할 때까지 대기 ──
  Future<void> WAITReadyForAds({
    Duration timeout = const Duration(seconds: 3),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    final isEeaLike = _IsEeaLike();
    final t0 = DateTime.now();
    while (DateTime.now().difference(t0) < timeout) {
      // EEA/UK/CH: UMP가 응답했거나, 폴백(NPA)로라도 판단이 선 순간이면 통과
      if ((isEeaLike && (_umpCanRequestAds || _kFallbackNpaInEeaLike)) ||
          (!isEeaLike)) {
        return;
      }
      await Future.delayed(interval);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // 토글 세터: 저장 + 즉시 반영
  // ─────────────────────────────────────────────────────────────
  void SEtNpaAlways(bool value) async {
    _npaAlways = value;
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kPrefNpa, value);
  }

  void SEtUsRestrictedProcessing(bool enabled) async {
    _usRdp = enabled;
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kPrefRdp, enabled);
  }

  void SEtChildFlags({required bool childDirected, required bool underAgeOfConsent}) async {
    _childDirected = childDirected;
    _underAgeOfConsent = underAgeOfConsent;
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_kPrefCoppa, childDirected);
    await sp.setBool(_kPrefUac, underAgeOfConsent);
    await UPdateAdMobRequestConfiguration(); // 전역 구성 즉시 반영
  }

  // 광고 콘텐츠 등급 저장/반영(API 6용)
  Future<void> SEtMaxAdContentRating(PRAdRating? r) async {
    _maxAdRating = r;
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kPrefMaxRating, _ENcodeAdRating(r));
    await UPdateAdMobRequestConfiguration();
  }

  // 게터(설정 화면 초기 값/표시용)
  bool GEtnpaAlways() => _npaAlways;
  bool GEtsUsRestrictedProcessing() => _usRdp;
  bool GEtsChildDirected() => _childDirected;
  bool GEtsUnderAgeOfConsent() => _underAgeOfConsent;
  PRAdRating? GEtsMaxAdContentRating() => _maxAdRating;

  // 지역/토글/UMP 반영 표준 AdRequest
  AdRequest ADRequest() {
    final extras = <String, String>{};
    if (_usRdp || _region == PRRegion.us) {
      extras['rdp'] = '1';
    }

    // UMP 실패/미지원 + EEA/UK/CH → NPA 폴백
    final fallbackNpa = !_umpCanRequestAds && _kFallbackNpaInEeaLike && _IsEeaLike();
    final npa = _npaAlways || fallbackNpa;

    return AdRequest(
      nonPersonalizedAds: npa,
      extras: extras.isEmpty ? null : extras,
    );
  }

  // 내부: 등급 <-> 문자열 매핑 (v6: String?)
  String _ENcodeAdRating(PRAdRating? r) {
    switch (r) {
      case PRAdRating.g:  return 'g';
      case PRAdRating.pg: return 'pg';
      case PRAdRating.t:  return 't';
      case PRAdRating.ma: return 'ma';
      default:            return '';
    }
  }

  PRAdRating? _PArseAdRating(String? s) {
    switch ((s ?? '').toLowerCase()) {
      case 'g':  return PRAdRating.g;
      case 'pg': return PRAdRating.pg;
      case 't':  return PRAdRating.t;
      case 'ma': return PRAdRating.ma;
      default:   return null;
    }
  }

  String? _MApToSdkRating(PRAdRating? r) {
    switch (r) {
      case PRAdRating.g:  return MaxAdContentRating.g;
      case PRAdRating.pg: return MaxAdContentRating.pg;
      case PRAdRating.t:  return MaxAdContentRating.t;
      case PRAdRating.ma: return MaxAdContentRating.ma;
      default:            return null; // 미설정
    }
  }
}
