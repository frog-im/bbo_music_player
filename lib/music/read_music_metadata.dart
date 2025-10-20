// lib/music/read_music_metadata.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:dart_tags/dart_tags.dart';

/// ffmpeg/ffprobe 인자용 경로 인용: "..." 로 감싸고 내부 " 이스케이프
String _quoteArg(String p) => '"${p.replaceAll('"', r'\"')}"';

Future<bool> _fileExistsNonZero(String path) async {
  final f = File(path);
  if (!await f.exists()) return false;
  return (await f.length()) > 0;
}

String _tmpPath(String ext) =>
    '${Directory.systemTemp.path}/cover_${DateTime.now().millisecondsSinceEpoch}.$ext';

/// ffprobe JSON
Future<Map<String, dynamic>> _probeJson(String inputPath) async {
  final ipQ = _quoteArg(inputPath);
  final cmd = '-v error -of json -show_format -show_streams -i $ipQ';
  final sess = await FFprobeKit.execute(cmd);
  final out = await sess.getOutput();
  try {
    return json.decode(out ?? '{}') as Map<String, dynamic>;
  } catch (e) {
    debugPrint('probeJson parse failed: $e\n$out');
    return {};
  }
}

/// streams 배열에서 커버 추정 스트림 선택
({int? index, String? type, String? codec}) _pickCoverStream(List streams) {
  int? coverIndex;
  String? coverType;
  String? coverCodec;

  // 1) attached_pic (주로 mp3)
  for (int i = 0; i < streams.length; i++) {
    final s = streams[i];
    if (s is Map<String, dynamic>) {
      final disp = s['disposition'];
      if (disp is Map && disp['attached_pic'] == 1) {
        coverIndex = i;
        coverType = 'attached_pic';
        coverCodec = (s['codec_name'] as String?)?.toLowerCase();
        break;
      }
    }
  }

  // 2) m4a/mp4: video mjpeg/png
  if (coverIndex == null) {
    for (int i = 0; i < streams.length; i++) {
      final s = streams[i];
      if (s is Map<String, dynamic>) {
        final type = s['codec_type'];
        final codec = (s['codec_name'] as String?)?.toLowerCase();
        if (type == 'video' && (codec == 'mjpeg' || codec == 'png')) {
          coverIndex = i;
          coverType = 'video';
          coverCodec = codec;
          break;
        }
      }
    }
  }

  // 3) flac/ogg: attachment 스트림
  if (coverIndex == null) {
    for (int i = 0; i < streams.length; i++) {
      final s = streams[i];
      if (s is Map<String, dynamic>) {
        final type = s['codec_type'];
        final codec = (s['codec_name'] as String?)?.toLowerCase();
        if (type == 'attachment' &&
            (codec == 'png' || codec == 'jpeg' || codec == 'jpg' || codec == 'mjpeg')) {
          coverIndex = i;
          coverType = 'attachment';
          coverCodec = codec == 'jpeg' ? 'jpg' : codec;
          break;
        }
      }
    }
  }

  return (index: coverIndex, type: coverType, codec: coverCodec);
}

/// 1차: attached_pic / video → 이미지 한 프레임 추출
Future<String?> _extractFromVideoLike({
  required String inputPath,
  required int streamIndex,
}) async {
  final ipQ = _quoteArg(inputPath);
  for (final ext in const ['jpg', 'png']) {
    final outPath = _tmpPath(ext);
    final outQ = _quoteArg(outPath);
    final cmd = '-y -i $ipQ -map 0:$streamIndex -frames:v 1 -f image2 $outQ';

    final sess = await FFmpegKit.execute(cmd);
    final rc = await sess.getReturnCode();
    final ok = ReturnCode.isSuccess(rc) && await _fileExistsNonZero(outPath);
    debugPrint('try(attached/video->$ext): rc=$rc, ok=$ok, out=${await sess.getOutput()}');
    if (ok) return outPath;

    try { await File(outPath).delete(); } catch (_) {}
  }
  return null;
}

/// 2차: attachment 스트림 → dump 후 변환 시도
Future<String?> _extractFromAttachment({
  required String inputPath,
  required int streamIndex,
}) async {
  final ipQ = _quoteArg(inputPath);
  final rawOutPath = _tmpPath('bin');
  final rawOutQ = _quoteArg(rawOutPath);

  // 순서 중요: -dump_attachment:$idx → -i → -map -0
  final cmdDump = '-y -dump_attachment:$streamIndex $rawOutQ -i $ipQ -map -0';
  final sessDump = await FFmpegKit.execute(cmdDump);
  final rcDump = await sessDump.getReturnCode();
  final okDump = ReturnCode.isSuccess(rcDump) && await _fileExistsNonZero(rawOutPath);
  debugPrint('try(attachment dump): rc=$rcDump, ok=$okDump, out=${await sessDump.getOutput()}');
  if (!okDump) {
    try { await File(rawOutPath).delete(); } catch (_) {}
    return null;
  }

  for (final ext in const ['png', 'jpg']) {
    final outPath = _tmpPath(ext);
    final outQ = _quoteArg(outPath);
    final inQ = _quoteArg(rawOutPath);
    final cmd = '-y -i $inQ -frames:v 1 -f image2 $outQ';

    final sess = await FFmpegKit.execute(cmd);
    final rc = await sess.getReturnCode();
    final ok = ReturnCode.isSuccess(rc) && await _fileExistsNonZero(outPath);
    debugPrint('convert(attachment->$ext): rc=$rc, ok=$ok, out=${await sess.getOutput()}');
    if (ok) {
      try { await File(rawOutPath).delete(); } catch (_) {}
      return outPath;
    }
    try { await File(outPath).delete(); } catch (_) {}
  }

  if (await _fileExistsNonZero(rawOutPath)) return rawOutPath;
  try { await File(rawOutPath).delete(); } catch (_) {}
  return null;
}

/// 3차: 첫 video 스트림 한 프레임 폴백
Future<String?> _extractFromFirstVideoFallback({
  required String inputPath,
  required List streams,
}) async {
  int? firstVideo;
  for (int i = 0; i < streams.length; i++) {
    final s = streams[i];
    if (s is Map<String, dynamic> && s['codec_type'] == 'video') {
      firstVideo = i;
      break;
    }
  }
  if (firstVideo == null) return null;

  final ipQ = _quoteArg(inputPath);
  for (final ext in const ['jpg', 'png']) {
    final outPath = _tmpPath(ext);
    final outQ = _quoteArg(outPath);
    final cmd = '-y -i $ipQ -map 0:$firstVideo -frames:v 1 -f image2 $outQ';

    final sess = await FFmpegKit.execute(cmd);
    final rc = await sess.getReturnCode();
    final ok = ReturnCode.isSuccess(rc) && await _fileExistsNonZero(outPath);
    debugPrint('fallback(video first->$ext): rc=$rc, ok=$ok, out=${await sess.getOutput()}');
    if (ok) return outPath;

    try { await File(outPath).delete(); } catch (_) {}
  }
  return null;
}

/// 최후 폴백: dart_tags(APIC) (mp3)
Future<String?> _extractCoverWithDartTags(String inputPath) async {
  try {
    if (!File(inputPath).existsSync()) {
      debugPrint('APIC fallback: file not found -> $inputPath');
      return null;
    }

    final tp = TagProcessor();
    final tags = await tp.getTagsFromByteArray(
      File(inputPath).readAsBytes().then((b) => b.toList()),
    );

    for (final tag in tags) {
      final frames = tag?.tags;
      if (frames == null) continue;

      final apic = frames['APIC'] ?? frames['apic'];
      if (apic != null) {
        final List pics = (apic is List) ? apic : [apic];
        for (final p in pics) {
          String mime = 'image/jpeg';
          Uint8List? data;

          if (p is Map) {
            if (p['mime'] is String) mime = p['mime'] as String;
            if (p['picture'] is List<int>) {
              data = Uint8List.fromList(p['picture'] as List<int>);
            } else if (p['data'] is List<int>) {
              data = Uint8List.fromList(p['data'] as List<int>);
            }
          }

          if (data != null && data.isNotEmpty) {
            final ext = mime.contains('png') ? 'png' : 'jpg';
            final outPath = _tmpPath(ext);
            final f = File(outPath);
            await f.writeAsBytes(data, flush: true);
            if (await _fileExistsNonZero(outPath)) {
              debugPrint('✅ APIC extracted by dart_tags: $outPath ($mime)');
              return outPath;
            } else {
              try { await f.delete(); } catch (_) {}
            }
          }
        }
      }
    }
  } catch (e, st) {
    debugPrint('extractCoverWithDartTags error: $e\n$st');
  }
  return null;
}

/// ───────────────── 가사 수집 로직 ─────────────────

String? _firstNonEmpty(Iterable<String?> c) {
  for (final v in c) {
    if (v != null && v.trim().isNotEmpty) return v;
  }
  return null;
}

bool _isWavContainer(Map<String, dynamic> format) {
  final fmt = (format['format_name'] ?? '').toString().toLowerCase();
  return fmt.contains('wav');
}

/// ffprobe FORMAT/STREAM 태그에서 가사 추출
String _collectLyrics(
    Map<String, dynamic> formatTags,
    Map<String, dynamic> streamTags, {
      required bool isWav,
    }) {
  final direct = _firstNonEmpty([
    formatTags['lyrics']?.toString(),
    streamTags['lyrics']?.toString(),
  ]);
  if (direct != null && direct.trim().isNotEmpty) {
    return direct.trim();
  }

  final pieces = <String>[];
  final all = <String, dynamic>{}..addAll(formatTags)..addAll(streamTags);

  all.forEach((rawK, rawV) {
    final k = '$rawK'.toLowerCase();
    final v = (rawV == null) ? '' : '$rawV'.trim();
    if (v.isEmpty) return;

    final baseLyricsKey = k == 'lyrics' ||
        k.startsWith('lyrics-') ||   // lyrics-eng 등 (USLT 매핑)
        k == 'unsyncedlyrics' ||
        k == 'uslt' ||
        k == '©lyr';

    final wavCommentKey = isWav && (k == 'comment' || k == 'icmt' || k == 'comm');

    if (baseLyricsKey || wavCommentKey) pieces.add(v);
  });

  return pieces.join('\n').trim();
}

/// ──────────────── Ogg/Vorbis/Opus: METADATA_BLOCK_PICTURE 처리 ────────────────

int _readBeU32<T extends int>(ByteData bd, int off) => bd.getUint32(off, Endian.big);

/// FLAC PICTURE(base64) 디코드 → 순수 이미지 바이트 반환
Uint8List? _decodeFlacPictureFromBase64(String b64) {
  Uint8List raw;
  try {
    raw = base64.decode(b64.trim());
  } catch (_) {
    return null;
  }
  if (raw.length < 32) return null;

  final bd = ByteData.view(raw.buffer, raw.offsetInBytes, raw.lengthInBytes);
  var off = 0;

  _readBeU32(bd, off); off += 4;                  // type (보통 3: front cover)
  final mimeLen = _readBeU32(bd, off); off += 4;
  if (raw.length < off + mimeLen) return null;    off += mimeLen;

  final descLen = _readBeU32(bd, off); off += 4;
  if (raw.length < off + descLen) return null;    off += descLen;

  off += 4 + 4 + 4 + 4;                           // width, height, depth, colors

  if (raw.length < off + 4) return null;
  final dataLen = _readBeU32(bd, off); off += 4;
  if (dataLen <= 0 || raw.length < off + dataLen) return null;

  return raw.sublist(off, off + dataLen);
}

/// Vorbis/Opus 태그 합본에서 METADATA_BLOCK_PICTURE를 찾아 임시 파일 경로 반환
Future<String?> _extractOggCoverFromTags(Map<String, dynamic> allTags) async {
  final keys = allTags.keys.where((k) => '$k'.toLowerCase() == 'metadata_block_picture');
  if (keys.isEmpty) return null;

  for (final k in keys) {
    final v = allTags[k];
    final list = <String>[];
    if (v is String) list.add(v);
    else if (v is List) for (final e in v) if (e is String) list.add(e);

    for (final b64 in list) {
      final img = _decodeFlacPictureFromBase64(b64);
      if (img != null && img.isNotEmpty) {
        // 간단 시그니처 기반 확장자 추정
        var ext = 'jpg';
        if (img.length >= 8 && img[0]==0x89 && img[1]==0x50 && img[2]==0x4E && img[3]==0x47) {
          ext = 'png';
        } else if (img.length >= 12 &&
            utf8.decode(img.sublist(8,12), allowMalformed: true).toUpperCase() == 'WEBP') {
          ext = 'webp';
        }

        final out = _tmpPath(ext);
        await File(out).writeAsBytes(img, flush: true);
        if (await _fileExistsNonZero(out)) return out;
      }
    }
  }
  return null;
}

/// ───────────────────── 메인: 태그 + 커버 추출 ─────────────────────
Future<Map<String, String>> readAudioTags(
    String filePath, {
      bool extractArtwork = true,
    }) async {
  final j = await _probeJson(filePath);
  final Map<String, dynamic> format =
  (j['format'] is Map) ? Map<String, dynamic>.from(j['format']) : const {};
  final List streams =
  (j['streams'] is List) ? List<Map<String, dynamic>>.from(j['streams']) : const [];

  Map<String, dynamic> _collectTags(Map<String, dynamic>? map) {
    if (map == null) return {};
    final t = map['tags'];
    if (t is Map) return Map<String, dynamic>.from(t);
    return {};
  }

  final formatTags = _collectTags(format);
  final Map<String, dynamic> streamTags = {};
  for (final s in streams) {
    if (s is Map<String, dynamic>) {
      final t = _collectTags(s);
      for (final e in t.entries) {
        streamTags.putIfAbsent(e.key, () => e.value);
      }
    }
  }

  String? _getTag(List<String> keys) {
    for (final k in keys) {
      final v1 = formatTags[k];
      if (v1 != null && '$v1'.trim().isNotEmpty) return '$v1';
      final v2 = streamTags[k];
      if (v2 != null && '$v2'.trim().isNotEmpty) return '$v2';
    }
    return null;
  }

  String? _normalizeTrack(String? v) {
    if (v == null) return null;
    final t = v.split('/').first.trim();
    return t.isEmpty ? null : t;
  }

  // WAV 여부 → 가사 수집
  final isWav = _isWavContainer(format);
  final lyrics = _collectLyrics(formatTags, streamTags, isWav: isWav);

  // Ogg/Opus 여부
  bool _isOggLike(String s) {
    final x = s.toLowerCase();
    return x.contains('ogg') || x.contains('opus');
  }
  final isOgg = _isOggLike('${format['format_name'] ?? ''}');

  final out = <String, String>{
    'title':       _getTag(['title', 'TITLE']) ?? '',
    'artist':      _getTag(['artist', 'ARTIST']) ?? '',
    'album':       _getTag(['album', 'ALBUM']) ?? '',
    'albumArtist': _getTag(['album_artist', 'albumartist', 'ALBUMARTIST']) ?? '',
    'genre':       _getTag(['genre', 'GENRE']) ?? '',
    'year':        _getTag(['date', 'YEAR', 'year']) ?? '',
    'track':       _normalizeTrack(_getTag(['track', 'TRACK', 'tracknumber', 'TRACKNUMBER'])) ?? '',
    'disc':        _normalizeTrack(_getTag(['disc', 'DISC', 'discnumber', 'DISCNUMBER'])) ?? '',
    'lyrics':      lyrics,
    'has_artwork': 'false',
  };

  if (!extractArtwork) return out;

  String? artworkPath;

  // 0) Ogg/Opus: 태그의 METADATA_BLOCK_PICTURE 먼저 시도
  if (isOgg) {
    final allLower = <String, dynamic>{};
    for (final e in formatTags.entries) { allLower[e.key.toLowerCase()] = e.value; }
    for (final e in streamTags.entries) { allLower[e.key.toLowerCase()] = e.value; }
    artworkPath = await _extractOggCoverFromTags(allLower);
    if (artworkPath != null) {
      debugPrint('✅ OGG cover extracted from METADATA_BLOCK_PICTURE: $artworkPath');
    }
  }

  // 1) attached_pic / video
  if (artworkPath == null) {
    final picked = _pickCoverStream(streams);
    final coverIndex = picked.index;
    final coverType  = picked.type;

    if (coverIndex != null && (coverType == 'attached_pic' || coverType == 'video')) {
      artworkPath = await _extractFromVideoLike(
        inputPath: filePath,
        streamIndex: coverIndex,
      );
    }

    // 2) attachment
    if (artworkPath == null && coverIndex != null && coverType == 'attachment') {
      artworkPath = await _extractFromAttachment(
        inputPath: filePath,
        streamIndex: coverIndex,
      );
    }
  }

  // 3) 첫 video 프레임 폴백
  if (artworkPath == null) {
    artworkPath = await _extractFromFirstVideoFallback(
      inputPath: filePath,
      streams: streams,
    );
  }

  // 4) ID3(APIC) 폴백
  if (artworkPath == null) {
    artworkPath = await _extractCoverWithDartTags(filePath);
  }

  if (artworkPath != null && await _fileExistsNonZero(artworkPath)) {
    out['artwork_path'] = artworkPath;
    out['artwork_mime'] = artworkPath.endsWith('.png')
        ? 'image/png'
        : (artworkPath.endsWith('.webp') ? 'image/webp' : 'image/jpeg');
    out['has_artwork']  = 'true';
    debugPrint('✅ cover extracted: $artworkPath');
  } else {
    debugPrint('! No cover found in file (after all fallbacks).');
  }

  return out;
}
