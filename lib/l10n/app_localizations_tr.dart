// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get exitDialogTitle => 'Uygulamadan çıkmak istiyor musunuz?';

  @override
  String get adLabel => 'Reklam';

  @override
  String get cancel => 'İptal';

  @override
  String get exit => 'Çıkış';

  @override
  String get adLoading => 'Reklam yükleniyor...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Ses meta verileri — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Farklı kaydet';

  @override
  String get tooltipNoChanges => 'Değişiklik yok';

  @override
  String get tooltipReload => 'Yeniden yükle';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Kapak seçildi: $fileName';
  }

  @override
  String get btnClose => 'Kapat';

  @override
  String saveDone(Object displayName) {
    return 'Kaydedildi: $displayName';
  }

  @override
  String get saveCancelled => 'Kaydetme iptal edildi';

  @override
  String saveFailed(Object error) {
    return 'Kaydetme başarısız: $error';
  }

  @override
  String get hintNone => '(Yok)';

  @override
  String get metaLabelTitle => 'Başlık';

  @override
  String get metaLabelArtist => 'Sanatçı';

  @override
  String get metaLabelAlbum => 'Albüm';

  @override
  String get metaLabelGenre => 'Tür';

  @override
  String get metaLabelYear => 'Yıl';

  @override
  String get metaLabelTrack => 'Parça';

  @override
  String get metaLabelDisc => 'Disk';

  @override
  String get chooseActionTitle => 'Hangi işlemi yürütmek istersiniz?';

  @override
  String get chooseActionBody => 'Seçilen seçenek hemen çalıştırılır.';

  @override
  String get actionEditOverlay => 'Boyut ve konumu ayarla';

  @override
  String get actionLoadSubtitles => 'Altyazı yükle';

  @override
  String get overlayPermissionNeeded =>
      'Overlay izni gerekli. Lütfen Ayarlar’dan izin verin.';

  @override
  String get overlayWindowDenied => 'Overlay penceresi izni reddedildi.';

  @override
  String get overlaySampleShort => 'Kısa metin için';

  @override
  String get overlaySampleLong => 'Uzun metin için';

  @override
  String get fontPickerTitle => 'Yazı tipi boyutu seç';

  @override
  String get commonCancel => 'İptal';

  @override
  String get commonOk => 'Tamam';

  @override
  String get commonSave => 'Kaydet';

  @override
  String get commonChange => 'Değiştir';

  @override
  String get commonSettings => 'Ayarlar';

  @override
  String paletteFontLabel(Object size) {
    return 'Yazı tipi $size';
  }

  @override
  String get paletteLockCenterX => 'X ekseni merkezini kilitle';

  @override
  String get calibFixHint => 'Ofseti kaldır (overlay’i kilitle)';

  @override
  String get calibMergeHint => 'Birleştir (Δ kuyruğuna kaydet)';

  @override
  String get calibFix => 'Ofseti kaldır';

  @override
  String get calibMerge => 'Birleştir';

  @override
  String get saveApplyDelta => 'Düzeltmeyi uygula ve kaydet';

  @override
  String get hudCenterSuffix => '(X merkezi kilitli)';

  @override
  String get webBack => 'Geri';

  @override
  String get webForward => 'İleri';

  @override
  String get webReload => 'Yenile';

  @override
  String get webClose => 'Kapat';

  @override
  String get webAddressHint => 'Adres girin veya yapıştırın';

  @override
  String get emptyLyrics => 'Şarkı sözleri alınamadı.';

  @override
  String get overlayHintDoubleTap =>
      '* Overlay’i kapatmak için iki kez dokunun.';

  @override
  String get overlayHintSwipe => '* Sayfa değiştirmek için kaydırın.';

  @override
  String get menuPrivacy => 'Gizlilik';

  @override
  String get menuPrivacyPolicy => 'Gizlilik Politikası';

  @override
  String get menuPrivacyOptions => 'Reklam gizlilik seçenekleri';

  @override
  String get menuPrivacyOptionsSub =>
      'Kişiselleştirilmiş reklam onayını değiştirin';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'Geçerli bölge/oturum için gösterim gerekli değil';

  @override
  String get openUrlFailed => 'URL açılamıyor';

  @override
  String get privacyClosed => 'Gizlilik seçenekleri ekranı kapatıldı';

  @override
  String get privacyNotAvailable => 'Gizlilik formu kullanılamıyor';

  @override
  String get privacyExplainer =>
      'Bu uygulama reklam sunmak için bir reklam SDK’sı kullanır ve onayın gerekli olduğu bölgelerde bir onay yönetim ekranı sağlar.';

  @override
  String get privacyOptionsRequiredLabel => 'Gizlilik seçenekleri (gerekli)';

  @override
  String get privacyOptionsNotRequiredLabel =>
      'Gizlilik seçenekleri (gerekli değil)';

  @override
  String get privacyOptionsUpdated => 'Gizlilik seçenekleri güncellendi';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'Bulunduğunuz bölgede gizlilik seçeneklerinin gösterilmesi gerekli değil';

  @override
  String get openSource => 'Açık kaynak';

  @override
  String get openSourceGuideTitle => 'Açık kaynak bilgilendirmesi';

  @override
  String get errorTitle => 'Hata';

  @override
  String readFileFailed(Object error) {
    return 'Dosya okunamadı: $error';
  }

  @override
  String get privacySettingsTitle => 'Gizlilik ve reklam ayarları';

  @override
  String get consentSectionTitle => 'Onay (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Gösterim gerekli';

  @override
  String get openPrivacyOptionsButton => 'Gizlilik seçeneklerini aç';

  @override
  String get consentRegionalNote =>
      'AEA/UK/CH kullanıcıları onayı buradan yönetebilir. Değişiklikler sonraki reklam isteklerinden itibaren geçerlidir.';

  @override
  String get adsPersonalizationTitle =>
      'Reklam kişiselleştirme ve bölgesel veriler';

  @override
  String get npaTitle => 'Her zaman kişisel olmayan reklamlar (NPA)';

  @override
  String get npaSubtitle => 'Her zaman NPA iste';

  @override
  String get rdpTitle => 'ABD Kısıtlı Veri İşleme (RDP)';

  @override
  String get rdpSubtitle => 'ABD eyalet yasalarına uyum: ekstralara rdp=1 ekle';

  @override
  String get childFlagsSectionTitle => 'Çocuk/reşit olmayan etiketleri';

  @override
  String get coppaTitle => 'Çocuklara yönelik hizmet (COPPA)';

  @override
  String get coppaSubtitle => 'Çocuk hedefli hizmet etiketi';

  @override
  String get uacTitle => 'Onay yaşının altında (UAC)';

  @override
  String get uacSubtitle => 'Reşit olmayan (onay yaşının altında) etiketi';

  @override
  String get coppaNote =>
      'COPPA/UAC, AdMob’un küresel yapılandırmasıdır; anında yürürlüğe girer ve bundan sonra yüklenecek reklamlara uygulanır.';

  @override
  String get policySectionTitle => 'Gizlilik Politikası';

  @override
  String get viewInAppButton => 'Uygulama içinde görüntüle';

  @override
  String get openStorePolicyButton => 'Mağaza politikasını aç';

  @override
  String get policySectionNote =>
      'Mağaza politika URL’sini ve uygulama içi politika ekranını birlikte sağlayın.';

  @override
  String get inAppPolicyTitle => 'Gizlilik Politikası';

  @override
  String get inAppPolicyFallback => 'Uygulama içi politikayı burada sağlayın.';

  @override
  String get crossBorderTitle => 'Sınır Ötesi Veri Aktarımı Bildirimi';

  @override
  String get viewFullPolicy => 'Tüm politikayı görüntüle';

  @override
  String get crossBorderFullText =>
      '• Bu uygulama, reklam sunumu ve ölçümü için üçüncü taraf hizmetler (örn. Google AdMob) kullanır; bunun sonucunda kişisel verileriniz ülke dışına aktarılabilir.\n\n— Alıcı ve iletişim\n  · Alıcı: Google LLC ve bağlı kuruluşları (AdMob sağlayıcısı)\n  · Hizmet/Rol: Reklamların yayınlanması, reklam/ölçüm işlevlerinin sağlanması, ilgili günlüklerin işlenmesi\n  · Web sitesi: admob.google.com\n  · Not: iOS’ta reklam tanımlayıcısının (IDFA) kullanımı, platform politikalarına ve kullanıcının rıza durumuna bağlıdır.\n\n— Alıcı ülkeler\n  · Amerika Birleşik Devletleri ve Google’ın veya bağlı kuruluşlarının veri işleme kapasitesine sahip olduğu ülkeler (örn. Avrupa, Asya)\n\n— Aktarım zamanı ve yöntemi\n  · Zaman: Uygulama açıldığında ve gerekli olduğunda reklam isteği/gösterimi/tıklaması/ölçümü gerçekleştiğinde\n  · Yöntem: Ağ üzerinden aktarım ve aktarım sırasında şifreleme (HTTPS/TLS)\n  · Güvenlik önlemleri: Uygulanabilir uluslararası aktarım çerçeveleri ve sözleşmesel korumalar uyarınca işleme (örn. yeterlilik kararları, Standart Sözleşme Maddeleri)\n\n— Amaçlar ve veri öğeleri\n  · Amaçlar: Reklam sunumu, kişiselleştirme tercihine uygunluk, performans ölçümü, istatistiksel analiz, hizmet kalitesi/kararlılığının iyileştirilmesi\n  · Örnek veri öğeleri: Reklam tanımlayıcıları (AAID/IDFA), uygulama sürümü/ayarları, temel cihaz/ağ bilgileri, çerez benzeri tanımlayıcılar, kullanım günlükleri (reklam etkileşimleri ve hata/çökme kayıtları dahil), bölge (şehir/ülke düzeyi) vb.\n\n— Saklama süresi\n  · Amaçlar gerçekleştirilene kadar veya yürürlükteki hukukta öngörülen süre boyunca saklanır; sonrasında silinir veya kimliği giderilir\n\n— Reddetme ve rızayı geri çekme hakkı\n  · Uygulamanın “Gizlilik seçenekleri” bölümünde Kişisel Olmayan Reklamları (NPA) seçebilirsiniz. AEA/Birleşik Krallık/İsviçre gibi bölgelerde CMP/UMP rıza ekranı, kişiselleştirilmiş/kişisel olmayan reklam tercihini seçme ve sıfırlama imkanı sunar.\n\n— İletişim\n  · E-posta: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Meta Veri Düzenleme Uyarısı';

  @override
  String get metadataRiskBody =>
      'MP3 dışındaki bazı biçimlerde etiket/kapak gömme kısıtlı olabilir veya oynatıcıya göre uyumluluk değişebilir; bu nedenle düzenleme başarısız olabilir.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 iTunes atoms kullanır, Ogg/Opus Vorbis Comment (PICTURE bloğu) kullanır, FLAC Vorbis Comment/PICTURE kullanır ve WAV LIST-INFO kullanır.';

  @override
  String get doNotShowAgain => 'Bir daha gösterme';

  @override
  String get continueLabel => 'Devam';

  @override
  String paletteWidthFactor(String percent) {
    return 'Genişlik $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Yükseklik $percent%';
  }
}
