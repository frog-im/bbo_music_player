// lib/privacy/privacy_gate.dart
import 'dart:ui' as ui show Locale, PlatformDispatcher;
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum PRRegion {
  eea,   // EU/EEA
  uk,    // United Kingdom
  ch,    // Switzerland
  us,    // United States
  br,    // Brazil
  tr,    // Türkiye
  ru,    // Russia
  cn,    // Mainland China
  jp,    // Japan
  kr,    // Korea
  other,
}

/// 앱 전체에서 광고 요청 정책을 일관되게 적용하는 헬퍼.
/// - 지역 감지(대략, 로케일 기반)
/// - 전역 RequestConfiguration 업데이트
/// - 지역/토글을 반영한 AdRequest 생성
class PRivacy {
  PRivacy._();
  static final PRivacy instance = PRivacy._();

  PRRegion _region = PRRegion.other;

  // 앱 내 설정/토글 값
  bool _npaAlways = false;          // 항상 비개인화 광고 강제
  bool _usRdp = false;              // 미국 Restricted Data Processing 신호
  bool _childDirected = false;      // COPPA 태그
  bool _underAgeOfConsent = false;  // UAC 태그

  // UMP 미연동 환경의 안전 폴백: EEA/UK/CH 에서는 NPA
  static const bool _kFallbackNpaInEeaLike = true;

  Future<void> INit() async {
    _region = _DEtectRegionFromLocale(
      ui.PlatformDispatcher.instance.locale,
    );

    // 전역 요청 구성(아동 태그 등)
    final config = RequestConfiguration(
      tagForChildDirectedTreatment: _childDirected
          ? TagForChildDirectedTreatment.yes
          : TagForChildDirectedTreatment.unspecified,
      tagForUnderAgeOfConsent: _underAgeOfConsent
          ? TagForUnderAgeOfConsent.yes
          : TagForUnderAgeOfConsent.unspecified,
      // 필요시 콘텐츠 등급을 제한하려면 아래 사용:
      // maxAdContentRating: MaxAdContentRating.pg,
    );
    await MobileAds.instance.updateRequestConfiguration(config);
  }

  /// 로케일 기반 대략적인 지역 감지.
  /// 정확한 위치기반 판정은 UMP SDK가 자동 처리하므로(UCP/TCF),
  /// UMP 연동 시 이 값은 참고 수준으로만 사용.
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
    if (cc == 'BR') return PRRegion.br;
    if (cc == 'TR') return PRRegion.tr;
    if (cc == 'RU') return PRRegion.ru;
    if (cc == 'CN') return PRRegion.cn;
    if (cc == 'JP') return PRRegion.jp;
    if (cc == 'KR') return PRRegion.kr;
    return PRRegion.other;
  }

  // ── 외부에서 조작 가능한 토글들 ──
  void SEtNpaAlways(bool value) {
    _npaAlways = value;
  }

  void SEtUsRestrictedProcessing(bool enabled) {
    // 미국 사용자에 한해 의미가 있으나, SDK 신호 자체는 어디서든 무해
    _usRdp = enabled;
  }

  void SEtChildFlags({
    required bool childDirected,
    required bool underAgeOfConsent,
  }) {
    _childDirected = childDirected;
    _underAgeOfConsent = underAgeOfConsent;
  }

  bool _IsEeaLike() => _region == PRRegion.eea || _region == PRRegion.uk || _region == PRRegion.ch;

  /// 지역/토글을 반영한 광고 요청을 생성한다.
  /// - EEA/UK/CH: UMP 미연동이라면 안전 폴백으로 NPA 적용(옵션)
  /// - US RDP: extras에 {'rdp': '1'} 부착
  AdRequest ADRequest() {
    final Map<String, String> extras = {};

    if (_usRdp) {
      // 미국 주(州) 프라이버시법 대응: RDP=on
      // https://developers.google.com/admob/flutter/privacy/us-states
      extras['rdp'] = '1';
    }

    final bool npa =
        _npaAlways || (_kFallbackNpaInEeaLike && _IsEeaLike());

    // 비개인화 광고 설정(NPA). 플러그인 예제에서도 사용됨.
    // https://pub.dev/packages/google_mobile_ads/example
    return AdRequest(
      nonPersonalizedAds: npa,
      extras: extras.isEmpty ? null : extras,
    );
  }
}
