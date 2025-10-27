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
}
