// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get exitDialogTitle => 'Do you want to exit the app?';

  @override
  String get adLabel => 'Ad';

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
  String get tooltipSaveAs => 'Save as';

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
  String get saveCancelled => 'Save canceled';

  @override
  String saveFailed(Object error) {
    return 'Save failed: $error';
  }

  @override
  String get hintNone => '(None)';

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
  String get chooseActionBody => 'Selecting one will run it immediately.';

  @override
  String get actionEditOverlay => 'Adjust size and position';

  @override
  String get actionLoadSubtitles => 'Load subtitles';

  @override
  String get overlayPermissionNeeded =>
      'Overlay permission is required. Please allow it in Settings.';

  @override
  String get overlayWindowDenied => 'Overlay Window permission was denied.';

  @override
  String get overlaySampleShort => 'For short text';

  @override
  String get overlaySampleLong => 'For long text';

  @override
  String get fontPickerTitle => 'Select font size';

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
  String get paletteLockCenterX => 'Lock center X';

  @override
  String get calibFixHint => 'Remove offset (lock overlay)';

  @override
  String get calibMergeHint => 'Merge (save to Δ queue)';

  @override
  String get calibFix => 'Remove offset';

  @override
  String get calibMerge => 'Merge';

  @override
  String get saveApplyDelta => 'Apply correction then save';

  @override
  String get hudCenterSuffix => '(X center locked)';

  @override
  String get webBack => 'Back';

  @override
  String get webForward => 'Forward';

  @override
  String get webReload => 'Reload';

  @override
  String get webClose => 'Close';

  @override
  String get webAddressHint => 'Enter or paste address';

  @override
  String get emptyLyrics => 'No lyrics received.';

  @override
  String get overlayHintDoubleTap => '* Double tap to close the overlay.';

  @override
  String get overlayHintSwipe => '* Swipe to change pages.';

  @override
  String get menuPrivacy => 'Privacy';

  @override
  String get menuPrivacyPolicy => 'Privacy Policy';

  @override
  String get menuPrivacyOptions => 'Ad privacy options';

  @override
  String get menuPrivacyOptionsSub =>
      'Change your consent for personalized ads';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'Not required in the current region/session';

  @override
  String get openUrlFailed => 'Cannot open URL';

  @override
  String get privacyClosed => 'Closed the privacy options screen';

  @override
  String get privacyNotAvailable => 'Privacy form is not available';

  @override
  String get privacyExplainer =>
      'This app uses an advertising SDK to serve ads and provides a consent screen in regions where consent is required.';

  @override
  String get privacyOptionsRequiredLabel => 'Privacy options (required)';

  @override
  String get privacyOptionsNotRequiredLabel => 'Privacy options (not required)';

  @override
  String get privacyOptionsUpdated => 'Privacy options updated';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'Privacy options are not required in your region';

  @override
  String get openSource => 'Open source';

  @override
  String get openSourceGuideTitle => 'Open source notice';

  @override
  String get errorTitle => 'Error';

  @override
  String readFileFailed(Object error) {
    return 'Failed to read file: $error';
  }

  @override
  String get privacySettingsTitle => 'Privacy & Ads Settings';

  @override
  String get consentSectionTitle => 'Consent (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Entry required';

  @override
  String get openPrivacyOptionsButton => 'Open privacy options';

  @override
  String get consentRegionalNote =>
      'Users in the EEA/UK/CH can manage consent here. Changes take effect on subsequent ad requests.';

  @override
  String get adsPersonalizationTitle => 'Ads personalization & regional data';

  @override
  String get npaTitle => 'Always non-personalized ads (NPA)';

  @override
  String get npaSubtitle => 'Always request non-personalized ads';

  @override
  String get rdpTitle => 'US Restricted Data Processing (RDP)';

  @override
  String get rdpSubtitle =>
      'Compliance for U.S. state laws: attach rdp=1 extras';

  @override
  String get childFlagsSectionTitle => 'Child/under-age tags';

  @override
  String get coppaTitle => 'Child-directed service (COPPA)';

  @override
  String get coppaSubtitle => 'Tag as child-directed';

  @override
  String get uacTitle => 'Under the age of consent (UAC)';

  @override
  String get uacSubtitle => 'Tag as under the age of consent';

  @override
  String get coppaNote =>
      'COPPA/UAC are global AdMob settings and take effect immediately for subsequently loaded ads.';

  @override
  String get policySectionTitle => 'Privacy Policy';

  @override
  String get viewInAppButton => 'View in-app';

  @override
  String get openStorePolicyButton => 'Open store policy';

  @override
  String get policySectionNote =>
      'Provide both the store policy URL and the in-app policy screen.';

  @override
  String get inAppPolicyTitle => 'Privacy Policy';

  @override
  String get inAppPolicyFallback => 'Provide your in-app policy here.';

  @override
  String get crossBorderTitle => 'Cross-Border Data Transfer Notice';

  @override
  String get viewFullPolicy => 'View full policy';

  @override
  String get crossBorderFullText =>
      '• This app uses third-party services (e.g., Google AdMob) to provide and measure advertising. As a result, your personal data may be transferred outside your country.\n\n— Recipient(s) and contact\n  · Recipient: Google LLC and its affiliates (provider of AdMob)\n  · Service/Role: Ad serving, provision of ads/measurement features, processing of related logs\n  · Website: admob.google.com\n  · Note: On iOS, the use of the advertising identifier (IDFA) depends on platform policy and the user\'s consent status.\n\n— Destination countries\n  · The United States and countries where Google or its affiliates have data-processing capabilities (e.g., Europe, Asia, etc.)\n\n— Timing and method of transfer\n  · Timing: When the app launches and when ad requests/impressions/clicks/measurement occur as needed\n  · Method: Network transmission with in-transit encryption (HTTPS/TLS)\n  · Safeguards: Processed under applicable international transfer frameworks and contractual protections (e.g., adequacy decisions, Standard Contractual Clauses)\n\n— Purposes and data items\n  · Purposes: Ad delivery, honoring personalization choices, performance measurement, statistical analysis, improvement of service quality/stability\n  · Examples of data items: Advertising identifiers (AAID/IDFA), app version/settings, basic device/network information, cookie-like identifiers, usage logs (including ad interactions and errors/crashes), region (city/country level), etc.\n\n— Retention period\n  · Retained until the purposes are achieved or for the period required by applicable laws, then deleted or de-identified\n\n— Right to refuse or withdraw consent\n  · You can choose Non-Personalized Ads (NPA) in the app\'s “Privacy options.” In regions such as the EEA/UK/CH, the CMP/UMP consent screen allows choosing personalized/non-personalized ads and resetting choices.\n\n— Contact\n  · Email: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Metadata Editing Warning';

  @override
  String get metadataRiskBody =>
      'Some formats other than MP3 may restrict tag/cover embedding or differ in player compatibility, which can cause editing to fail.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 use iTunes atoms, Ogg/Opus use Vorbis Comment (PICTURE block), FLAC uses Vorbis Comment/PICTURE, and WAV uses LIST-INFO.';

  @override
  String get doNotShowAgain => 'Don\'t show again';

  @override
  String get continueLabel => 'Continue';

  @override
  String paletteWidthFactor(String percent) {
    return 'Width $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Height $percent%';
  }
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get exitDialogTitle => '要結束應用程式嗎？';

  @override
  String get adLabel => '廣告';

  @override
  String get cancel => '取消';

  @override
  String get exit => '結束';

  @override
  String get adLoading => '正在載入廣告…';

  @override
  String audioMetadataTitle(Object fileName) {
    return '音訊中繼資料 — $fileName';
  }

  @override
  String get tooltipSaveAs => '另存新檔';

  @override
  String get tooltipNoChanges => '無變更';

  @override
  String get tooltipReload => '重新載入';

  @override
  String bannerCoverSelected(Object fileName) {
    return '已選封面：$fileName';
  }

  @override
  String get btnClose => '關閉';

  @override
  String saveDone(Object displayName) {
    return '已儲存：$displayName';
  }

  @override
  String get saveCancelled => '已取消儲存';

  @override
  String saveFailed(Object error) {
    return '儲存失敗：$error';
  }

  @override
  String get hintNone => '（無）';

  @override
  String get metaLabelTitle => '標題';

  @override
  String get metaLabelArtist => '演出者';

  @override
  String get metaLabelAlbum => '專輯';

  @override
  String get metaLabelGenre => '類型';

  @override
  String get metaLabelYear => '年';

  @override
  String get metaLabelTrack => '曲目';

  @override
  String get metaLabelDisc => '碟片';

  @override
  String get chooseActionTitle => '要執行哪個動作？';

  @override
  String get chooseActionBody => '選擇任一選項後將立即執行。';

  @override
  String get actionEditOverlay => '設定大小與位置';

  @override
  String get actionLoadSubtitles => '載入字幕';

  @override
  String get overlayPermissionNeeded => '需要覆蓋層權限。請在設定中允許。';

  @override
  String get overlayWindowDenied => '覆蓋視窗權限已被拒絕。';

  @override
  String get overlaySampleShort => '適用於短文字';

  @override
  String get overlaySampleLong => '適用於長文字';

  @override
  String get fontPickerTitle => '選擇字型大小';

  @override
  String get commonCancel => '取消';

  @override
  String get commonOk => '確認';

  @override
  String get commonSave => '儲存';

  @override
  String get commonChange => '變更';

  @override
  String get commonSettings => '設定';

  @override
  String paletteFontLabel(Object size) {
    return '字型 $size';
  }

  @override
  String get paletteLockCenterX => 'X 軸置中鎖定';

  @override
  String get calibFixHint => '移除偏移（鎖定覆蓋層）';

  @override
  String get calibMergeHint => '合併（儲存到 Δ 佇列）';

  @override
  String get calibFix => '移除偏移';

  @override
  String get calibMerge => '合併';

  @override
  String get saveApplyDelta => '套用校正值後儲存';

  @override
  String get hudCenterSuffix => '（X 置中鎖定）';

  @override
  String get webBack => '返回';

  @override
  String get webForward => '前進';

  @override
  String get webReload => '重新整理';

  @override
  String get webClose => '關閉';

  @override
  String get webAddressHint => '輸入或貼上位址';

  @override
  String get emptyLyrics => '未收到歌詞。';

  @override
  String get overlayHintDoubleTap => '＊ 輕觸兩下可關閉覆蓋層。';

  @override
  String get overlayHintSwipe => '＊ 滑動以切換頁面。';

  @override
  String get menuPrivacy => '隱私';

  @override
  String get menuPrivacyPolicy => '隱私權政策';

  @override
  String get menuPrivacyOptions => '廣告隱私選項';

  @override
  String get menuPrivacyOptionsSub => '變更個人化廣告的同意狀態';

  @override
  String get menuPrivacyOptionsNotRequired => '目前區域/工作階段無需顯示';

  @override
  String get openUrlFailed => '無法開啟 URL';

  @override
  String get privacyClosed => '已關閉隱私選項畫面';

  @override
  String get privacyNotAvailable => '隱私表單無法使用';

  @override
  String get privacyExplainer => '本應用使用廣告 SDK 投放廣告，於需要同意的地區提供同意管理畫面。';

  @override
  String get privacyOptionsRequiredLabel => '隱私選項（必須）';

  @override
  String get privacyOptionsNotRequiredLabel => '隱私選項（非必須）';

  @override
  String get privacyOptionsUpdated => '已更新隱私選項';

  @override
  String get privacyOptionsNotRequiredSnack => '您所在區域無需顯示隱私選項';

  @override
  String get openSource => '開放原始碼';

  @override
  String get openSourceGuideTitle => '開放原始碼說明';

  @override
  String get errorTitle => '錯誤';

  @override
  String readFileFailed(Object error) {
    return '無法讀取檔案：$error';
  }

  @override
  String get privacySettingsTitle => '隱私與廣告設定';

  @override
  String get consentSectionTitle => '同意（CMP/UMP）';

  @override
  String get entryRequiredChip => '需顯示';

  @override
  String get openPrivacyOptionsButton => '開啟隱私選項';

  @override
  String get consentRegionalNote => 'EEA/UK/CH 使用者可在此管理同意。變更將自後續廣告請求起生效。';

  @override
  String get adsPersonalizationTitle => '廣告個人化與區域資料';

  @override
  String get npaTitle => '一律使用非個人化廣告（NPA）';

  @override
  String get npaSubtitle => '一律請求 NPA';

  @override
  String get rdpTitle => '美國限制性資料處理（RDP）';

  @override
  String get rdpSubtitle => '符合美國各州法規：在 extras 加上 rdp=1';

  @override
  String get childFlagsSectionTitle => '兒童/未成年標記';

  @override
  String get coppaTitle => '兒童取向服務（COPPA）';

  @override
  String get coppaSubtitle => '兒童取向服務標記';

  @override
  String get uacTitle => '低於同意年齡（UAC）';

  @override
  String get uacSubtitle => '未成年（低於同意年齡）標記';

  @override
  String get coppaNote => 'COPPA/UAC 為 AdMob 全域設定，立即生效，並套用於之後載入的廣告。';

  @override
  String get policySectionTitle => '隱私權政策';

  @override
  String get viewInAppButton => '以應用程式內檢視';

  @override
  String get openStorePolicyButton => '開啟商店政策';

  @override
  String get policySectionNote => '請同時提供商店政策 URL 與應用程式內政策畫面。';

  @override
  String get inAppPolicyTitle => '隱私權政策';

  @override
  String get inAppPolicyFallback => '請在此提供應用程式內政策。';

  @override
  String get crossBorderTitle => '跨境資料傳輸通知';

  @override
  String get viewFullPolicy => '查看完整政策';

  @override
  String get crossBorderFullText =>
      '• 本應用程式為提供與衡量廣告而使用第三方服務（例如：Google AdMob），因此您的個人資料可能被傳輸至境外。\n\n— 接收方與聯絡方式\n  · 接收方：Google LLC 及其關係企業（AdMob 提供者）\n  · 服務/角色：廣告投放、提供廣告/衡量功能、處理相關記錄\n  · 網站：admob.google.com\n  · 備註：在 iOS 上，廣告識別碼（IDFA）的使用取決於平台政策與使用者同意狀態。\n\n— 傳輸目的地\n  · 美國，以及 Google 或其關係企業具備資料處理能力之國家/地區（例如：歐洲、亞洲）\n\n— 傳輸時間與方式\n  · 時間：啟動應用程式時，及於需要時進行廣告請求/曝光/點擊/衡量\n  · 方式：透過網路傳輸，並於傳輸途中加密（HTTPS/TLS）\n  · 保護措施：依適用之國際傳輸機制與契約性保障（例如：適足性決定、標準合約條款）進行處理\n\n— 目的與資料項目\n  · 目的：廣告投放、反映個人化選擇、績效衡量、統計分析、提升服務品質/穩定性\n  · 資料項目範例：廣告識別碼（AAID/IDFA）、應用程式版本/設定、裝置/網路基本資訊、類 Cookie 識別碼、使用記錄（含廣告互動與錯誤/當機）、地區（城市/國家層級）等\n\n— 保存期間\n  · 於達成目的或法律要求之期間屆滿前保存；之後刪除或去識別化\n\n— 拒絕與撤回同意之權利\n  · 您可於應用程式的「隱私選項」選擇非個人化廣告（NPA）。於 EEA/英國/瑞士等地區，可透過 CMP/UMP 同意畫面選擇個人化/非個人化並重新設定。\n\n— 聯絡方式\n  · 電子郵件：g.ns.0700g@gmail.com';

  @override
  String get warningTitle => '中繼資料編輯警示';

  @override
  String get metadataRiskBody =>
      '除 MP3 外，部分格式對標籤／封面嵌入有所限制，或因播放器而相容性不同，可能導致編輯失敗。';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 使用 iTunes atoms，Ogg/Opus 使用 Vorbis Comment（PICTURE 區塊），FLAC 使用 Vorbis Comment/PICTURE，WAV 使用 LIST-INFO。';

  @override
  String get doNotShowAgain => '不再顯示';

  @override
  String get continueLabel => '繼續';

  @override
  String paletteWidthFactor(String percent) {
    return '寬度 $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return '高度 $percent%';
  }
}
