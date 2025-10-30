// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get exitDialogTitle => 'ต้องการออกจากแอปหรือไม่?';

  @override
  String get adLabel => 'โฆษณา';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get exit => 'ออก';

  @override
  String get adLoading => 'กำลังโหลดโฆษณา...';

  @override
  String audioMetadataTitle(Object fileName) {
    return 'ข้อมูลเมตาเสียง — $fileName';
  }

  @override
  String get tooltipSaveAs => 'บันทึกเป็น';

  @override
  String get tooltipNoChanges => 'ไม่มีการเปลี่ยนแปลง';

  @override
  String get tooltipReload => 'โหลดใหม่';

  @override
  String bannerCoverSelected(Object fileName) {
    return 'เลือกปกแล้ว: $fileName';
  }

  @override
  String get btnClose => 'ปิด';

  @override
  String saveDone(Object displayName) {
    return 'บันทึกแล้ว: $displayName';
  }

  @override
  String get saveCancelled => 'ยกเลิกการบันทึก';

  @override
  String saveFailed(Object error) {
    return 'บันทึกล้มเหลว: $error';
  }

  @override
  String get hintNone => '(ไม่มี)';

  @override
  String get metaLabelTitle => 'ชื่อเรื่อง';

  @override
  String get metaLabelArtist => 'ศิลปิน';

  @override
  String get metaLabelAlbum => 'อัลบั้ม';

  @override
  String get metaLabelGenre => 'แนวเพลง';

  @override
  String get metaLabelYear => 'ปี';

  @override
  String get metaLabelTrack => 'แทร็ก';

  @override
  String get metaLabelDisc => 'ดิสก์';

  @override
  String get chooseActionTitle => 'ต้องการดำเนินการใด?';

  @override
  String get chooseActionBody => 'เมื่อเลือกแล้วจะเริ่มทำงานทันที';

  @override
  String get actionEditOverlay => 'ตั้งค่าขนาดและตำแหน่ง';

  @override
  String get actionLoadSubtitles => 'โหลดคำบรรยาย';

  @override
  String get overlayPermissionNeeded =>
      'ต้องการสิทธิ์โอเวอร์เลย์ โปรดอนุญาตในการตั้งค่า';

  @override
  String get overlayWindowDenied => 'ถูกปฏิเสธสิทธิ์หน้าต่างโอเวอร์เลย์';

  @override
  String get overlaySampleShort => 'สำหรับข้อความสั้น';

  @override
  String get overlaySampleLong => 'สำหรับข้อความยาว';

  @override
  String get fontPickerTitle => 'เลือกขนาดฟอนต์';

  @override
  String get commonCancel => 'ยกเลิก';

  @override
  String get commonOk => 'ตกลง';

  @override
  String get commonSave => 'บันทึก';

  @override
  String get commonChange => 'เปลี่ยน';

  @override
  String get commonSettings => 'การตั้งค่า';

  @override
  String paletteFontLabel(Object size) {
    return 'ฟอนต์ $size';
  }

  @override
  String get paletteLockCenterX => 'ล็อกกึ่งกลางแกน X';

  @override
  String get calibFixHint => 'ลบความคลาดเคลื่อน (ล็อกโอเวอร์เลย์)';

  @override
  String get calibMergeHint => 'ซ้อนทับ (บันทึกในคิว Δ)';

  @override
  String get calibFix => 'ลบความคลาดเคลื่อน';

  @override
  String get calibMerge => 'ซ้อนทับ';

  @override
  String get saveApplyDelta => 'ใช้ค่าการปรับแก้แล้วบันทึก';

  @override
  String get hudCenterSuffix => '(ล็อกกึ่งกลางแกน X)';

  @override
  String get webBack => 'ย้อนกลับ';

  @override
  String get webForward => 'เดินหน้า';

  @override
  String get webReload => 'โหลดใหม่';

  @override
  String get webClose => 'ปิด';

  @override
  String get webAddressHint => 'ป้อนหรือวางที่อยู่';

  @override
  String get emptyLyrics => 'ไม่ได้รับเนื้อเพลง';

  @override
  String get overlayHintDoubleTap => '* แตะสองครั้งเพื่อปิดโอเวอร์เลย์';

  @override
  String get overlayHintSwipe => '* ปัดเพื่อเปลี่ยนหน้า';

  @override
  String get menuPrivacy => 'ความเป็นส่วนตัว';

  @override
  String get menuPrivacyPolicy => 'นโยบายความเป็นส่วนตัว';

  @override
  String get menuPrivacyOptions => 'ตัวเลือกความเป็นส่วนตัวของโฆษณา';

  @override
  String get menuPrivacyOptionsSub =>
      'เปลี่ยนสถานะความยินยอมสำหรับโฆษณาที่ปรับให้เป็นส่วนบุคคล';

  @override
  String get menuPrivacyOptionsNotRequired =>
      'ไม่จำเป็นต้องแสดงในภูมิภาค/เซสชันปัจจุบัน';

  @override
  String get openUrlFailed => 'ไม่สามารถเปิด URL ได้';

  @override
  String get privacyClosed => 'ปิดหน้าตัวเลือกความเป็นส่วนตัวแล้ว';

  @override
  String get privacyNotAvailable => 'ไม่สามารถใช้แบบฟอร์มความเป็นส่วนตัวได้';

  @override
  String get privacyExplainer =>
      'แอปนี้ใช้ SDK โฆษณาเพื่อแสดงโฆษณา และจัดให้มีหน้าจอจัดการความยินยอมในภูมิภาคที่ต้องขอความยินยอม';

  @override
  String get privacyOptionsRequiredLabel => 'ตัวเลือกความเป็นส่วนตัว (จำเป็น)';

  @override
  String get privacyOptionsNotRequiredLabel =>
      'ตัวเลือกความเป็นส่วนตัว (ไม่จำเป็น)';

  @override
  String get privacyOptionsUpdated => 'อัปเดตตัวเลือกความเป็นส่วนตัวแล้ว';

  @override
  String get privacyOptionsNotRequiredSnack =>
      'ในภูมิภาคของคุณไม่จำเป็นต้องแสดงตัวเลือกความเป็นส่วนตัว';

  @override
  String get openSource => 'โอเพนซอร์ส';

  @override
  String get openSourceGuideTitle => 'ประกาศโอเพนซอร์ส';

  @override
  String get errorTitle => 'ข้อผิดพลาด';

  @override
  String readFileFailed(Object error) {
    return 'ไม่สามารถอ่านไฟล์ได้: $error';
  }

  @override
  String get privacySettingsTitle => 'การตั้งค่าความเป็นส่วนตัวและโฆษณา';

  @override
  String get consentSectionTitle => 'ความยินยอม (CMP/UMP)';

  @override
  String get entryRequiredChip => 'ต้องแสดง';

  @override
  String get openPrivacyOptionsButton => 'เปิดตัวเลือกความเป็นส่วนตัว';

  @override
  String get consentRegionalNote =>
      'ผู้ใช้ EEA/UK/CH จัดการความยินยอมได้ที่นี่ การเปลี่ยนแปลงมีผลกับคำขอโฆษณาถัดไป';

  @override
  String get adsPersonalizationTitle =>
      'การปรับโฆษณาให้เป็นส่วนบุคคลและข้อมูลตามภูมิภาค';

  @override
  String get npaTitle => 'แสดงโฆษณาที่ไม่ปรับให้เป็นส่วนบุคคลเสมอ (NPA)';

  @override
  String get npaSubtitle => 'ร้องขอ NPA เสมอ';

  @override
  String get rdpTitle => 'US Restricted Data Processing (RDP)';

  @override
  String get rdpSubtitle =>
      'ปฏิบัติตามกฎหมายของรัฐในสหรัฐ: เพิ่ม rdp=1 ใน extras';

  @override
  String get childFlagsSectionTitle => 'แท็กเด็ก/ผู้เยาว์';

  @override
  String get coppaTitle => 'บริการที่มุ่งเป้าไปยังเด็ก (COPPA)';

  @override
  String get coppaSubtitle => 'แท็กสำหรับบริการที่มุ่งเป้าไปยังเด็ก';

  @override
  String get uacTitle => 'อายุต่ำกว่าที่ให้ความยินยอมได้ (UAC)';

  @override
  String get uacSubtitle => 'แท็กผู้เยาว์ (อายุต่ำกว่าที่ให้ความยินยอมได้)';

  @override
  String get coppaNote =>
      'COPPA/UAC เป็นการกำหนดค่าระดับโลกของ AdMob มีผลทันทีและใช้กับโฆษณาที่โหลดหลังจากนั้น';

  @override
  String get policySectionTitle => 'นโยบายความเป็นส่วนตัว';

  @override
  String get viewInAppButton => 'ดูในแอป';

  @override
  String get openStorePolicyButton => 'เปิดนโยบายบนสโตร์';

  @override
  String get policySectionNote =>
      'โปรดระบุทั้ง URL นโยบายบนสโตร์และหน้าจอนโยบายภายในแอป';

  @override
  String get inAppPolicyTitle => 'นโยบายความเป็นส่วนตัว';

  @override
  String get inAppPolicyFallback => 'โปรดระบุนโยบายภายในแอปที่นี่';

  @override
  String get crossBorderTitle => 'ประกาศการโอนข้อมูลข้ามพรมแดน';

  @override
  String get viewFullPolicy => 'ดูนโยบายฉบับเต็ม';

  @override
  String get crossBorderFullText =>
      '• แอปนี้ใช้บริการของบุคคลที่สาม (เช่น Google AdMob) เพื่อการแสดงและการวัดผลโฆษณา ซึ่งอาจทำให้มีการโอนข้อมูลส่วนบุคคลของคุณไปยังต่างประเทศ\n\n— ผู้รับและข้อมูลติดต่อ\n  · ผู้รับ: Google LLC และบริษัทในเครือ (ผู้ให้บริการ AdMob)\n  · บริการ/บทบาท: การแสดงโฆษณา การให้ฟังก์ชันโฆษณา/การวัดผล การประมวลผลบันทึกที่เกี่ยวข้อง\n  · เว็บไซต์: admob.google.com\n  · หมายเหตุ: บน iOS การใช้ตัวระบุโฆษณา (IDFA) ขึ้นอยู่กับนโยบายของแพลตฟอร์มและสถานะความยินยอมของผู้ใช้\n\n— ประเทศปลายทาง\n  · สหรัฐอเมริกาและประเทศที่ Google หรือบริษัทในเครือมีขีดความสามารถในการประมวลผลข้อมูล (เช่น ยุโรป เอเชีย)\n\n— เวลาและวิธีการโอน\n  · เวลา: เมื่อเปิดแอป และเมื่อมีการร้องขอโฆษณา/แสดงผล/คลิก/การวัดผล ตามความจำเป็น\n  · วิธีการ: ส่งผ่านเครือข่าย พร้อมการเข้ารหัสระหว่างทาง (HTTPS/TLS)\n  · มาตรการคุ้มครอง: ดำเนินการตามกรอบการโอนข้อมูลระหว่างประเทศที่เกี่ยวข้องและการคุ้มครองตามสัญญา (เช่น คำตัดสินความเพียงพอ มาตราข้อตกลงมาตรฐาน)\n\n— วัตถุประสงค์และรายการข้อมูล\n  · วัตถุประสงค์: การแสดงโฆษณา เคารพตัวเลือกการปรับให้เป็นแบบเฉพาะบุคคล การวัดประสิทธิภาพ การวิเคราะห์ทางสถิติ ปรับปรุงคุณภาพ/ความเสถียรของบริการ\n  · ตัวอย่างข้อมูล: ตัวระบุโฆษณา (AAID/IDFA), เวอร์ชัน/การตั้งค่าแอป, ข้อมูลพื้นฐานของอุปกรณ์/เครือข่าย, ตัวระบุที่คล้ายคุกกี้, บันทึกการใช้งาน (รวมการโต้ตอบกับโฆษณาและข้อผิดพลาด/การล่ม), พื้นที่ (ระดับเมือง/ประเทศ) เป็นต้น\n\n— ระยะเวลาเก็บรักษา\n  · เก็บรักษาจนบรรลุวัตถุประสงค์ หรือเป็นระยะเวลาตามที่กฎหมายกำหนด จากนั้นลบหรือทำให้ไม่สามารถระบุตัวบุคคลได้\n\n— สิทธิในการปฏิเสธหรือถอนความยินยอม\n  · คุณสามารถเลือกโฆษณาแบบไม่ปรับให้เป็นแบบเฉพาะบุคคล (NPA) ได้ใน “ตัวเลือกความเป็นส่วนตัว” ของแอป สำหรับภูมิภาคเช่น EEA/สหราชอาณาจักร/สวิตเซอร์แลนด์ หน้าจอขอความยินยอมของ CMP/UMP ช่วยให้เลือกโฆษณาแบบปรับ/ไม่ปรับและรีเซ็ตตัวเลือกได้\n\n— ติดต่อเรา\n  · อีเมล: g.ns.0700g@gmail.com';

  @override
  String get warningTitle => 'คำเตือนการแก้ไขเมตาดาตา';

  @override
  String get metadataRiskBody =>
      'รูปแบบบางชนิดที่ไม่ใช่ MP3 อาจจำกัดการฝังแท็ก/ปก หรือมีความเข้ากันได้ต่างกันตามเครื่องเล่น ทำให้การแก้ไขล้มเหลวได้';

  @override
  String get metadataRiskFormatsDetail =>
      'M4A/MP4 ใช้ iTunes atoms, Ogg/Opus ใช้ Vorbis Comment (บล็อก PICTURE), FLAC ใช้ Vorbis Comment/PICTURE และ WAV ใช้ LIST-INFO';

  @override
  String get doNotShowAgain => 'ไม่ต้องแสดงอีก';

  @override
  String get continueLabel => 'ดำเนินการต่อ';

  @override
  String paletteWidthFactor(String percent) {
    return 'ความกว้าง $percent%';
  }

  @override
  String paletteHeightFactor(String percent) {
    return 'ความสูง $percent%';
  }
}
