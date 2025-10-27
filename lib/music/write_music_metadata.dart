/*
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
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

  final pickedUri = await FFmpegKitConfig.selectDocumentForWrite(name, mime);
  if (pickedUri == null) {
    throw SaveCancelledException();
  }
  final safOut = await FFmpegKitConfig.getSafParameterForWrite(pickedUri);
  if (safOut == null || safOut.isEmpty) {
    throw Exception('SAF 출력 경로 변환 실패');
  }

  await _encodeWithFfmpegAndPost(
    inputPath: inputPath,
    finalSafOut: safOut,
    tags: tags,
    artworkPath: artworkPath,
    containerHint: container,
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
    case '.oga':
    case '.opus': return 'ogg';
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
    case '.oga':
    case '.opus': return 'audio/ogg';
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

List<String> _metaArgs(Map<String, String> tags, {required String container}) {
  final isWav = (container == 'wav');
  final isFlac = (container == 'flac');

  final m = <String, String>{
    'title'  : tags['title']  ?? '',
    'artist' : tags['artist'] ?? '',
    'album'  : tags['album']  ?? '',
    'genre'  : tags['genre']  ?? '',
    'date'   : tags['year'] ?? tags['date'] ?? '',
    'track'  : tags['track']  ?? '',
    'disc'   : tags['disc']   ?? '',
    if (!isWav && !isFlac) 'lyrics'           : tags['lyrics'] ?? '',
    if (isWav)             'comment'          : tags['lyrics'] ?? '',         // WAV: LIST-INFO ICMT
    if (isFlac)            'lyrics'           : tags['lyrics'] ?? '',         // FLAC: 코멘트에 둘 다
    if (isFlac)            'unsyncedlyrics'   : tags['lyrics'] ?? '',
  };

  final args = <String>[];
  m.forEach((k, v) {
    final sv = v.replaceAll('\r\n', '\n').replaceAll('"', "'");
    if (sv.trim().isEmpty) return;
    args.addAll(['-metadata', '$k=$sv']);
  });
  return args;
}

/// ffmpeg-safe quoting
String _quoteArg(String p) => '"${p.replaceAll('"', r'\"')}"';

/// 이미지 정보 추출 (Ogg용 PICTURE 블록 작성에 필요)
Future<({int w, int h, int depth, String mime, Uint8List bytes})> _probeImageInfo(String imgPath) async {
  final file = File(imgPath);
  final bytes = await file.readAsBytes();
  if (bytes.isEmpty) throw Exception('이미지 파일 비어있음: $imgPath');

  String mime = 'image/jpeg';
  final low = imgPath.toLowerCase();
  if (low.endsWith('.png')) mime = 'image/png';
  else if (low.endsWith('.webp')) mime = 'image/webp';
  else if (low.endsWith('.jpg') || low.endsWith('.jpeg')) mime = 'image/jpeg';

  final q = _quoteArg(imgPath);
  final cmd = '-v error -select_streams v:0 -show_entries stream=width,height,bits_per_raw_sample -of json -i $q';
  final sess = await FFmpegKit.execute(cmd);
  final out = await sess.getOutput();
  int w = 0, h = 0, depth = 0;
  try {
    final j = json.decode(out ?? '{}') as Map<String, dynamic>;
    final streams = (j['streams'] as List?) ?? const [];
    if (streams.isNotEmpty && streams.first is Map) {
      final s = streams.first as Map;
      w = (s['width'] ?? 0) as int;
      h = (s['height'] ?? 0) as int;
      final raw = s['bits_per_raw_sample'];
      if (raw is String && raw.trim().isNotEmpty) {
        depth = int.tryParse(raw.trim()) ?? 0;
      }
      if (depth == 0) depth = mime == 'image/png' ? 32 : 24;
    }
  } catch (_) {
    if (depth == 0) depth = mime == 'image/png' ? 32 : 24;
  }

  return (w: w, h: h, depth: depth, mime: mime, bytes: bytes);
}

/// FLAC PICTURE 블록(base64) 작성 (Ogg/Opus용)
String _buildFlacPictureBlockBase64({
  required int width,
  required int height,
  required int bitDepth,
  required String mime,
  required Uint8List imageBytes,
  String description = 'Cover (front)',
}) {
  final mimeBytes = utf8.encode(mime);
  final descBytes = utf8.encode(description);
  final dataLen = imageBytes.length;

  final buf = BytesBuilder();
  void be32(int v) {
    final b = ByteData(4)..setUint32(0, v, Endian.big);
    buf.add(b.buffer.asUint8List());
  }

  be32(3); // type: 3(front cover)
  be32(mimeBytes.length); buf.add(mimeBytes);
  be32(descBytes.length); buf.add(descBytes);
  be32(width);
  be32(height);
  be32(bitDepth <= 0 ? 24 : bitDepth);
  be32(0); // indexed colors
  be32(dataLen); buf.add(imageBytes);

  return base64.encode(buf.toBytes());
}

/// Ogg/Opus용 METADATA_BLOCK_PICTURE 인자 생성
Future<List<String>> _oggCoverArgs(String artworkPath) async {
  final info = await _probeImageInfo(artworkPath);
  final b64 = _buildFlacPictureBlockBase64(
    width: info.w, height: info.h, bitDepth: info.depth,
    mime: info.mime, imageBytes: info.bytes,
  );
  return [
    '-metadata:s:a:0', 'METADATA_BLOCK_PICTURE=',
    '-metadata:s:a:0', 'METADATA_BLOCK_PICTURE=$b64',
  ];
}

/// metaflac 사용 가능 여부
Future<bool> _hasMetaflac() async {
  try {
    final pr = await Process.run('metaflac', ['--version']);
    return pr.exitCode == 0;
  } catch (_) {
    return false;
  }
}

/// FLAC 파일에 PICTURE 삽입(표준) — metaflac로 처리
Future<void> _injectFlacPictureWithMetaflac({
  required String flacPath,      // 로컬 경로여야 함
  required String artworkPath,   // 로컬 경로
}) async {
  final has = await _hasMetaflac();
  if (!has) {
    debugPrint('metaflac 미탑재: FLAC 커버 삽입 생략');
    return;
  }
  // 기존 PICTURE 제거
  try {
    await Process.run('metaflac', ['--remove', '--block-type=PICTURE', flacPath]);
  } catch (e) {
    // 없을 수도 있으니 무시
    debugPrint('metaflac remove PICTURE 경고: $e');
  }
  // 새 PICTURE 삽입
  final r = await Process.run('metaflac', ['--import-picture-from=$artworkPath', flacPath]);
  if (r.exitCode != 0) {
    throw Exception('metaflac import 실패: ${r.stderr}');
  }
}

/// 인코드 + 포스트(FLAC/OGG 처리 포함)
Future<void> _encodeWithFfmpegAndPost({
  required String inputPath,
  required String finalSafOut,     // 최종 SAF 목적지
  required Map<String, String> tags,
  String? artworkPath,
  required String containerHint,
}) async {
  final inPathForFfmpeg = await _asFfmpegInputPath(inputPath);
  final ext = p.extension(inputPath).toLowerCase();
  final c = containerHint; // 'mp3' | 'mp4' | 'flac' | 'ogg' | 'wav'
  final isWav = c == 'wav';
  final isOgg = c == 'ogg';
  final isFlac = c == 'flac';

  // WAV/OGG는 일반 비디오 스트림 커버 삽입을 하지 않음
  String? coverIn;
  final hasCoverRaw = artworkPath != null && artworkPath!.isNotEmpty;
  final hasStreamCover = hasCoverRaw && !isWav && !isOgg && !isFlac;

  if (hasStreamCover) {
    final ap = artworkPath!;
    coverIn = ap.toLowerCase().startsWith('content://')
        ? await FFmpegKitConfig.getSafParameterForRead(ap)
        : ap;
    if (coverIn == null || coverIn.isEmpty) coverIn = null;
  }

  // Ogg/Opus: METADATA_BLOCK_PICTURE를 태그로 셋업
  List<String> extraOggArgs = [];
  if (hasCoverRaw && isOgg) {
    extraOggArgs = await _oggCoverArgs(artworkPath!);
  }

  // FLAC + 커버: 임시 로컬에 먼저 생성 후 metaflac로 커버 삽입
  final needsFlacTemp = isFlac && hasCoverRaw;
  final String tempFlacOut = needsFlacTemp
      ? '${Directory.systemTemp.path}/tmp_${DateTime.now().millisecondsSinceEpoch}.flac'
      : '';

  // 1) 1차 출력 대상 결정
  final primaryOut = needsFlacTemp ? tempFlacOut : finalSafOut;

  // 2) ffmpeg로 기본 태그/맵/코덱 설정
  final args = <String>['-y', '-i', inPathForFfmpeg];
  if (hasStreamCover && coverIn != null) {
    args.addAll(['-i', coverIn]);
  }
  args.addAll(_metaArgs(tags, container: c));

  if (ext == '.mp3') {
    args.addAll(['-map', '0:a?']);
    if (hasStreamCover && coverIn != null) args.addAll(['-map', '1:v:0']);
    args.addAll(['-c:a', 'copy']);
    if (hasStreamCover && coverIn != null) {
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
    args.addAll(['-map', '-0:v?']);
    if (hasStreamCover && coverIn != null) {
      args.addAll(['-map', '1:v:0']);
    }
    args.addAll(['-c:a', 'copy']);
    if (hasStreamCover && coverIn != null) {
      args.addAll(['-c:v:0', 'mjpeg', '-disposition:v:0', 'attached_pic']);
    }
  } else if (isOgg) {
    args.addAll(['-map', '0', '-c', 'copy', ...extraOggArgs]);
  } else {
    // flac/wav/기타: 텍스트 메타만 복사
    args.addAll(['-map', '0', '-c', 'copy']);
  }

  // SAF 출력일 때 포맷 명시
  if (!needsFlacTemp) {
    args.addAll(['-f', c]);
  }
  args.add(primaryOut);

  debugPrint('FFmpeg ARGS (primary): ${args.join(' ')}');

  var sess = await FFmpegKit.executeWithArguments(args);
  var rcOk = ReturnCode.isSuccess(await sess.getReturnCode());
  final logs1 = (await sess.getLogs()).map((l) => '[${l.getLevel()}] ${l.getMessage()}').join('\n');
  if (!rcOk) {
    throw Exception('ffmpeg primary failed.\n${await sess.getOutput() ?? ''}\n$logs1\n${await sess.getFailStackTrace() ?? ''}');
  }

  // 3) FLAC + 커버가 있으면 metaflac로 PICTURE 삽입 후 SAF로 복사
  if (needsFlacTemp) {
    try {
      await _injectFlacPictureWithMetaflac(flacPath: tempFlacOut, artworkPath: artworkPath!);
    } catch (e) {
      // 커버 실패시에도 텍스트 태그 파일은 완성되어 있으니 계속 진행
      debugPrint('metaflac 처리 실패: $e');
    }

    final copyArgs = <String>['-y', '-i', tempFlacOut, '-c', 'copy', '-f', 'flac', finalSafOut];
    debugPrint('FFmpeg ARGS (copy to SAF): ${copyArgs.join(' ')}');
    sess = await FFmpegKit.executeWithArguments(copyArgs);
    rcOk = ReturnCode.isSuccess(await sess.getReturnCode());
    final logs2 = (await sess.getLogs()).map((l) => '[${l.getLevel()}] ${l.getMessage()}').join('\n');
    if (!rcOk) {
      throw Exception('ffmpeg copy-to-SAF failed.\n${await sess.getOutput() ?? ''}\n$logs2\n${await sess.getFailStackTrace() ?? ''}');
    }

    try { await File(tempFlacOut).delete(); } catch (_) {}
  }
}
*/
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_new_min/return_code.dart';
import 'package:flutter/foundation.dart';

import 'package:path/path.dart' as p;

/// 참고:
/// - FFmpeg 라이선스/링킹 지침: https://ffmpeg.org/legal.html  (앱 배포 시 고지/소스 제공 의무 확인)  [ffmpeg 공식]
/// - Ogg/Vorbis/Opus 계열 커버아트는 VorbisComment에 FLAC PICTURE 블록을 base64로 싣는 'METADATA_BLOCK_PICTURE' 관례 사용.  :contentReference[oaicite:2]{index=2}
/// - Opus/Vorbis/FLAC은 공개 표준/오픈 코덱으로 무료 사용이 가능하다는 점이 널리 문서화되어 있다(IETF/Xiph).  :contentReference[oaicite:3]{index=3}

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

  final pickedUri = await FFmpegKitConfig.selectDocumentForWrite(name, mime);
  if (pickedUri == null) {
    throw SaveCancelledException();
  }
  final safOut = await FFmpegKitConfig.getSafParameterForWrite(pickedUri);
  if (safOut == null || safOut.isEmpty) {
    throw Exception('SAF 출력 경로 변환 실패');
  }

  await _encodeWithFfmpegAndPost(
    inputPath: inputPath,
    finalSafOut: safOut,
    tags: tags,
    artworkPath: artworkPath,
    containerHint: container,
  );

  return SaveResult(displayName: name, savedSafPath: safOut);
}

String _fallbackName(String inputPath, String ext) {
  final base = p.basenameWithoutExtension(inputPath);
  return '${base.isEmpty ? 'audio' : base}${ext.isEmpty ? '.mp3' : ext}';
}

String _containerFromExt(String extWithDotLower) {
  switch (extWithDotLower) {
    case '.mp3':
      return 'mp3';
    case '.m4a':
    case '.mp4':
    case '.m4b':
    case '.aac':
      return 'mp4'; // m4a/mp4/aac 컨테이너군
    case '.flac':
      return 'flac';
    case '.ogg':
    case '.oga':
    case '.opus':
      return 'ogg';
    case '.wav':
      return 'wav';
    default:
      return 'mp3';
  }
}

String _androidMimeFromExt(String extWithDotLower) {
  switch (extWithDotLower) {
    case '.mp3':
      return 'audio/mpeg';
    case '.m4a':
    case '.mp4':
    case '.m4b':
    case '.aac':
      return 'audio/mp4';
    case '.flac':
      return 'audio/flac';
    case '.ogg':
    case '.oga':
    case '.opus':
      return 'audio/ogg';
    case '.wav':
      return 'audio/wav';
    default:
      return 'application/octet-stream';
  }
}

/// SAF 읽기용 URL로 바꿔서 ffmpeg 입력으로 쓸 수 있게 한다.
Future<String> _asFfmpegInputPath(String inputPath) async {
  if (!inputPath.toLowerCase().startsWith('content://')) return inputPath;
  final safUrl = await FFmpegKitConfig.getSafParameterForRead(inputPath);
  if (safUrl == null || safUrl.isEmpty) {
    throw Exception('SAF URL 변환 실패: $inputPath');
  }
  return safUrl;
}

/// 입력 파일의 오디오 코덱/포맷을 FFprobe로 추출
Future<({String codec, String format})> _probeAudioInfo(String inputPath) async {
  final q = _quoteArg(inputPath);
  // 첫 번째 오디오 스트림의 codec_name, 컨테이너 format_name
  final cmd =
      '-v error -select_streams a:0 -show_entries stream=codec_name '
      '-show_entries format=format_name -of json -i $q';
  final sess = await FFmpegKit.execute(cmd);
  final out = await sess.getOutput();
  if (out == null || out.trim().isEmpty) {
    throw Exception('입력 포맷 분석 실패');
  }
  String codec = '';
  String format = '';
  try {
    final j = json.decode(out) as Map<String, dynamic>;
    final streams = (j['streams'] as List?) ?? const [];
    if (streams.isNotEmpty && streams.first is Map) {
      codec = ((streams.first as Map)['codec_name'] ?? '').toString();
    }
    final fmt = (j['format'] as Map?) ?? const {};
    format = (fmt['format_name'] ?? '').toString(); // 예: "mp3", "wav", "ogg", "mov,mp4,m4a,3gp,3g2,mj2"
  } catch (_) {}
  if (codec.isEmpty) throw Exception('오디오 코덱을 찾지 못했습니다');
  return (codec: codec.toLowerCase(), format: format.toLowerCase());
}

/// copy-only가 가능한 조합인지 확인. 아니면 예외.
void _assertCopySafe({
  required String inCodec,
  required String outContainer,
}) {
  bool ok = false;

  bool isPcm = inCodec.contains('pcm') || inCodec == 'alaw' || inCodec == 'mulaw';
  switch (outContainer) {
    case 'mp3':
    // MP3 컨테이너는 MP3 비트스트림만 안전 복사
      ok = (inCodec == 'mp3' || inCodec == 'mpga' || inCodec == 'mp2' /*희귀*/);
      break;
    case 'mp4':
    // m4a/mp4는 AAC 또는 ALAC만 안전 복사
      ok = (inCodec == 'aac' || inCodec == 'alac');
      break;
    case 'ogg':
    // Ogg는 Opus 또는 Vorbis만 안전 복사
      ok = (inCodec == 'opus' || inCodec == 'vorbis');
      break;
    case 'flac':
      ok = (inCodec == 'flac');
      break;
    case 'wav':
      ok = isPcm;
      break;
    default:
      ok = false;
  }

  if (!ok) {
    throw Exception(
      '요청한 컨테이너($outContainer)와 입력 코덱($inCodec)이 호환되지 않습니다. '
          '재인코딩 없이 저장할 수 없습니다.',
    );
  }
}

List<String> _metaArgs(Map<String, String> tags, {required String container}) {
  final isWav = (container == 'wav');
  final isFlac = (container == 'flac');

  final m = <String, String>{
    'title': tags['title'] ?? '',
    'artist': tags['artist'] ?? '',
    'album': tags['album'] ?? '',
    'genre': tags['genre'] ?? '',
    'date': tags['year'] ?? tags['date'] ?? '',
    'track': tags['track'] ?? '',
    'disc': tags['disc'] ?? '',
    if (!isWav && !isFlac) 'lyrics': tags['lyrics'] ?? '',
    if (isWav) 'comment': tags['lyrics'] ?? '', // WAV: LIST-INFO ICMT
    if (isFlac) 'lyrics': tags['lyrics'] ?? '',
    if (isFlac) 'unsyncedlyrics': tags['lyrics'] ?? '',
  };

  final args = <String>[];
  m.forEach((k, v) {
    final sv = v.replaceAll('\r\n', '\n').replaceAll('"', "'");
    if (sv.trim().isEmpty) return;
    args.addAll(['-metadata', '$k=$sv']);
  });
  return args;
}

/// ffmpeg-safe quoting
String _quoteArg(String p) => '"${p.replaceAll('"', r'\"')}"';

/// 이미지 정보 추출 (Ogg/Opus용 PICTURE 블록 작성에 필요)
Future<({int w, int h, int depth, String mime, Uint8List bytes})> _probeImageInfo(
    String imgPath) async {
  final file = File(imgPath);
  final bytes = await file.readAsBytes();
  if (bytes.isEmpty) throw Exception('이미지 파일 비어있음: $imgPath');

  String mime = 'image/jpeg';
  final low = imgPath.toLowerCase();
  if (low.endsWith('.png')) {
    mime = 'image/png';
  } else if (low.endsWith('.webp')) {
    mime = 'image/webp';
  } else if (low.endsWith('.jpg') || low.endsWith('.jpeg')) {
    mime = 'image/jpeg';
  }

  final q = _quoteArg(imgPath);
  final cmd =
      '-v error -select_streams v:0 -show_entries stream=width,height,bits_per_raw_sample -of json -i $q';
  final sess = await FFmpegKit.execute(cmd);
  final out = await sess.getOutput();
  int w = 0, h = 0, depth = 0;
  try {
    final j = json.decode(out ?? '{}') as Map<String, dynamic>;
    final streams = (j['streams'] as List?) ?? const [];
    if (streams.isNotEmpty && streams.first is Map) {
      final s = streams.first as Map;
      w = (s['width'] ?? 0) as int;
      h = (s['height'] ?? 0) as int;
      final raw = s['bits_per_raw_sample'];
      if (raw is String && raw.trim().isNotEmpty) {
        depth = int.tryParse(raw.trim()) ?? 0;
      }
      if (depth == 0) depth = mime == 'image/png' ? 32 : 24;
    }
  } catch (_) {
    if (depth == 0) depth = mime == 'image/png' ? 32 : 24;
  }

  return (w: w, h: h, depth: depth, mime: mime, bytes: bytes);
}

/// FLAC PICTURE 블록(base64) 작성 (Ogg/Opus용)
String _buildFlacPictureBlockBase64({
  required int width,
  required int height,
  required int bitDepth,
  required String mime,
  required Uint8List imageBytes,
  String description = 'Cover (front)',
}) {
  final mimeBytes = utf8.encode(mime);
  final descBytes = utf8.encode(description);
  final dataLen = imageBytes.length;

  final buf = BytesBuilder();
  void be32(int v) {
    final b = ByteData(4)..setUint32(0, v, Endian.big);
    buf.add(b.buffer.asUint8List());
  }

  be32(3); // type: 3(front cover)
  be32(mimeBytes.length);
  buf.add(mimeBytes);
  be32(descBytes.length);
  buf.add(descBytes);
  be32(width);
  be32(height);
  be32(bitDepth <= 0 ? 24 : bitDepth);
  be32(0); // indexed colors
  be32(dataLen);
  buf.add(imageBytes);

  return base64.encode(buf.toBytes());
}

/// Ogg/Opus용 METADATA_BLOCK_PICTURE 인자 생성
Future<List<String>> _oggCoverArgs(String artworkPath) async {
  final info = await _probeImageInfo(artworkPath);
  final b64 = _buildFlacPictureBlockBase64(
    width: info.w,
    height: info.h,
    bitDepth: info.depth,
    mime: info.mime,
    imageBytes: info.bytes,
  );
  return [
    // 빈 값을 한 번 넣어 기존 값을 제거하는 패턴을 일부 플랫폼에서 요구함
    '-metadata:s:a:0',
    'METADATA_BLOCK_PICTURE=',
    '-metadata:s:a:0',
    'METADATA_BLOCK_PICTURE=$b64',
  ];
}

/// metaflac 사용 가능 여부(플랫폼에 따라 없을 수 있음)
Future<bool> _hasMetaflac() async {
  try {
    final pr = await Process.run('metaflac', ['--version']);
    return pr.exitCode == 0;
  } catch (_) {
    return false;
  }
}

/// FLAC 파일에 PICTURE 삽입(표준) — metaflac로 처리
Future<void> _injectFlacPictureWithMetaflac({
  required String flacPath, // 로컬 경로여야 함
  required String artworkPath, // 로컬 경로
}) async {
  final has = await _hasMetaflac();
  if (!has) {
    debugPrint('metaflac 미탑재: FLAC 커버 삽입 생략');
    return;
  }
  // 기존 PICTURE 제거(있어도 되고 없어도 됨)
  try {
    await Process.run('metaflac', ['--remove', '--block-type=PICTURE', flacPath]);
  } catch (e) {
    debugPrint('metaflac remove PICTURE 경고: $e');
  }
  // 새 PICTURE 삽입
  final r = await Process.run('metaflac', ['--import-picture-from=$artworkPath', flacPath]);
  if (r.exitCode != 0) {
    throw Exception('metaflac import 실패: ${r.stderr}');
  }
}

/// 인코드 + 포스트(FLAC/OGG 처리 포함)
Future<void> _encodeWithFfmpegAndPost({
  required String inputPath,
  required String finalSafOut, // 최종 SAF 목적지
  required Map<String, String> tags,
  String? artworkPath,
  required String containerHint, // 'mp3' | 'mp4' | 'flac' | 'ogg' | 'wav'
}) async {
  // 0) 입력 분석 + copy-only 안전검사
  final inPathForFfmpeg = await _asFfmpegInputPath(inputPath);
  final info = await _probeAudioInfo(inPathForFfmpeg);
  _assertCopySafe(inCodec: info.codec, outContainer: containerHint);

  final ext = p.extension(inputPath).toLowerCase();
  final c = containerHint;
  final isWav = c == 'wav';
  final isOgg = c == 'ogg';
  final isFlac = c == 'flac';

  // WAV/OGG/FLAC는 비디오 스트림 커버를 붙이지 않음
  String? coverIn;
  final hasCoverRaw = artworkPath != null && artworkPath!.isNotEmpty;
  final hasStreamCover = hasCoverRaw && !isWav && !isOgg && !isFlac;

  if (hasStreamCover) {
    final ap = artworkPath!;
    coverIn = ap.toLowerCase().startsWith('content://')
        ? await FFmpegKitConfig.getSafParameterForRead(ap)
        : ap;
    if (coverIn == null || coverIn.isEmpty) coverIn = null;
  }

  // Ogg/Opus 커버아트: METADATA_BLOCK_PICTURE
  List<String> extraOggArgs = [];
  if (hasCoverRaw && isOgg) {
    extraOggArgs = await _oggCoverArgs(artworkPath!);
  }

  // FLAC + 커버 → 임시 로컬 생성 후 metaflac로 PICTURE 삽입
  final needsFlacTemp = isFlac && hasCoverRaw;
  final String tempFlacOut =
  needsFlacTemp ? '${Directory.systemTemp.path}/tmp_${DateTime.now().millisecondsSinceEpoch}.flac' : '';

  // 1) 1차 출력 대상
  final primaryOut = needsFlacTemp ? tempFlacOut : finalSafOut;

  // 2) ffmpeg 인자 구성
  final args = <String>['-y', '-i', inPathForFfmpeg];
  if (hasStreamCover && coverIn != null) {
    args.addAll(['-i', coverIn]);
  }
  args.addAll(_metaArgs(tags, container: c));

  // 모든 경우 copy-only
  // 컨테이너별 맵핑과 커버 처리
  if (c == 'mp3') {
    args.addAll(['-map', '0:a?']);
    if (hasStreamCover && coverIn != null) args.addAll(['-map', '1:v:0']);
    args.addAll(['-c:a', 'copy']);
    if (hasStreamCover && coverIn != null) {
      args.addAll([
        '-c:v:0', 'mjpeg',
        '-metadata:s:v:0', 'title=Album cover',
        '-metadata:s:v:0', 'comment=Cover (front)',
        '-disposition:v:0', 'attached_pic',
      ]);
    }
    args.addAll(['-id3v2_version', '3', '-write_id3v1', '1']);
  } else if (c == 'mp4') {
    args.addAll(['-map', '0:a?']);
    args.addAll(['-map', '-0:v?']);
    if (hasStreamCover && coverIn != null) {
      args.addAll(['-map', '1:v:0']);
    }
    args.addAll(['-c:a', 'copy']);
    if (hasStreamCover && coverIn != null) {
      args.addAll(['-c:v:0', 'mjpeg', '-disposition:v:0', 'attached_pic']);
    }
  } else if (isOgg) {
    args.addAll(['-map', '0', '-c', 'copy', ...extraOggArgs]);
  } else {
    // flac/wav 등: 텍스트 메타만 복사
    args.addAll(['-map', '0', '-c', 'copy']);
  }

  // SAF 출력일 때 포맷 명시
  if (!needsFlacTemp) {
    args.addAll(['-f', c]);
  }
  args.add(primaryOut);

  debugPrint('FFmpeg ARGS (primary): ${args.join(' ')}');

  var sess = await FFmpegKit.executeWithArguments(args);
  var rcOk = ReturnCode.isSuccess(await sess.getReturnCode());
  final logs1 =
  (await sess.getLogs()).map((l) => '[${l.getLevel()}] ${l.getMessage()}').join('\n');
  if (!rcOk) {
    throw Exception('ffmpeg primary failed.\n${await sess.getOutput() ?? ''}\n$logs1\n${await sess.getFailStackTrace() ?? ''}');
  }

  // 3) FLAC + 커버 → metaflac로 PICTURE 삽입 후 SAF로 복사
  if (needsFlacTemp) {
    try {
      await _injectFlacPictureWithMetaflac(flacPath: tempFlacOut, artworkPath: artworkPath!);
    } catch (e) {
      debugPrint('metaflac 처리 실패: $e');
    }

    final copyArgs = <String>['-y', '-i', tempFlacOut, '-c', 'copy', '-f', 'flac', finalSafOut];
    debugPrint('FFmpeg ARGS (copy to SAF): ${copyArgs.join(' ')}');
    sess = await FFmpegKit.executeWithArguments(copyArgs);
    rcOk = ReturnCode.isSuccess(await sess.getReturnCode());
    final logs2 =
    (await sess.getLogs()).map((l) => '[${l.getLevel()}] ${l.getMessage()}').join('\n');
    if (!rcOk) {
      throw Exception('ffmpeg copy-to-SAF failed.\n${await sess.getOutput() ?? ''}\n$logs2\n${await sess.getFailStackTrace() ?? ''}');
    }

    try {
      await File(tempFlacOut).delete();
    } catch (_) {}
  }
}

