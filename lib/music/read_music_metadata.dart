// lib/music/read_music_metadata.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:dart_tags/dart_tags.dart';

/// 경로를 ffmpeg/ffprobe 인자용으로 안전하게 "..." 로 감싸되 내부 " 를 이스케이프
String _quoteArg(String p) => '"${p.replaceAll('"', r'\"')}"';

Future<bool> _fileExistsNonZero(String path) async {
  final f = File(path);
  if (!await f.exists()) return false;
  return (await f.length()) > 0;
}

String _tmpPath(String ext) =>
    '${Directory.systemTemp.path}/cover_${DateTime.now().millisecondsSinceEpoch}.$ext';

/// ffprobe를 직접 실행하여 JSON으로 받는다 (경로 인용 필수)
Future<Map<String, dynamic>> _probeJson(String inputPath) async {
  final ipQ = _quoteArg(inputPath);
  // 일부 환경에서 -print_format 보다 -of 가 호환성이 더 낫다
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

/// streams 배열에서 커버 스트림을 선택 (이전 코드 유지)
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

  // 2) m4a/mp4: video 스트림이 mjpeg/png인 커버
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

/// 1차: attached_pic / video → 한 프레임 이미지로 추출 (이전 코드 유지; FFmpeg 사용)
Future<String?> _extractFromVideoLike({
  required String inputPath,
  required int streamIndex,
}) async {
  final ipQ = _quoteArg(inputPath); // 인용된 입력 경로
  for (final ext in const ['jpg', 'png']) {
    final outPath = _tmpPath(ext);    // 실제 파일 시스템 경로 (인용 X)
    final outQ = _quoteArg(outPath);  // ffmpeg 인자용 인용 버전
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

/// 2차: attachment 스트림 → dump 후 필요시 변환 (이전 코드 유지; FFmpeg 사용)
Future<String?> _extractFromAttachment({
  required String inputPath,
  required int streamIndex,
}) async {
  final ipQ = _quoteArg(inputPath);
  final rawOutPath = _tmpPath('bin');
  final rawOutQ = _quoteArg(rawOutPath);

  // 순서 민감: -dump_attachment:$idx -> -i -> -map -0
  final cmdDump = '-y -dump_attachment:$streamIndex $rawOutQ -i $ipQ -map -0';
  final sessDump = await FFmpegKit.execute(cmdDump);
  final rcDump = await sessDump.getReturnCode();
  final okDump = ReturnCode.isSuccess(rcDump) && await _fileExistsNonZero(rawOutPath);
  debugPrint('try(attachment dump): rc=$rcDump, ok=$okDump, out=${await sessDump.getOutput()}');
  if (!okDump) {
    try { await File(rawOutPath).delete(); } catch (_) {}
    return null;
  }

  // 원본이 이미지일 수도 있지만, 표준 이미지로 변환 시도
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

  // 변환 실패 시 원본 유지(실제 이미지일 수 있음)
  if (await _fileExistsNonZero(rawOutPath)) return rawOutPath;
  try { await File(rawOutPath).delete(); } catch (_) {}
  return null;
}

/// 3차 폴백: 첫 video 스트림의 1프레임을 썸네일로 (이전 코드 유지)
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

/// 최후 폴백: dart_tags(APIC) 추출 (mp3) — 이전 코드 유지
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

/// ---------- 가사 수집 로직 보강(여기만 변경) ----------

String? _firstNonEmpty(Iterable<String?> c) {
  for (final v in c) {
    if (v != null && v.trim().isNotEmpty) return v;
  }
  return null;
}

/// 가사 전용 수집기:
/// - ffprobe가 USLT(Unsynced Lyrics)를 `lyrics-<언어코드>` 등으로 노출하는 사례를 포함해
///   lyrics / lyrics-* / unsyncedlyrics / USLT / ©lyr 등을 모두 모아 결합.  :contentReference[oaicite:1]{index=1}
String _collectLyrics(Map<String, dynamic> formatTags, Map<String, dynamic> streamTags) {
  // 1) 명시적 'lyrics' 키가 있으면 우선 사용
  final direct = _firstNonEmpty([
    formatTags['lyrics']?.toString(),
    streamTags['lyrics']?.toString(),
  ]);
  if (direct != null && direct.trim().isNotEmpty) {
    return direct.trim();
  }

  // 2) 변종 키 전수 탐색
  final pieces = <String>[];
  final all = <String, dynamic>{}..addAll(formatTags)..addAll(streamTags);

  all.forEach((rawK, rawV) {
    final k = '$rawK'.toLowerCase();
    final v = (rawV == null) ? '' : '$rawV'.trim();
    if (v.isEmpty) return;

    final isLyricsKey = k == 'lyrics' ||
        k.startsWith('lyrics-') ||   // lyrics-eng, lyrics-XXX (USLT 매핑) :contentReference[oaicite:2]{index=2}
        k == 'unsyncedlyrics' ||
        k == 'uslt' ||               // 프레임명 그대로 노출될 수 있음
        k == '©lyr';                 // m4a/QuickTime 변종

    if (isLyricsKey) pieces.add(v);
  });

  return pieces.join('\n').trim();
}

/// ---------- 메인: 태그 + 커버(이전 로직 유지) ----------
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

  // ← 가사만 보강된 추출
  final lyrics = _collectLyrics(formatTags, streamTags);

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

  // ── 커버 추출(이전 그대로) ───────────────────────────────────────
  final picked = _pickCoverStream(streams);
  final coverIndex = picked.index;
  final coverType  = picked.type;
  String? artworkPath;

  // attached_pic / video
  if (coverIndex != null && (coverType == 'attached_pic' || coverType == 'video')) {
    artworkPath = await _extractFromVideoLike(
      inputPath: filePath,
      streamIndex: coverIndex,
    );
  }

  // attachment
  if (artworkPath == null && coverIndex != null && coverType == 'attachment') {
    artworkPath = await _extractFromAttachment(
      inputPath: filePath,
      streamIndex: coverIndex,
    );
  }

  // 첫 video 프레임 폴백
  if (artworkPath == null) {
    artworkPath = await _extractFromFirstVideoFallback(
      inputPath: filePath,
      streams: streams,
    );
  }

  // ID3(APIC) 폴백
  if (artworkPath == null) {
    artworkPath = await _extractCoverWithDartTags(filePath);
  }

  if (artworkPath != null && await _fileExistsNonZero(artworkPath)) {
    out['artwork_path'] = artworkPath;
    out['artwork_mime'] = artworkPath.endsWith('.png') ? 'image/png' : 'image/jpeg';
    out['has_artwork']  = 'true';
    debugPrint('✅ cover extracted: $artworkPath');
  } else {
    debugPrint('! No cover found in file (after all fallbacks).');
  }

  return out;
}
