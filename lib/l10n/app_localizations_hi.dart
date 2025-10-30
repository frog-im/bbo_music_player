// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get exitDialogTitle => 'क्या आप ऐप बंद करना चाहते हैं?';

  @override
  String get adLabel => 'विज्ञापन';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get exit => 'बंद करें';

  @override
  String get adLoading => 'विज्ञापन लोड हो रहा है...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'ऑडियो मेटाडेटा — $fileName';
  }

  @override
  String get tooltipSaveAs => 'अन्य नाम से सहेजें';

  @override
  String get tooltipNoChanges => 'कोई परिवर्तन नहीं';

  @override
  String get tooltipReload => 'फिर से लोड करें';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'कवर चुना गया: $fileName';
  }

  @override
  String get btnClose => 'बंद करें';

  @override
  String saveDone(Object displayName) {
    return 'सहेजा गया: $displayName';
  }

  @override
  String get saveCancelled => 'सहेजना रद्द किया गया';

  @override
  String saveFailed(Object error) {
    return 'सहेजने में विफल: $error';
  }

  @override
  String get hintNone => '(कोई नहीं)';

  @override
  String get metaLabelTitle => 'शीर्षक';

  @override
  String get metaLabelArtist => 'कलाकार';

  @override
  String get metaLabelAlbum => 'एल्बम';

  @override
  String get metaLabelGenre => 'शैली';

  @override
  String get metaLabelYear => 'वर्ष';

  @override
  String get metaLabelTrack => 'ट्रैक';

  @override
  String get metaLabelDisc => 'डिस्क';

  @override
  String get chooseActionTitle => 'आप कौन सी क्रिया चलाना चाहेंगे?';

  @override
  String get chooseActionBody => 'चयन करते ही यह तुरंत चल जाएगा।';

  @override
  String get actionEditOverlay => 'आकार और स्थिति सेट करें';

  @override
  String get actionLoadSubtitles => 'सबटाइटल लोड करें';

  @override
  String get overlayPermissionNeeded =>
      'ओवरले अनुमति आवश्यक है। कृपया सेटिंग्स में अनुमति दें।';

  @override
  String get overlayWindowDenied => 'ओवरले विंडो की अनुमति अस्वीकृत की गई।';

  @override
  String get overlaySampleShort => 'छोटे पाठ के लिए';

  @override
  String get overlaySampleLong => 'लंबे पाठ के लिए';

  @override
  String get fontPickerTitle => 'फ़ॉन्ट आकार चुनें';

  @override
  String get commonCancel => 'रद्द करें';

  @override
  String get commonOk => 'ठीक';

  @override
  String get commonSave => 'सहेजें';

  @override
  String get commonChange => 'बदलें';

  @override
  String get commonSettings => 'सेटिंग्स';

  @override
  String paletteFontLabel(Object size) {
    return 'फ़ॉन्ट $size';
  }

  @override
  String get paletteLockCenterX => 'X-अक्ष केंद्र लॉक करें';

  @override
  String get calibFixHint => 'ऑफ़सेट हटाएँ (ओवरले लॉक)';

  @override
  String get calibMergeHint => 'मर्ज करें (Δ कतार में सहेजें)';

  @override
  String get calibFix => 'ऑफ़सेट हटाएँ';

  @override
  String get calibMerge => 'मर्ज करें';

  @override
  String get saveApplyDelta => 'सुधार लागू कर सहेजें';

  @override
  String get hudCenterSuffix => '(X केंद्र लॉक)';

  @override
  String get webBack => 'पीछे';

  @override
  String get webForward => 'आगे';

  @override
  String get webReload => 'रीलोड करें';

  @override
  String get webClose => 'बंद करें';

  @override
  String get webAddressHint => 'पता दर्ज करें या पेस्ट करें';

  @override
  String get emptyLyrics => 'गीत के बोल प्राप्त नहीं हुए।';

  @override
  String get overlayHintDoubleTap => '* ओवरले बंद करने के लिए दो बार टैप करें।';

  @override
  String get overlayHintSwipe => '* पेज बदलने के लिए स्वाइप करें।';

  @override
  String get menuPrivacy => 'गोपनीयता';

  @override
  String get menuPrivacyPolicy => 'गोपनीयता नीति';

  @override
  String get menuPrivacyOptions => 'विज्ञापन गोपनीयता विकल्प';

  @override
  String get menuPrivacyOptionsSub =>
      'व्यक्तिगत विज्ञापनों की सहमति स्थिति बदलें';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'वर्तमान क्षेत्र/सत्र में प्रदर्शित करना आवश्यक नहीं';

  @override
  String get openUrlFailed => 'URL खोला नहीं जा सका';

  @override
  String get privacyClosed => 'गोपनीयता विकल्प स्क्रीन बंद कर दी गई';

  @override
  String get privacyNotAvailable => 'गोपनीयता फ़ॉर्म उपलब्ध नहीं है';

  @override
  String get privacyExplainer =>
      'यह ऐप विज्ञापन दिखाने के लिए विज्ञापन SDK का उपयोग करता है और जिन क्षेत्रों में सहमति आवश्यक है वहाँ सहमति प्रबंधन स्क्रीन प्रदान करता है।';

  @override
  String get privacyOptionsRequiredLabel => 'गोपनीयता विकल्प (आवश्यक)';

  @override
  String get privacyOptionsNotRequiredLabel => 'गोपनीयता विकल्प (आवश्यक नहीं)';

  @override
  String get privacyOptionsUpdated => 'गोपनीयता विकल्प अपडेट किए गए';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'आपके क्षेत्र में गोपनीयता विकल्प दिखाना आवश्यक नहीं है';

  @override
  String get openSource => 'ओपन सोर्स';

  @override
  String get openSourceGuideTitle => 'ओपन सोर्स 안내';

  @override
  String get errorTitle => 'त्रुटि';

  @override
  String readFileFailed(Object error) {
    return 'फ़ाइल पढ़ी नहीं जा सकी: $error';
  }

  @override
  String get privacySettingsTitle => 'गोपनीयता और विज्ञापन सेटिंग्स';

  @override
  String get consentSectionTitle => 'सहमति (CMP/UMP)';

  @override
  String get entryRequiredChip => 'दिखाना आवश्यक';

  @override
  String get openPrivacyOptionsButton => 'गोपनीयता विकल्प खोलें';

  @override
  String get consentRegionalNote =>
      'EEA/UK/CH उपयोगकर्ता यहाँ सहमति प्रबंधित कर सकते हैं। परिवर्तन अगली विज्ञापन रिक्वेस्ट से लागू होगा।';

  @override
  String get adsPersonalizationTitle => 'विज्ञापन वैयक्तिकरण और क्षेत्रीय डेटा';

  @override
  String get npaTitle => 'हमेशा गैर-व्यक्तिगत विज्ञापन (NPA)';

  @override
  String get npaSubtitle => 'हमेशा NPA का अनुरोध करें';

  @override
  String get rdpTitle => 'US Restricted Data Processing (RDP)';

  @override
  String get rdpSubtitle =>
      'अमेरिकी राज्य क़ानून अनुपालन: extras में rdp=1 जोड़ें';

  @override
  String get childFlagsSectionTitle => 'बाल/नाबालिग टैग';

  @override
  String get coppaTitle => 'बच्चों को लक्षित सेवा (COPPA)';

  @override
  String get coppaSubtitle => 'बच्चों को लक्षित सेवा टैग';

  @override
  String get uacTitle => 'आयु-सहमति से कम (UAC)';

  @override
  String get uacSubtitle => 'नाबालिग (आयु-सहमति से कम) टैग';

  @override
  String get coppaNote =>
      'COPPA/UAC, AdMob की वैश्विक सेटिंग है और तुरंत प्रभावी होती है। इसके बाद लोड होने वाले विज्ञापनों पर लागू होगा।';

  @override
  String get policySectionTitle => 'गोपनीयता नीति';

  @override
  String get viewInAppButton => 'ऐप में देखें';

  @override
  String get openStorePolicyButton => 'स्टोर नीति खोलें';

  @override
  String get policySectionNote =>
      'कृपया स्टोर नीति URL और इन-ऐप नीति स्क्रीन दोनों प्रदान करें।';

  @override
  String get inAppPolicyTitle => 'गोपनीयता नीति';

  @override
  String get inAppPolicyFallback => 'यहाँ इन-ऐप नीति प्रदान करें।';

  @override
  String get crossBorderTitle => 'सीमापार डेटा हस्तांतरण सूचना';

  @override
  String get viewFullPolicy => 'पूर्ण नीति देखें';

  @override
  String get crossBorderFullText =>
      '• यह ऐप विज्ञापन प्रदाय और मापन के लिए तृतीय-पक्ष सेवाओं (उदा., Google AdMob) का उपयोग करता है; परिणामस्वरूप, आपका व्यक्तिगत डेटा आपके देश के बाहर स्थानांतरित किया जा सकता है।\n\n— प्राप्तकर्ता और संपर्क\n  · प्राप्तकर्ता: Google LLC और इसकी संबद्ध कंपनियां (AdMob प्रदाता)\n  · सेवा/भूमिका: विज्ञापन प्रदाय, विज्ञापन/मापन सुविधाओं का प्रावधान, संबंधित लॉग का प्रसंस्करण\n  · वेबसाइट: admob.google.com\n  · टिप्पणी: iOS पर विज्ञापन पहचानकर्ता (IDFA) का उपयोग प्लेटफ़ॉर्म नीतियों और उपयोगकर्ता की सहमति स्थिति पर निर्भर करता है।\n\n— गंतव्य देश\n  · संयुक्त राज्य अमेरिका तथा वे देश जहाँ Google या उसकी संबद्ध कंपनियों के पास डेटा प्रसंस्करण की क्षमता है (उदा., यूरोप, एशिया)\n\n— हस्तांतरण का समय और तरीका\n  · समय: ऐप लॉन्च होने पर और जब भी विज्ञापन अनुरोध/प्रदर्शन/क्लिक/मापन की आवश्यकता हो\n  · तरीका: नेटवर्क के माध्यम से प्रेषण, ट्रांज़िट एन्क्रिप्शन सहित (HTTPS/TLS)\n  · सुरक्षा उपाय: लागू अंतरराष्ट्रीय ट्रांसफ़र ढाँचों और संविदात्मक सुरक्षा (उदा., पर्याप्तता निर्णय, मानक संविदात्मक खंड) के अनुसार प्रसंस्करण\n\n— उद्देश्य और डेटा मदें\n  · उद्देश्य: विज्ञापन प्रदाय, निजीकरण विकल्प का सम्मान, प्रदर्शन मापन, सांख्यिकीय विश्लेषण, सेवा गुणवत्ता/स्थिरता में सुधार\n  · उदाहरण डेटा: विज्ञापन पहचानकर्ता (AAID/IDFA), ऐप संस्करण/सेटिंग्स, डिवाइस/नेटवर्क की मूलभूत जानकारी, कुकी-सदृश पहचानकर्ता, उपयोग लॉग (विज्ञापन अंतःक्रियाएँ तथा त्रुटियाँ/क्रैश सहित), क्षेत्र (शहर/देश स्तर) इत्यादि\n\n— भंडारण अवधि\n  · उद्देश्य की पूर्ति तक या लागू कानून द्वारा आवश्यक अवधि तक संग्रहीत, उसके बाद हटाया या डी-आईडेंटिफाई किया जाएगा\n\n— सहमति अस्वीकार/वापस लेने का अधिकार\n  · ऐप की “गोपनीयता विकल्प” में आप Non-Personalized Ads (NPA) चुन सकते हैं। EEA/UK/CH जैसी क्षेत्रों में CMP/UMP सहमति स्क्रीन के माध्यम से निजीकरण/गैर-निजीकरण का चयन और रीसेट संभव है।\n\n— संपर्क\n  · ई-मेल: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'मेटाडेटा संपादन चेतावनी';

  @override
  String get metadataRiskBody =>
      'MP3 के अलावा कुछ फ़ॉर्मैट में टैग/कवर एम्बेडिंग सीमित हो सकती है या प्लेयर के अनुसार अनुकूलता बदल सकती है, जिससे संपादन विफल हो सकता है।';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 iTunes atoms का उपयोग करते हैं, Ogg/Opus Vorbis Comment (PICTURE ब्लॉक) का उपयोग करते हैं, FLAC Vorbis Comment/PICTURE का उपयोग करता है, और WAV LIST-INFO का उपयोग करता है।';

  @override
  String get doNotShowAgain => 'दोबारा न दिखाएँ';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String paletteWidthFactor(String percent) {
    return 'चौड़ाई $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'ऊँचाई $percent%';
  }
}
