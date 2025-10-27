// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get exitDialogTitle => 'Do you want to exit the app?';

  @override
  String get adLabel => 'Advertisement';

  @override
  String get cancel => 'Cancel';

  @override
  String get exit => 'Exit';

  @override
  String get adLoading => 'Loading ad...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Audio metadata — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Save as…';

  @override
  String get tooltipNoChanges => 'No changes';

  @override
  String get tooltipReload => 'Reload';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Cover selected: $fileName';
  }

  @override
  String get btnClose => 'Close';

  @override
  String saveDone(Object displayName) {
    return 'Saved: $displayName';
  }

  @override
  String get saveCancelled => 'Save cancelled';

  @override
  String saveFailed(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get hintNone => '(none)';

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
  String get chooseActionTitle => 'What would you like to do?';

  @override
  String get chooseActionBody => 'Choose one and it will run immediately.';

  @override
  String get actionEditOverlay => 'Edit size & position';

  @override
  String get actionLoadSubtitles => 'Load subtitles';

  @override
  String get overlayPermissionNeeded =>
      'Overlay permission is required. Please allow it in Settings.';

  @override
  String get overlayWindowDenied => 'Overlay Window permission was denied.';

  @override
  String get overlaySampleShort => 'For short lines';

  @override
  String get overlaySampleLong => 'When the subtitle is a long sentence';

  @override
  String get fontPickerTitle => 'Choose font size';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Save';

  @override
  String get commonChange => 'Change';

  @override
  String get commonSettings => 'Settings';

  @override
  String paletteFontLabel(Object size) {
    return 'Font $size';
  }

  @override
  String get paletteLockCenterX => 'Lock center on X';

  @override
  String get calibFixHint => 'Fix offset (overlay fixed)';

  @override
  String get calibMergeHint => 'Merge (queue Δ)';

  @override
  String get calibFix => 'Fix';

  @override
  String get calibMerge => 'Merge';

  @override
  String get saveApplyDelta => 'Save with correction';

  @override
  String get hudCenterSuffix => '(X-centered)';

  @override
  String get webBack => 'Back';

  @override
  String get webForward => 'Forward';

  @override
  String get webReload => 'Reload';

  @override
  String get webClose => 'Close';

  @override
  String get webAddressHint => 'Enter address or paste';

  @override
  String get emptyLyrics => 'Lyrics not received.';

  @override
  String get overlayHintDoubleTap => '* Double-tap to close the overlay.';

  @override
  String get overlayHintSwipe => '* Swipe to change pages.';
}
