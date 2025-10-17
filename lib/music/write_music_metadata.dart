import 'package:flutter/foundation.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path/path.dart' as p;

class SaveCancelledException implements Exception {
  @override
  String toString() => '사용자가 저장을 취소했습니다';
}

class SaveResult {
  final String displayName;
  final String? savedSafPath;
  SaveResult({required this.displayName, this.savedSafPath});
}

Future<SaveResult> saveWithUserPicker({
  required String inputPath,
  required Map<String, String> tags,
  String? artworkPath,
  String? suggestedName,
}) async {
  final ext = p.extension(inputPath).toLowerCase();
  final container = _containerFromExt(ext);
  final mime = _androidMimeFromExt(ext);
  final name = (suggestedName == null || suggestedName.trim().isEmpty)
      ? _fallbackName(inputPath, ext)
      : suggestedName.trim();

  // SAF Save As 대화상자
  final pickedUri = await FFmpegKitConfig.selectDocumentForWrite(name, mime);
  if (pickedUri == null) {
    throw SaveCancelledException();
  }
  final safOut = await FFmpegKitConfig.getSafParameterForWrite(pickedUri);
  if (safOut == null || safOut.isEmpty) {
    throw Exception('SAF 출력 경로 변환 실패');
  }

  await _encodeWithFfmpeg(
    inputPath,
    safOut,
    tags,
    artworkPath: artworkPath,
    outIsSafPath: true,
    forceFormat: container,
  );

  return SaveResult(displayName: name, savedSafPath: safOut);
}

String _fallbackName(String inputPath, String ext) {
  final base = p.basenameWithoutExtension(inputPath);
  return '${base.isEmpty ? 'audio' : base}${ext.isEmpty ? '.mp3' : ext}';
}

String _containerFromExt(String extWithDotLower) {
  switch (extWithDotLower) {
    case '.mp3': return 'mp3';
    case '.m4a':
    case '.mp4':
    case '.m4b':
    case '.aac': return 'mp4';
    case '.flac': return 'flac';
    case '.ogg':
    case '.oga': return 'ogg';
    case '.wav': return 'wav';
    default: return 'mp3';
  }
}

String _androidMimeFromExt(String extWithDotLower) {
  switch (extWithDotLower) {
    case '.mp3': return 'audio/mpeg';
    case '.m4a':
    case '.mp4':
    case '.m4b':
    case '.aac': return 'audio/mp4';
    case '.flac': return 'audio/flac';
    case '.ogg':
    case '.oga': return 'audio/ogg';
    case '.wav': return 'audio/wav';
    default: return 'application/octet-stream';
  }
}

Future<String> _asFfmpegInputPath(String inputPath) async {
  if (!inputPath.toLowerCase().startsWith('content://')) return inputPath;
  final safUrl = await FFmpegKitConfig.getSafParameterForRead(inputPath);
  if (safUrl == null || safUrl.isEmpty) {
    throw Exception('SAF URL 변환 실패: $inputPath');
  }
  return safUrl;
}

List<String> _metaArgs(Map<String, String> tags) {
  final m = <String, String>{
    'title'  : tags['title']  ?? '',
    'artist' : tags['artist'] ?? '',
    'album'  : tags['album']  ?? '',
    'genre'  : tags['genre']  ?? '',
    'date'   : tags['year'] ?? tags['date'] ?? '',
    'track'  : tags['track']  ?? '',
    'disc'   : tags['disc']   ?? '',
    // ⚠️ \n 이스케이프 금지: 배열 인자 실행 사용
    'lyrics' : tags['lyrics'] ?? '',
  };

  final args = <String>[];
  m.forEach((k, v) {
    final sv = v.replaceAll('\r\n', '\n').replaceAll('"', "'");
    if (sv.trim().isEmpty) return;
    args.addAll(['-metadata', '$k=$sv']);
  });
  return args;
}

Future<void> _encodeWithFfmpeg(
    String inputPath,
    String outPath,                    // 파일 경로 또는 saf:
    Map<String, String> tags, {
      String? artworkPath,
      bool outIsSafPath = false,
      String? forceFormat,
    }) async {
  final ext = p.extension(inputPath).toLowerCase();
  final inPathForFfmpeg = await _asFfmpegInputPath(inputPath);

  String? coverIn;
  final hasCover = artworkPath != null && artworkPath!.isNotEmpty;
  if (hasCover) {
    final ap = artworkPath!;
    coverIn = ap.toLowerCase().startsWith('content://')
        ? await FFmpegKitConfig.getSafParameterForRead(ap)
        : ap;
    if (coverIn == null || coverIn.isEmpty) coverIn = null;
  }

  final meta = _metaArgs(tags);
  final args = <String>['-y', '-i', inPathForFfmpeg];
  if (hasCover && coverIn != null) {
    args.addAll(['-i', coverIn]);
  }
  args.addAll(meta);

  if (ext == '.mp3') {
    args.addAll(['-map', '0:a?']);
    if (hasCover && coverIn != null) args.addAll(['-map', '1:v:0']);
    args.addAll(['-c:a', 'copy']);
    if (hasCover && coverIn != null) {
      args.addAll([
        '-c:v:0', 'mjpeg',
        '-metadata:s:v:0', 'title=Album cover',
        '-metadata:s:v:0', 'comment=Cover (front)',
        '-disposition:v:0', 'attached_pic',
      ]);
    }
    args.addAll(['-id3v2_version', '3', '-write_id3v1', '1']);
  } else if (ext == '.m4a' || ext == '.mp4' || ext == '.m4b' || ext == '.aac') {
    args.addAll(['-map', '0:a?']);
    args.addAll(['-map', '-0:v?']);           // 기존 커버 제거
    if (hasCover && coverIn != null) {
      args.addAll(['-map', '1:v:0']);         // 새 커버 추가
    }
    args.addAll(['-c:a', 'copy']);
    if (hasCover && coverIn != null) {
      args.addAll(['-c:v:0', 'mjpeg', '-disposition:v:0', 'attached_pic']);
    }
  } else {
    // flac/ogg 등: 텍스트 메타만 복사
    args.addAll(['-map', '0', '-c', 'copy']);
  }

  if (outIsSafPath && (forceFormat != null && forceFormat.isNotEmpty)) {
    args.addAll(['-f', forceFormat]); // SAF 출력은 포맷 명시가 안전
  }
  args.add(outPath);

  debugPrint('FFmpeg ARGS: ${args.join(' ')}');

  final sess = await FFmpegKit.executeWithArguments(args);
  final rcOk = ReturnCode.isSuccess(await sess.getReturnCode());

  final logs = (await sess.getLogs()).map((l) => '[${l.getLevel()}] ${l.getMessage()}').join('\n');
  final failStack = await sess.getFailStackTrace();
  final out = await sess.getOutput();

  debugPrint('--- FFmpeg OUT ---\n${out ?? ''}');
  debugPrint('--- FFmpeg LOGS ---\n$logs');
  debugPrint('--- FFmpeg FAIL STACK ---\n${failStack ?? ''}');

  if (!rcOk) {
    throw Exception('ffmpeg failed.\n${out ?? ''}\n$logs\n${failStack ?? ''}');
  }
}
