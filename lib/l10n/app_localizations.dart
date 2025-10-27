import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// Title of the confirm-exit dialog
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exitDialogTitle;

  /// Label shown above the ad container
  ///
  /// In en, this message translates to:
  /// **'Advertisement'**
  String get adLabel;

  /// Cancel button text in dialogs
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Exit/confirm button text in dialogs
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Disabled button text while ad is loading
  ///
  /// In en, this message translates to:
  /// **'Loading ad...'**
  String get adLoading;

  /// AppBar title with file name
  ///
  /// In en, this message translates to:
  /// **'Audio metadata — {fileName}'**
  String audioMetadataTitle(Object fileName);

  /// Save icon tooltip when there are changes
  ///
  /// In en, this message translates to:
  /// **'Save as…'**
  String get tooltipSaveAs;

  /// Save icon tooltip when there are no changes
  ///
  /// In en, this message translates to:
  /// **'No changes'**
  String get tooltipNoChanges;

  /// Refresh icon tooltip
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get tooltipReload;

  /// Banner after selecting cover image
  ///
  /// In en, this message translates to:
  /// **'Cover selected: {fileName}'**
  String bannerCoverSelected(Object fileName);

  /// Banner button: Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btnClose;

  /// Banner body for save success
  ///
  /// In en, this message translates to:
  /// **'Saved: {displayName}'**
  String saveDone(Object displayName);

  /// Banner body for save cancellation
  ///
  /// In en, this message translates to:
  /// **'Save cancelled'**
  String get saveCancelled;

  /// Banner body for save failure
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(Object error);

  /// Hint text for empty lyrics field
  ///
  /// In en, this message translates to:
  /// **'(none)'**
  String get hintNone;

  /// Label for title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get metaLabelTitle;

  /// Label for artist
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get metaLabelArtist;

  /// Label for album
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get metaLabelAlbum;

  /// Label for genre
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get metaLabelGenre;

  /// Label for year
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get metaLabelYear;

  /// Label for track number
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get metaLabelTrack;

  /// Label for disc number
  ///
  /// In en, this message translates to:
  /// **'Disc'**
  String get metaLabelDisc;

  /// Dialog title for choosing overlay/edit action
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get chooseActionTitle;

  /// Dialog body for choosing overlay/edit action
  ///
  /// In en, this message translates to:
  /// **'Choose one and it will run immediately.'**
  String get chooseActionBody;

  /// Button to open overlay editor
  ///
  /// In en, this message translates to:
  /// **'Edit size & position'**
  String get actionEditOverlay;

  /// Button to start lyrics overlay
  ///
  /// In en, this message translates to:
  /// **'Load subtitles'**
  String get actionLoadSubtitles;

  /// SnackBar for SYSTEM_ALERT_WINDOW permission
  ///
  /// In en, this message translates to:
  /// **'Overlay permission is required. Please allow it in Settings.'**
  String get overlayPermissionNeeded;

  /// SnackBar for FlutterOverlayWindow permission denied
  ///
  /// In en, this message translates to:
  /// **'Overlay Window permission was denied.'**
  String get overlayWindowDenied;

  /// Sample text top line
  ///
  /// In en, this message translates to:
  /// **'For short lines'**
  String get overlaySampleShort;

  /// Sample text bottom line
  ///
  /// In en, this message translates to:
  /// **'When the subtitle is a long sentence'**
  String get overlaySampleLong;

  /// Font size picker title
  ///
  /// In en, this message translates to:
  /// **'Choose font size'**
  String get fontPickerTitle;

  /// Common: Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Common: OK
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// Common: Save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// Common: Change
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get commonChange;

  /// Common: Settings label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonSettings;

  /// Palette: current font size
  ///
  /// In en, this message translates to:
  /// **'Font {size}'**
  String paletteFontLabel(Object size);

  /// Palette: X-axis center lock
  ///
  /// In en, this message translates to:
  /// **'Lock center on X'**
  String get paletteLockCenterX;

  /// Calibration step 1 hint
  ///
  /// In en, this message translates to:
  /// **'Fix offset (overlay fixed)'**
  String get calibFixHint;

  /// Calibration step 2 hint
  ///
  /// In en, this message translates to:
  /// **'Merge (queue Δ)'**
  String get calibMergeHint;

  /// Calibration step 1 button
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get calibFix;

  /// Calibration step 2 button
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get calibMerge;

  /// Palette: save label
  ///
  /// In en, this message translates to:
  /// **'Save with correction'**
  String get saveApplyDelta;

  /// No description provided for @hudCenterSuffix.
  ///
  /// In en, this message translates to:
  /// **'(X-centered)'**
  String get hudCenterSuffix;

  /// Web toolbar: back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get webBack;

  /// Web toolbar: forward
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get webForward;

  /// Web toolbar: reload
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get webReload;

  /// Web toolbar: close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get webClose;

  /// Address field hint
  ///
  /// In en, this message translates to:
  /// **'Enter address or paste'**
  String get webAddressHint;

  /// Empty lyrics notice
  ///
  /// In en, this message translates to:
  /// **'Lyrics not received.'**
  String get emptyLyrics;

  /// Overlay first page top hint
  ///
  /// In en, this message translates to:
  /// **'* Double-tap to close the overlay.'**
  String get overlayHintDoubleTap;

  /// Overlay first page bottom hint
  ///
  /// In en, this message translates to:
  /// **'* Swipe to change pages.'**
  String get overlayHintSwipe;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
