// lib/privacy/privacy_gate.dart
import 'dart:ui' as ui show Locale, PlatformDispatcher;
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum PRRegion {
  eea,   // EU/EEA
  uk,    // United Kingdom
  ch,    // Switzerland
  us,    // United States
  other,
}

class PRivacy {
  PRivacy._();
  static final PRivacy instance = PRivacy._();

  PRRegion _region = PRRegion.other;

  // 앱 내 설정/토글 (필요하면 노출해서 바꿔 써)
  bool _npaAlways = false;          // 항상 비개인화 광고 강제
  bool _usRdp = false;              // 미국 Restricted Data Processing
  bool _childDirected = false;      // COPPA
  bool _underAgeOfConsent = false;  // UAC

  // UMP 없는 환경에서의 안전 폴백: EEA/UK/CH이면 NPA
  static const bool _kFallbackNpaInEeaLike = true;

  Future<void> INit() async {
    _region = _DEtectRegionFromLocale(
      ui.PlatformDispatcher.instance.locale,
    );

    // 전역 요청 구성(COPPA/UAC 등 태그)
    final config = RequestConfiguration(
      tagForChildDirectedTreatment: _childDirected
          ? TagForChildDirectedTreatment.yes
          : TagForChildDirectedTreatment.unspecified,
      tagForUnderAgeOfConsent: _underAgeOfConsent
          ? TagForUnderAgeOfConsent.yes
          : TagForUnderAgeOfConsent.unspecified,
      // 필요하면 콘텐츠 등급 제한:
      // maxAdContentRating: MaxAdContentRating.pg,
    );
    await MobileAds.instance.updateRequestConfiguration(config);
  }

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

  // 선택적 토글 노출 메서드들
  void SEtNpaAlways(bool value) => _npaAlways = value;
  void SEtUsRestrictedProcessing(bool enabled) => _usRdp = enabled;
  void SEtChildFlags({required bool childDirected, required bool underAgeOfConsent}) {
    _childDirected = childDirected;
    _underAgeOfConsent = underAgeOfConsent;
  }

  bool _IsEeaLike() =>
      _region == PRRegion.eea || _region == PRRegion.uk || _region == PRRegion.ch;

  /// 지역/토글을 반영한 표준 광고 요청
  /// - EEA/UK/CH: UMP 미연동이면 안전 폴백으로 NPA 적용
  /// - 미국: RDP 신호를 extras에 {'rdp': '1'}로 부착
  AdRequest ADRequest() {
    final extras = <String, String>{};
    if (_usRdp || _region == PRRegion.us) {
      // U.S. states privacy laws 대응: RDP 신호
      // https://developers.google.com/admob/flutter/privacy/us-states
      extras['rdp'] = '1';
    }

    final npa = _npaAlways || (_kFallbackNpaInEeaLike && _IsEeaLike());

    // 비개인화 광고(NPA) 옵션
    // https://developers.google.com/admob/flutter/quick-start (AdRequest nonPersonalizedAds)
    return AdRequest(
      nonPersonalizedAds: npa,
      extras: extras.isEmpty ? null : extras,
    );
  }
}
