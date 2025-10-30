// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get exitDialogTitle => 'Ingin keluar dari aplikasi?';

  @override
  String get adLabel => 'Iklan';

  @override
  String get cancel => 'Batal';

  @override
  String get exit => 'Keluar';

  @override
  String get adLoading => 'Memuat iklan...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Metadata audio — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Simpan sebagai';

  @override
  String get tooltipNoChanges => 'Tidak ada perubahan';

  @override
  String get tooltipReload => 'Muat ulang';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Sampul dipilih: $fileName';
  }

  @override
  String get btnClose => 'Tutup';

  @override
  String saveDone(Object displayName) {
    return 'Tersimpan: $displayName';
  }

  @override
  String get saveCancelled => 'Penyimpanan dibatalkan';

  @override
  String saveFailed(Object error) {
    return 'Gagal menyimpan: $error';
  }

  @override
  String get hintNone => '(Tidak ada)';

  @override
  String get metaLabelTitle => 'Judul';

  @override
  String get metaLabelArtist => 'Artis';

  @override
  String get metaLabelAlbum => 'Album';

  @override
  String get metaLabelGenre => 'Genre';

  @override
  String get metaLabelYear => 'Tahun';

  @override
  String get metaLabelTrack => 'Trek';

  @override
  String get metaLabelDisc => 'Cakram';

  @override
  String get chooseActionTitle => 'Tindakan apa yang ingin dijalankan?';

  @override
  String get chooseActionBody => 'Memilih salah satu akan langsung dijalankan.';

  @override
  String get actionEditOverlay => 'Atur ukuran dan posisi';

  @override
  String get actionLoadSubtitles => 'Muat subtitle';

  @override
  String get overlayPermissionNeeded =>
      'Izin overlay diperlukan. Aktifkan di Pengaturan.';

  @override
  String get overlayWindowDenied => 'Izin Overlay Window ditolak.';

  @override
  String get overlaySampleShort => 'Untuk teks pendek';

  @override
  String get overlaySampleLong => 'Untuk teks panjang';

  @override
  String get fontPickerTitle => 'Pilih ukuran font';

  @override
  String get commonCancel => 'Batal';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Simpan';

  @override
  String get commonChange => 'Ubah';

  @override
  String get commonSettings => 'Pengaturan';

  @override
  String paletteFontLabel(Object size) {
    return 'Ukuran font $size';
  }

  @override
  String get paletteLockCenterX => 'Kunci tengah X';

  @override
  String get calibFixHint => 'Hilangkan offset (kunci overlay)';

  @override
  String get calibMergeHint => 'Gabungkan (simpan ke antrian Δ)';

  @override
  String get calibFix => 'Hilangkan offset';

  @override
  String get calibMerge => 'Gabungkan';

  @override
  String get saveApplyDelta => 'Terapkan koreksi lalu simpan';

  @override
  String get hudCenterSuffix => '(Pusat X terkunci)';

  @override
  String get webBack => 'Kembali';

  @override
  String get webForward => 'Maju';

  @override
  String get webReload => 'Muat ulang';

  @override
  String get webClose => 'Tutup';

  @override
  String get webAddressHint => 'Masukkan atau tempel alamat';

  @override
  String get emptyLyrics => 'Lirik tidak diterima.';

  @override
  String get overlayHintDoubleTap => '* Ketuk dua kali untuk menutup overlay.';

  @override
  String get overlayHintSwipe => '* Geser untuk mengganti halaman.';

  @override
  String get menuPrivacy => 'Privasi';

  @override
  String get menuPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get menuPrivacyOptions => 'Opsi privasi iklan';

  @override
  String get menuPrivacyOptionsSub =>
      'Ubah status persetujuan untuk iklan yang dipersonalisasi';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'Tidak perlu ditampilkan untuk wilayah/sesi saat ini';

  @override
  String get openUrlFailed => 'Tidak dapat membuka URL';

  @override
  String get privacyClosed => 'Layar opsi privasi ditutup';

  @override
  String get privacyNotAvailable => 'Formulir privasi tidak tersedia';

  @override
  String get privacyExplainer =>
      'Aplikasi ini menggunakan SDK iklan untuk menayangkan iklan dan menampilkan layar pengelolaan persetujuan di wilayah yang mewajibkannya.';

  @override
  String get privacyOptionsRequiredLabel => 'Opsi privasi (diperlukan)';

  @override
  String get privacyOptionsNotRequiredLabel =>
      'Opsi privasi (tidak diperlukan)';

  @override
  String get privacyOptionsUpdated => 'Opsi privasi telah diperbarui';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'Opsi privasi tidak diperlukan di wilayah Anda';

  @override
  String get openSource => 'Sumber terbuka';

  @override
  String get openSourceGuideTitle => 'Pemberitahuan sumber terbuka';

  @override
  String get errorTitle => 'Kesalahan';

  @override
  String readFileFailed(Object error) {
    return 'Gagal membaca file: $error';
  }

  @override
  String get privacySettingsTitle => 'Privasi dan pengaturan iklan';

  @override
  String get consentSectionTitle => 'Persetujuan (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Perlu ditampilkan';

  @override
  String get openPrivacyOptionsButton => 'Buka opsi privasi';

  @override
  String get consentRegionalNote =>
      'Pengguna EEA/UK/CH dapat mengelola persetujuan di sini. Perubahan berlaku mulai permintaan iklan berikutnya.';

  @override
  String get adsPersonalizationTitle => 'Personalisasi iklan dan data regional';

  @override
  String get npaTitle => 'Selalu iklan non-pribadi (NPA)';

  @override
  String get npaSubtitle => 'Selalu minta NPA';

  @override
  String get rdpTitle => 'US Restricted Data Processing (RDP)';

  @override
  String get rdpSubtitle =>
      'Kepatuhan hukum negara bagian AS: tambahkan rdp=1 pada extras';

  @override
  String get childFlagsSectionTitle => 'Tag anak/di bawah umur';

  @override
  String get coppaTitle => 'Layanan untuk anak (COPPA)';

  @override
  String get coppaSubtitle => 'Tag layanan yang ditujukan untuk anak';

  @override
  String get uacTitle => 'Di bawah usia persetujuan (UAC)';

  @override
  String get uacSubtitle => 'Tag di bawah umur (di bawah usia persetujuan)';

  @override
  String get coppaNote =>
      'COPPA/UAC adalah konfigurasi global AdMob, berlaku segera dan diterapkan pada iklan yang dimuat setelahnya.';

  @override
  String get policySectionTitle => 'Kebijakan Privasi';

  @override
  String get viewInAppButton => 'Lihat di dalam aplikasi';

  @override
  String get openStorePolicyButton => 'Buka kebijakan di Store';

  @override
  String get policySectionNote =>
      'Sediakan URL kebijakan di Store dan juga layar kebijakan di dalam aplikasi.';

  @override
  String get inAppPolicyTitle => 'Kebijakan Privasi';

  @override
  String get inAppPolicyFallback =>
      'Tampilkan kebijakan dalam aplikasi di sini.';

  @override
  String get crossBorderTitle => 'Pemberitahuan Transfer Data Lintas Negara';

  @override
  String get viewFullPolicy => 'Lihat kebijakan lengkap';

  @override
  String get crossBorderFullText =>
      '• Aplikasi ini menggunakan layanan pihak ketiga (mis. Google AdMob) untuk penayangan dan pengukuran iklan. Akibatnya, data pribadi Anda dapat ditransfer ke luar negara Anda.\n\n— Penerima dan kontak\n  · Penerima: Google LLC dan afiliasinya (penyedia AdMob)\n  · Layanan/Peran: Penayangan iklan, penyediaan fitur iklan/pengukuran, pemrosesan log terkait\n  · Situs web: admob.google.com\n  · Catatan: Di iOS, penggunaan pengenal iklan (IDFA) bergantung pada kebijakan platform dan status persetujuan pengguna.\n\n— Negara tujuan\n  · Amerika Serikat dan negara lain tempat Google atau afiliasinya memiliki kemampuan pemrosesan data (mis. Eropa, Asia)\n\n— Waktu dan metode transfer\n  · Waktu: Saat aplikasi diluncurkan serta ketika permintaan/penayangan/klik/pengukuran iklan terjadi sesuai kebutuhan\n  · Metode: Transmisi jaringan dengan enkripsi selama transit (HTTPS/TLS)\n  · Perlindungan: Diproses sesuai kerangka transfer internasional yang berlaku dan perlindungan kontraktual (mis. keputusan kecukupan, Klausul Kontrak Standar)\n\n— Tujuan dan jenis data\n  · Tujuan: Penayangan iklan, menghormati pilihan personalisasi, pengukuran kinerja, analisis statistik, peningkatan kualitas/stabilitas layanan\n  · Contoh data: Pengenal iklan (AAID/IDFA), versi/pengaturan aplikasi, informasi dasar perangkat/jaringan, pengenal mirip cookie, log penggunaan (termasuk interaksi iklan serta error/crash), wilayah (level kota/negara), dll.\n\n— Periode penyimpanan\n  · Disimpan hingga tujuan tercapai atau selama periode yang disyaratkan hukum berlaku, kemudian dihapus atau dianonimkan\n\n— Hak untuk menolak atau menarik persetujuan\n  · Anda dapat memilih Iklan Non-Personalisasi (NPA) di “Opsi privasi” aplikasi. Di wilayah seperti EEA/UK/CH, layar persetujuan CMP/UMP memungkinkan pilihan iklan personalisasi/non-personaliasi dan pengaturan ulang pilihan.\n\n— Kontak\n  · Email: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Peringatan Pengeditan Metadata';

  @override
  String get metadataRiskBody =>
      'Beberapa format selain MP3 membatasi penyisipan tag/sampul atau memiliki kompatibilitas yang berbeda antar pemutar, sehingga pengeditan bisa gagal.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 menggunakan iTunes atoms, Ogg/Opus menggunakan Vorbis Comment (blok PICTURE), FLAC menggunakan Vorbis Comment/PICTURE, dan WAV menggunakan LIST-INFO.';

  @override
  String get doNotShowAgain => 'Jangan tampilkan lagi';

  @override
  String get continueLabel => 'Lanjutkan';

  @override
  String paletteWidthFactor(String percent) {
    return 'Lebar $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Tinggi $percent%';
  }
}
