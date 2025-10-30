import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('th'),
    Locale('tr'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// Confirm-exit dialog title
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit the app?'**
  String get exitDialogTitle;

  /// Label at the top of the ad container
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get adLabel;

  /// Dialog cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Dialog confirm/exit button text
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// Disabled button text while the ad is loading
  ///
  /// In en, this message translates to:
  /// **'Loading ad...'**
  String get adLoading;

  /// AppBar title
  ///
  /// In en, this message translates to:
  /// **'Audio metadata — {fileName}'**
  String audioMetadataTitle(Object fileName);

  /// Save icon tooltip (when there are changes)
  ///
  /// In en, this message translates to:
  /// **'Save as'**
  String get tooltipSaveAs;

  /// Save icon tooltip (when there are no changes)
  ///
  /// In en, this message translates to:
  /// **'No changes'**
  String get tooltipNoChanges;

  /// Refresh icon tooltip
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get tooltipReload;

  /// Info banner after selecting a cover
  ///
  /// In en, this message translates to:
  /// **'Cover selected: {fileName}'**
  String bannerCoverSelected(Object fileName);

  /// Banner button: Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get btnClose;

  /// Save success banner body
  ///
  /// In en, this message translates to:
  /// **'Saved: {displayName}'**
  String saveDone(Object displayName);

  /// Save canceled banner body
  ///
  /// In en, this message translates to:
  /// **'Save canceled'**
  String get saveCancelled;

  /// Save failed banner body
  ///
  /// In en, this message translates to:
  /// **'Save failed: {error}'**
  String saveFailed(Object error);

  /// Lyrics input hint text (when empty)
  ///
  /// In en, this message translates to:
  /// **'(None)'**
  String get hintNone;

  /// Meta label: title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get metaLabelTitle;

  /// Meta label: artist
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get metaLabelArtist;

  /// Meta label: album
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get metaLabelAlbum;

  /// Meta label: genre
  ///
  /// In en, this message translates to:
  /// **'Genre'**
  String get metaLabelGenre;

  /// Meta label: year
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get metaLabelYear;

  /// Meta label: track number
  ///
  /// In en, this message translates to:
  /// **'Track'**
  String get metaLabelTrack;

  /// Meta label: disc number
  ///
  /// In en, this message translates to:
  /// **'Disc'**
  String get metaLabelDisc;

  /// Overlay/edit action selection dialog title
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get chooseActionTitle;

  /// Overlay/edit action selection dialog body
  ///
  /// In en, this message translates to:
  /// **'Selecting one will run it immediately.'**
  String get chooseActionBody;

  /// Button to go to the overlay edit screen
  ///
  /// In en, this message translates to:
  /// **'Adjust size and position'**
  String get actionEditOverlay;

  /// Button to run the subtitle overlay
  ///
  /// In en, this message translates to:
  /// **'Load subtitles'**
  String get actionLoadSubtitles;

  /// SYSTEM_ALERT_WINDOW permission required snackbar
  ///
  /// In en, this message translates to:
  /// **'Overlay permission is required. Please allow it in Settings.'**
  String get overlayPermissionNeeded;

  /// FlutterOverlayWindow permission denied snackbar
  ///
  /// In en, this message translates to:
  /// **'Overlay Window permission was denied.'**
  String get overlayWindowDenied;

  /// Sample text for the top line of the overlay
  ///
  /// In en, this message translates to:
  /// **'For short text'**
  String get overlaySampleShort;

  /// Sample text for the bottom line of the overlay
  ///
  /// In en, this message translates to:
  /// **'For long text'**
  String get overlaySampleLong;

  /// Font size picker modal title
  ///
  /// In en, this message translates to:
  /// **'Select font size'**
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

  /// Palette: current font size display
  ///
  /// In en, this message translates to:
  /// **'Font {size}'**
  String paletteFontLabel(Object size);

  /// Palette: lock X-axis center switch label
  ///
  /// In en, this message translates to:
  /// **'Lock center X'**
  String get paletteLockCenterX;

  /// Calibration step 1 description
  ///
  /// In en, this message translates to:
  /// **'Remove offset (lock overlay)'**
  String get calibFixHint;

  /// Calibration step 2 description
  ///
  /// In en, this message translates to:
  /// **'Merge (save to Δ queue)'**
  String get calibMergeHint;

  /// Calibration step 1 button
  ///
  /// In en, this message translates to:
  /// **'Remove offset'**
  String get calibFix;

  /// Calibration step 2 button
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get calibMerge;

  /// Palette: save label
  ///
  /// In en, this message translates to:
  /// **'Apply correction then save'**
  String get saveApplyDelta;

  /// HUD: center-locked suffix
  ///
  /// In en, this message translates to:
  /// **'(X center locked)'**
  String get hudCenterSuffix;

  /// Web address bar toolbar: Back
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get webBack;

  /// Web address bar toolbar: Forward
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get webForward;

  /// Web address bar toolbar: Reload
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get webReload;

  /// Web address bar toolbar: Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get webClose;

  /// Address input field hint
  ///
  /// In en, this message translates to:
  /// **'Enter or paste address'**
  String get webAddressHint;

  /// No lyrics message
  ///
  /// In en, this message translates to:
  /// **'No lyrics received.'**
  String get emptyLyrics;

  /// Overlay first page: top hint
  ///
  /// In en, this message translates to:
  /// **'* Double tap to close the overlay.'**
  String get overlayHintDoubleTap;

  /// Overlay first page: bottom hint
  ///
  /// In en, this message translates to:
  /// **'* Swipe to change pages.'**
  String get overlayHintSwipe;

  /// No description provided for @menuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get menuPrivacy;

  /// No description provided for @menuPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get menuPrivacyPolicy;

  /// No description provided for @menuPrivacyOptions.
  ///
  /// In en, this message translates to:
  /// **'Ad privacy options'**
  String get menuPrivacyOptions;

  /// No description provided for @menuPrivacyOptionsSub.
  ///
  /// In en, this message translates to:
  /// **'Change your consent for personalized ads'**
  String get menuPrivacyOptionsSub;

  /// No description provided for @menuPrivacyOptionsNotRequired.
  ///
  /// In en, this message translates to:
  /// **'Not required in the current region/session'**
  String get menuPrivacyOptionsNotRequired;

  /// No description provided for @openUrlFailed.
  ///
  /// In en, this message translates to:
  /// **'Cannot open URL'**
  String get openUrlFailed;

  /// No description provided for @privacyClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed the privacy options screen'**
  String get privacyClosed;

  /// No description provided for @privacyNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Privacy form is not available'**
  String get privacyNotAvailable;

  /// No description provided for @privacyExplainer.
  ///
  /// In en, this message translates to:
  /// **'This app uses an advertising SDK to serve ads and provides a consent screen in regions where consent is required.'**
  String get privacyExplainer;

  /// Top-right floating button label (required region)
  ///
  /// In en, this message translates to:
  /// **'Privacy options (required)'**
  String get privacyOptionsRequiredLabel;

  /// Top-right floating button label (not required region)
  ///
  /// In en, this message translates to:
  /// **'Privacy options (not required)'**
  String get privacyOptionsNotRequiredLabel;

  /// Snackbar after UMP option change
  ///
  /// In en, this message translates to:
  /// **'Privacy options updated'**
  String get privacyOptionsUpdated;

  /// Snackbar for regions where UMP is not required
  ///
  /// In en, this message translates to:
  /// **'Privacy options are not required in your region'**
  String get privacyOptionsNotRequiredSnack;

  /// Open source info button label
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get openSource;

  /// Open source info dialog title
  ///
  /// In en, this message translates to:
  /// **'Open source notice'**
  String get openSourceGuideTitle;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// Open source info text load failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to read file: {error}'**
  String readFileFailed(Object error);

  /// Settings screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Privacy & Ads Settings'**
  String get privacySettingsTitle;

  /// Consent section title
  ///
  /// In en, this message translates to:
  /// **'Consent (CMP/UMP)'**
  String get consentSectionTitle;

  /// Right chip in the consent section
  ///
  /// In en, this message translates to:
  /// **'Entry required'**
  String get entryRequiredChip;

  /// Button label: open UMP options
  ///
  /// In en, this message translates to:
  /// **'Open privacy options'**
  String get openPrivacyOptionsButton;

  /// Consent section helper text
  ///
  /// In en, this message translates to:
  /// **'Users in the EEA/UK/CH can manage consent here. Changes take effect on subsequent ad requests.'**
  String get consentRegionalNote;

  /// Ads personalization section title
  ///
  /// In en, this message translates to:
  /// **'Ads personalization & regional data'**
  String get adsPersonalizationTitle;

  /// NPA switch title
  ///
  /// In en, this message translates to:
  /// **'Always non-personalized ads (NPA)'**
  String get npaTitle;

  /// NPA switch subtitle
  ///
  /// In en, this message translates to:
  /// **'Always request non-personalized ads'**
  String get npaSubtitle;

  /// RDP switch title
  ///
  /// In en, this message translates to:
  /// **'US Restricted Data Processing (RDP)'**
  String get rdpTitle;

  /// RDP switch subtitle
  ///
  /// In en, this message translates to:
  /// **'Compliance for U.S. state laws: attach rdp=1 extras'**
  String get rdpSubtitle;

  /// Child/under-age section title
  ///
  /// In en, this message translates to:
  /// **'Child/under-age tags'**
  String get childFlagsSectionTitle;

  /// COPPA switch title
  ///
  /// In en, this message translates to:
  /// **'Child-directed service (COPPA)'**
  String get coppaTitle;

  /// COPPA switch subtitle
  ///
  /// In en, this message translates to:
  /// **'Tag as child-directed'**
  String get coppaSubtitle;

  /// UAC switch title
  ///
  /// In en, this message translates to:
  /// **'Under the age of consent (UAC)'**
  String get uacTitle;

  /// UAC switch subtitle
  ///
  /// In en, this message translates to:
  /// **'Tag as under the age of consent'**
  String get uacSubtitle;

  /// Helper text under the child/under-age section
  ///
  /// In en, this message translates to:
  /// **'COPPA/UAC are global AdMob settings and take effect immediately for subsequently loaded ads.'**
  String get coppaNote;

  /// Policy section title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get policySectionTitle;

  /// Button: view in-app policy
  ///
  /// In en, this message translates to:
  /// **'View in-app'**
  String get viewInAppButton;

  /// Button: open store policy
  ///
  /// In en, this message translates to:
  /// **'Open store policy'**
  String get openStorePolicyButton;

  /// Helper text under the policy section
  ///
  /// In en, this message translates to:
  /// **'Provide both the store policy URL and the in-app policy screen.'**
  String get policySectionNote;

  /// In-app policy screen AppBar title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get inAppPolicyTitle;

  /// Fallback text when the policy HTML is missing
  ///
  /// In en, this message translates to:
  /// **'Provide your in-app policy here.'**
  String get inAppPolicyFallback;

  /// 국외이전(국제 데이터 이전) 안내 팝업 제목
  ///
  /// In en, this message translates to:
  /// **'Cross-Border Data Transfer Notice'**
  String get crossBorderTitle;

  /// 국외이전 팝업의 전체 정책 링크 버튼
  ///
  /// In en, this message translates to:
  /// **'View full policy'**
  String get viewFullPolicy;

  /// No description provided for @crossBorderFullText.
  ///
  /// In en, this message translates to:
  /// **'• This app uses third-party services (e.g., Google AdMob) to provide and measure advertising. As a result, your personal data may be transferred outside your country.\n\n— Recipient(s) and contact\n  · Recipient: Google LLC and its affiliates (provider of AdMob)\n  · Service/Role: Ad serving, provision of ads/measurement features, processing of related logs\n  · Website: admob.google.com\n  · Note: On iOS, the use of the advertising identifier (IDFA) depends on platform policy and the user\'s consent status.\n\n— Destination countries\n  · The United States and countries where Google or its affiliates have data-processing capabilities (e.g., Europe, Asia, etc.)\n\n— Timing and method of transfer\n  · Timing: When the app launches and when ad requests/impressions/clicks/measurement occur as needed\n  · Method: Network transmission with in-transit encryption (HTTPS/TLS)\n  · Safeguards: Processed under applicable international transfer frameworks and contractual protections (e.g., adequacy decisions, Standard Contractual Clauses)\n\n— Purposes and data items\n  · Purposes: Ad delivery, honoring personalization choices, performance measurement, statistical analysis, improvement of service quality/stability\n  · Examples of data items: Advertising identifiers (AAID/IDFA), app version/settings, basic device/network information, cookie-like identifiers, usage logs (including ad interactions and errors/crashes), region (city/country level), etc.\n\n— Retention period\n  · Retained until the purposes are achieved or for the period required by applicable laws, then deleted or de-identified\n\n— Right to refuse or withdraw consent\n  · You can choose Non-Personalized Ads (NPA) in the app\'s “Privacy options.” In regions such as the EEA/UK/CH, the CMP/UMP consent screen allows choosing personalized/non-personalized ads and resetting choices.\n\n— Contact\n  · Email: g.ns.0700g@gmail.com'**
  String get crossBorderFullText;

  /// No description provided for @warningTitle.
  ///
  /// In en, this message translates to:
  /// **'Metadata Editing Warning'**
  String get warningTitle;

  /// No description provided for @metadataRiskBody.
  ///
  /// In en, this message translates to:
  /// **'Some formats other than MP3 may restrict tag/cover embedding or differ in player compatibility, which can cause editing to fail.'**
  String get metadataRiskBody;

  /// No description provided for @metadataRiskFormatsDetail.
  ///
  /// In en, this message translates to:
  /// **'M4A/MP4 use iTunes atoms, Ogg/Opus use Vorbis Comment (PICTURE block), FLAC uses Vorbis Comment/PICTURE, and WAV uses LIST-INFO.'**
  String get metadataRiskFormatsDetail;

  /// No description provided for @doNotShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get doNotShowAgain;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// Label for width slider showing percentage
  ///
  /// In en, this message translates to:
  /// **'Width {percent}%'**
  String paletteWidthFactor(String percent);

  /// Label for height slider showing percentage
  ///
  /// In en, this message translates to:
  /// **'Height {percent}%'**
  String paletteHeightFactor(String percent);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pt',
    'th',
    'tr',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
