// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get exitDialogTitle => '앱을 종료하시겠습니까?';

  @override
  String get adLabel => '광고';

  @override
  String get cancel => '취소';

  @override
  String get exit => '종료';

  @override
  String get adLoading => '광고 로딩 중...';

  @override
  String audioMetadataTitle(Object fileName) {
    return '오디오 메타데이터 — $fileName';
  }

  @override
  String get tooltipSaveAs => '다른 이름으로 저장';

  @override
  String get tooltipNoChanges => '수정 사항 없음';

  @override
  String get tooltipReload => '다시 읽기';

  @override
  String bannerCoverSelected(Object fileName) {
    return '커버 선택됨: $fileName';
  }

  @override
  String get btnClose => '닫기';

  @override
  String saveDone(Object displayName) {
    return '저장 완료: $displayName';
  }

  @override
  String get saveCancelled => '저장 취소됨';

  @override
  String saveFailed(Object error) {
    return '저장 실패: $error';
  }

  @override
  String get hintNone => '(없음)';

  @override
  String get metaLabelTitle => 'Title';

  @override
  String get metaLabelArtist => 'Artist';

  @override
  String get metaLabelAlbum => 'Album';

  @override
  String get metaLabelGenre => 'Genre';

  @override
  String get metaLabelYear => 'Year';

  @override
  String get metaLabelTrack => 'Track';

  @override
  String get metaLabelDisc => 'Disc';

  @override
  String get chooseActionTitle => '어떤 동작을 실행할까요?';

  @override
  String get chooseActionBody => '둘 중 하나를 선택하면 즉시 실행됩니다.';

  @override
  String get actionEditOverlay => '사이즈 위치 설정';

  @override
  String get actionLoadSubtitles => '자막 불러오기';

  @override
  String get overlayPermissionNeeded => '오버레이 권한이 필요합니다. 설정에서 허용해주세요.';

  @override
  String get overlayWindowDenied => 'Overlay Window 권한이 거부되었습니다.';

  @override
  String get overlaySampleShort => '짧은 글일 경우';

  @override
  String get overlaySampleLong => '해당 자막이 긴 글일 경우입니다';

  @override
  String get fontPickerTitle => '폰트 크기 선택';

  @override
  String get commonCancel => '취소';

  @override
  String get commonOk => '확인';

  @override
  String get commonSave => '저장';

  @override
  String get commonChange => '변경';

  @override
  String get commonSettings => '설정';

  @override
  String paletteFontLabel(Object size) {
    return '폰트 $size';
  }

  @override
  String get paletteLockCenterX => 'X축 중앙 고정';

  @override
  String get calibFixHint => '오차없애기(오버레이 고정)';

  @override
  String get calibMergeHint => '겹치기(Δ 큐에 저장)';

  @override
  String get calibFix => '오차없애기';

  @override
  String get calibMerge => '겹치기';

  @override
  String get saveApplyDelta => '보정값 적용 후 저장';

  @override
  String get hudCenterSuffix => '(X중앙 고정)';

  @override
  String get webBack => '뒤로';

  @override
  String get webForward => '앞으로';

  @override
  String get webReload => '새로고침';

  @override
  String get webClose => '닫기';

  @override
  String get webAddressHint => '주소 입력 또는 붙여넣기';

  @override
  String get emptyLyrics => '가사를 받지 못했습니다.';

  @override
  String get overlayHintDoubleTap => '* 두 번 터치하면 오버레이가 종료됩니다.';

  @override
  String get overlayHintSwipe => '* 페이지를 슬라이드해서 넘깁니다.';

  @override
  String get menuPrivacy => '개인정보';

  @override
  String get menuPrivacyPolicy => '개인정보처리방침';

  @override
  String get menuPrivacyOptions => '광고 개인정보 옵션';

  @override
  String get menuPrivacyOptionsSub => '맞춤형 광고 동의 상태를 변경합니다';

  @override
  String get menuPrivacyOptionsNotRequired => '현재 지역/세션에서는 표시가 필요하지 않습니다';

  @override
  String get openUrlFailed => 'URL을 열 수 없습니다';

  @override
  String get privacyClosed => '프라이버시 옵션 화면을 닫았습니다';

  @override
  String get privacyNotAvailable => '프라이버시 폼을 사용할 수 없습니다';

  @override
  String get privacyExplainer =>
      '이 앱은 광고 제공을 위해 광고 SDK를 사용하며, 동의가 필요한 지역에서는 동의 관리 화면을 제공합니다.';

  @override
  String get privacyOptionsRequiredLabel => '개인정보 옵션 (필요)';

  @override
  String get privacyOptionsNotRequiredLabel => '개인정보 옵션 (불필요)';

  @override
  String get privacyOptionsUpdated => '개인정보 옵션을 업데이트했습니다';

  @override
  String get privacyOptionsNotRequiredSnack => '현재 지역에서는 개인정보 옵션 표시가 필요하지 않습니다';

  @override
  String get openSource => '오픈 소스';

  @override
  String get openSourceGuideTitle => '오픈 소스 제공 안내';

  @override
  String get errorTitle => '오류';

  @override
  String readFileFailed(Object error) {
    return '파일을 읽지 못했습니다: $error';
  }

  @override
  String get privacySettingsTitle => '개인정보 및 광고 설정';

  @override
  String get consentSectionTitle => '동의(CMP/UMP)';

  @override
  String get entryRequiredChip => '표시 필요';

  @override
  String get openPrivacyOptionsButton => '개인정보 옵션 열기';

  @override
  String get consentRegionalNote =>
      'EEA/UK/CH 사용자는 여기서 동의를 관리할 수 있습니다. 동의 변경은 이후 광고 요청부터 반영됩니다.';

  @override
  String get adsPersonalizationTitle => '광고 개인화 및 지역 데이터';

  @override
  String get npaTitle => '항상 비개인화 광고(NPA)';

  @override
  String get npaSubtitle => '항상 비개인화 광고를 요청합니다';

  @override
  String get rdpTitle => 'US Restricted Data Processing (RDP)';

  @override
  String get rdpSubtitle => '미국 주법 대응: rdp=1 extras 첨부';

  @override
  String get childFlagsSectionTitle => '아동/미성년 태그';

  @override
  String get coppaTitle => '아동 대상 서비스(COPPA)';

  @override
  String get coppaSubtitle => '아동 대상 서비스 태그';

  @override
  String get uacTitle => '연령 동의 미만(UAC)';

  @override
  String get uacSubtitle => '미성년(연령 동의 미만) 태그';

  @override
  String get coppaNote =>
      'COPPA/UAC는 AdMob 전역 구성으로 즉시 반영되며, 이후 로드되는 광고부터 적용됩니다.';

  @override
  String get policySectionTitle => '개인정보처리방침';

  @override
  String get viewInAppButton => '인앱으로 보기';

  @override
  String get openStorePolicyButton => '스토어 정책 열기';

  @override
  String get policySectionNote => '스토어 정책 URL과 인앱 정책 화면을 모두 제공하세요.';

  @override
  String get inAppPolicyTitle => '개인정보처리방침';

  @override
  String get inAppPolicyFallback => '여기에 인앱 정책을 제공하세요.';

  @override
  String get crossBorderTitle => '국외이전 고지';

  @override
  String get viewFullPolicy => '전체 정책 보기';

  @override
  String get crossBorderFullText =>
      '• 본 앱은 광고 제공 및 측정 기능을 위해 제3자 서비스(예: Google AdMob)를 사용하며, 이에 따라 개인정보가 국외로 이전될 수 있습니다.\n\n— 수탁자(받는 자)·연락처\n  · 수탁자: Google LLC 및 그 계열사(AdMob 제공 주체)\n  · 서비스/역할: 광고 게재, 광고/측정 기능 제공, 관련 로그 처리\n  · 웹사이트: admob.google.com\n  · 비고: iOS의 경우 광고 식별자(IDFA) 사용은 플랫폼 정책 및 사용자의 동의 상태에 따릅니다.\n\n— 이전 국가\n  · 미국 및 Google 또는 그 계열사가 데이터 처리 역량을 보유한 국가(예: 유럽, 아시아 지역 등)\n\n— 이전 시점·방법\n  · 시점: 앱 실행과 광고 요청/노출/클릭/측정 등 필요한 순간\n  · 방법: 네트워크 전송, 전송 구간 암호화(HTTPS/TLS)\n  · 보호조치: 적용 가능한 국제 전송 체계 및 계약상 보호장치(예: 적정성 결정, 표준계약조항 등)에 따라 처리\n\n— 목적·항목\n  · 목적: 광고 제공, 맞춤 여부 반영, 성과 측정, 통계 분석, 서비스 품질/안정성 개선\n  · 항목 예시: 광고 식별자(AAID/IDFA), 앱 버전/설정, 디바이스·네트워크 기본 정보, 쿠키 유사 식별자, 이용 로그(광고 상호작용·오류/충돌 포함), 지역(도시/국가 수준) 등\n\n— 보유기간\n  · 목적 달성 시 또는 관련 법령에서 정한 기간까지 보관 후 파기 또는 비식별 처리\n\n— 동의 거부권 및 철회\n  · 앱의 \'개인정보 옵션\'에서 비개인화 광고(NPA) 선택 가능. EEA/UK/CH 등 지역은 CMP/UMP 동의 화면을 통해 개인화/비개인화 선택 및 재설정 가능\n\n— 문의처\n  · 이메일: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => '메타데이터 편집 주의';

  @override
  String get metadataRiskBody =>
      'MP3 외의 일부 포맷은 태그/커버 삽입이 제한되거나 플레이어별 호환성이 달라 편집이 실패할 수 있습니다.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4는 iTunes atoms, Ogg/Opus는 Vorbis Comment(PICTURE 블록), FLAC은 Vorbis Comment/PICTURE, WAV는 LIST-INFO를 사용합니다.';

  @override
  String get doNotShowAgain => '다시 보지 않기';

  @override
  String get continueLabel => '계속';

  @override
  String paletteWidthFactor(String percent) {
    return '가로 $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return '세로 $percent%';
  }
}
