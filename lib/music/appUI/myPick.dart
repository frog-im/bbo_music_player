// lib/music/appUI/myPick.dart
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

/// 내부 공용 유틸: 확장자 허용 여부
bool _ExtAllowed(String path, List<String> allow, {Map<String, List<String>>? alias}) {
  final name = p.basename(path).toLowerCase();
  final al = alias ?? {};
  final expanded = allow.expand((e) => al[e] ?? [e]).toSet();
  return expanded.any((e) => name.endsWith('.$e'));
}

/// 내부 공용: MIME 넓게 열고 → 사후 확장자 필터링 → (필요 시에만) 폴백
Future<String> _PickFileCore({
  required FileType wideType,            // FileType.audio / FileType.image / FileType.any
  required List<String> exts,            // 허용 확장자
  Map<String, List<String>>? alias,      // 확장자 동의어(m4a→mp4 등)
}) async {
  // 1) 넓게 오픈 (SAF는 MIME 기반)
  final r1 = await FilePicker.platform.pickFiles(
    type: wideType,
    allowMultiple: false,
    withData: false,
  );

  // (A) 사용자가 취소한 경우: 곧바로 종료(폴백 금지)
  if (r1 == null) return '';

  final p1 = r1.files.singleOrNull?.path;
  if (p1 != null && p1.isNotEmpty) {
    // (B) 파일을 고른 경우: 허용 확장자면 그대로 반환
    if (_ExtAllowed(p1, exts, alias: alias)) {
      return p1;
    }
    // (C) 파일을 골랐지만 확장자가 허용 목록에 없을 때만 폴백으로 유도
    //     => 여기서만 custom 필터를 띄워 재선택을 유도합니다.
  } else {
    // 안전망: 경로가 비정상인 경우도 취소로 간주
    return '';
  }

  // 2) 폴백: 커스텀 확장자 필터(정확히 허용 목록만)
  final r2 = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: exts,
    allowMultiple: false,
    withData: false,
  );
  if (r2 == null) return ''; // 폴백도 취소

  final p2 = r2.files.singleOrNull?.path;
  if (p2 != null && p2.isNotEmpty && _ExtAllowed(p2, exts, alias: alias)) {
    return p2;
  }
  return '';
}

/// 공개: 오디오 선택 (m4a는 mp4 컨테이너이므로 mp4 동의어 포함)
Future<String> PickAudioFile(List<String> extList) async {
  final alias = {
    'm4a': ['m4a', 'mp4'], // 공급자에 따라 audio/mp4만 보이는 경우 대응
  };
  return _PickFileCore(
    wideType: FileType.audio,
    exts: extList,
    alias: alias,
  );
}

/// 공개: 이미지 선택
Future<String> PickImageFile(List<String> extList) async {
  return _PickFileCore(
    wideType: FileType.image,
    exts: extList,
  );
}
