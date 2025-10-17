// lib/music/appUI/myPick.dart
import 'package:file_picker/file_picker.dart';

/// 전역 플래그 (원 요청 유지)
bool write = true, aImage = true;
bool subtitles = false;

/// 요구하신 시그니처 그대로 유지.
/// - [extList]: 허용 확장자
/// - [b]: 플래그( write / aImage / subtitles ) 중 하나를 전달
Future<String> pickAudioFile(List<String> extList, bool b) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: extList,
    withData: false,
  );

  if (result != null && result.files.isNotEmpty) {
    final path = result.files.single.path;
    if (path == null || path.isEmpty) return '';
    //print('$path^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
    return path;

  }
  return '';
}
