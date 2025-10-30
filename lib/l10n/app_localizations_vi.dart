// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get exitDialogTitle => 'Bạn có muốn thoát ứng dụng không?';

  @override
  String get adLabel => 'Quảng cáo';

  @override
  String get cancel => 'Hủy';

  @override
  String get exit => 'Thoát';

  @override
  String get adLoading => 'Đang tải quảng cáo...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'Siêu dữ liệu âm thanh — $fileName';
  }

  @override
  String get tooltipSaveAs => 'Lưu dưới dạng';

  @override
  String get tooltipNoChanges => 'Không có thay đổi';

  @override
  String get tooltipReload => 'Tải lại';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'Đã chọn bìa: $fileName';
  }

  @override
  String get btnClose => 'Đóng';

  @override
  String saveDone(Object displayName) {
    return 'Đã lưu: $displayName';
  }

  @override
  String get saveCancelled => 'Đã hủy lưu';

  @override
  String saveFailed(Object error) {
    return 'Lưu thất bại: $error';
  }

  @override
  String get hintNone => '(Không có)';

  @override
  String get metaLabelTitle => 'Tiêu đề';

  @override
  String get metaLabelArtist => 'Nghệ sĩ';

  @override
  String get metaLabelAlbum => 'Album';

  @override
  String get metaLabelGenre => 'Thể loại';

  @override
  String get metaLabelYear => 'Năm';

  @override
  String get metaLabelTrack => 'Track';

  @override
  String get metaLabelDisc => 'Đĩa';

  @override
  String get chooseActionTitle => 'Bạn muốn thực hiện thao tác nào?';

  @override
  String get chooseActionBody => 'Chọn một tùy chọn và thao tác sẽ chạy ngay.';

  @override
  String get actionEditOverlay => 'Thiết lập kích thước và vị trí';

  @override
  String get actionLoadSubtitles => 'Tải phụ đề';

  @override
  String get overlayPermissionNeeded =>
      'Cần quyền hiển thị phủ nổi. Vui lòng cho phép trong Cài đặt.';

  @override
  String get overlayWindowDenied => 'Quyền Overlay Window đã bị từ chối.';

  @override
  String get overlaySampleShort => 'Với đoạn ngắn';

  @override
  String get overlaySampleLong => 'Với đoạn dài';

  @override
  String get fontPickerTitle => 'Chọn cỡ chữ';

  @override
  String get commonCancel => 'Hủy';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonChange => 'Thay đổi';

  @override
  String get commonSettings => 'Cài đặt';

  @override
  String paletteFontLabel(Object size) {
    return 'Phông chữ $size';
  }

  @override
  String get paletteLockCenterX => 'Khóa tâm trục X';

  @override
  String get calibFixHint => 'Loại bỏ sai lệch (khóa overlay)';

  @override
  String get calibMergeHint => 'Chồng khớp (lưu vào hàng đợi Δ)';

  @override
  String get calibFix => 'Loại bỏ sai lệch';

  @override
  String get calibMerge => 'Chồng khớp';

  @override
  String get saveApplyDelta => 'Áp dụng giá trị hiệu chỉnh rồi lưu';

  @override
  String get hudCenterSuffix => '(Khóa tâm X)';

  @override
  String get webBack => 'Quay lại';

  @override
  String get webForward => 'Tiếp';

  @override
  String get webReload => 'Tải lại';

  @override
  String get webClose => 'Đóng';

  @override
  String get webAddressHint => 'Nhập hoặc dán địa chỉ';

  @override
  String get emptyLyrics => 'Không nhận được lời bài hát.';

  @override
  String get overlayHintDoubleTap => '* Chạm hai lần để đóng overlay.';

  @override
  String get overlayHintSwipe => '* Vuốt để chuyển trang.';

  @override
  String get menuPrivacy => 'Quyền riêng tư';

  @override
  String get menuPrivacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get menuPrivacyOptions => 'Tùy chọn quyền riêng tư cho quảng cáo';

  @override
  String get menuPrivacyOptionsSub =>
      'Thay đổi trạng thái đồng ý với quảng cáo cá nhân hóa';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'Không cần hiển thị trong khu vực/phiên hiện tại';

  @override
  String get openUrlFailed => 'Không thể mở URL';

  @override
  String get privacyClosed => 'Đã đóng màn hình tùy chọn quyền riêng tư';

  @override
  String get privacyNotAvailable => 'Không có biểu mẫu quyền riêng tư';

  @override
  String get privacyExplainer =>
      'Ứng dụng này sử dụng SDK quảng cáo để phân phối quảng cáo và cung cấp màn hình quản lý đồng ý tại các khu vực yêu cầu đồng ý.';

  @override
  String get privacyOptionsRequiredLabel =>
      'Tùy chọn quyền riêng tư (bắt buộc)';

  @override
  String get privacyOptionsNotRequiredLabel =>
      'Tùy chọn quyền riêng tư (không bắt buộc)';

  @override
  String get privacyOptionsUpdated => 'Đã cập nhật tùy chọn quyền riêng tư';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'Khu vực của bạn không cần hiển thị tùy chọn quyền riêng tư';

  @override
  String get openSource => 'Mã nguồn mở';

  @override
  String get openSourceGuideTitle => 'Thông báo mã nguồn mở';

  @override
  String get errorTitle => 'Lỗi';

  @override
  String readFileFailed(Object error) {
    return 'Không thể đọc tệp: $error';
  }

  @override
  String get privacySettingsTitle => 'Quyền riêng tư và cài đặt quảng cáo';

  @override
  String get consentSectionTitle => 'Đồng ý (CMP/UMP)';

  @override
  String get entryRequiredChip => 'Cần hiển thị';

  @override
  String get openPrivacyOptionsButton => 'Mở tùy chọn quyền riêng tư';

  @override
  String get consentRegionalNote =>
      'Người dùng EEA/UK/CH có thể quản lý đồng ý tại đây. Thay đổi sẽ áp dụng từ các yêu cầu quảng cáo tiếp theo.';

  @override
  String get adsPersonalizationTitle =>
      'Cá nhân hóa quảng cáo và dữ liệu theo khu vực';

  @override
  String get npaTitle => 'Luôn dùng quảng cáo không cá nhân hóa (NPA)';

  @override
  String get npaSubtitle => 'Luôn yêu cầu NPA';

  @override
  String get rdpTitle => 'US Restricted Data Processing (RDP)';

  @override
  String get rdpSubtitle =>
      'Tuân thủ luật tiểu bang Hoa Kỳ: thêm rdp=1 vào extras';

  @override
  String get childFlagsSectionTitle => 'Thẻ trẻ em/vị thành niên';

  @override
  String get coppaTitle => 'Dịch vụ hướng đến trẻ em (COPPA)';

  @override
  String get coppaSubtitle => 'Thẻ dịch vụ hướng đến trẻ em';

  @override
  String get uacTitle => 'Dưới độ tuổi đồng ý (UAC)';

  @override
  String get uacSubtitle => 'Thẻ vị thành niên (dưới độ tuổi đồng ý)';

  @override
  String get coppaNote =>
      'COPPA/UAC là cấu hình toàn cục của AdMob, có hiệu lực ngay và áp dụng cho các quảng cáo được tải sau đó.';

  @override
  String get policySectionTitle => 'Chính sách quyền riêng tư';

  @override
  String get viewInAppButton => 'Xem trong ứng dụng';

  @override
  String get openStorePolicyButton => 'Mở chính sách trên Store';

  @override
  String get policySectionNote =>
      'Vui lòng cung cấp cả URL chính sách trên Store và màn hình chính sách trong ứng dụng.';

  @override
  String get inAppPolicyTitle => 'Chính sách quyền riêng tư';

  @override
  String get inAppPolicyFallback =>
      'Cung cấp chính sách trong ứng dụng tại đây.';

  @override
  String get crossBorderTitle => 'Thông báo chuyển dữ liệu xuyên biên giới';

  @override
  String get viewFullPolicy => 'Xem chính sách đầy đủ';

  @override
  String get crossBorderFullText =>
      '• Ứng dụng này sử dụng dịch vụ của bên thứ ba (ví dụ: Google AdMob) để phân phát và đo lường quảng cáo; do đó dữ liệu cá nhân của bạn có thể được chuyển ra ngoài quốc gia của bạn.\n\n— Bên nhận và liên hệ\n  · Bên nhận: Google LLC và các công ty liên kết (nhà cung cấp AdMob)\n  · Dịch vụ/Vai trò: Phân phát quảng cáo, cung cấp chức năng quảng cáo/đo lường, xử lý nhật ký liên quan\n  · Trang web: admob.google.com\n  · Lưu ý: Trên iOS, việc sử dụng định danh quảng cáo (IDFA) phụ thuộc vào chính sách nền tảng và trạng thái đồng ý của người dùng.\n\n— Quốc gia/vùng lãnh thổ đích\n  · Hoa Kỳ và các quốc gia nơi Google hoặc công ty liên kết có năng lực xử lý dữ liệu (ví dụ: Châu Âu, Châu Á)\n\n— Thời điểm và phương thức chuyển\n  · Thời điểm: Khi khởi động ứng dụng và khi phát sinh yêu cầu/hiển thị/nhấp/đo lường quảng cáo theo nhu cầu\n  · Phương thức: Truyền qua mạng với mã hóa trong quá trình truyền (HTTPS/TLS)\n  · Biện pháp bảo vệ: Xử lý theo các khuôn khổ chuyển dữ liệu quốc tế áp dụng và các biện pháp bảo vệ theo hợp đồng (ví dụ: quyết định tương xứng, Điều khoản Hợp đồng Mẫu)\n\n— Mục đích và hạng mục dữ liệu\n  · Mục đích: Phân phát quảng cáo, tôn trọng lựa chọn cá nhân hóa, đo lường hiệu suất, phân tích thống kê, cải thiện chất lượng/độ ổn định dịch vụ\n  · Ví dụ dữ liệu: Định danh quảng cáo (AAID/IDFA), phiên bản/cài đặt ứng dụng, thông tin cơ bản về thiết bị/mạng, định danh tương tự cookie, nhật ký sử dụng (bao gồm tương tác quảng cáo và lỗi/sập), khu vực (cấp thành phố/quốc gia), v.v.\n\n— Thời hạn lưu trữ\n  · Lưu trữ cho đến khi đạt mục đích hoặc theo thời hạn do luật áp dụng quy định; sau đó xóa hoặc ẩn danh\n\n— Quyền từ chối và rút lại sự đồng ý\n  · Bạn có thể chọn Quảng cáo không cá nhân hóa (NPA) trong “Tùy chọn quyền riêng tư” của ứng dụng. Ở các khu vực như EEA/Vương quốc Anh/Thụy Sĩ, màn hình xin đồng ý CMP/UMP cho phép chọn quảng cáo cá nhân hóa/không cá nhân hóa và đặt lại lựa chọn.\n\n— Liên hệ\n  · Email: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'Cảnh báo chỉnh sửa siêu dữ liệu';

  @override
  String get metadataRiskBody =>
      'Một số định dạng ngoài MP3 có thể giới hạn việc nhúng thẻ/bìa hoặc có khả năng tương thích khác nhau tùy trình phát, khiến việc chỉnh sửa có thể thất bại.';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 dùng iTunes atoms, Ogg/Opus dùng Vorbis Comment (khối PICTURE), FLAC dùng Vorbis Comment/PICTURE và WAV dùng LIST-INFO.';

  @override
  String get doNotShowAgain => 'Không hiển thị lại';

  @override
  String get continueLabel => 'Tiếp tục';

  @override
  String paletteWidthFactor(String percent) {
    return 'Chiều rộng $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'Chiều cao $percent%';
  }
}
