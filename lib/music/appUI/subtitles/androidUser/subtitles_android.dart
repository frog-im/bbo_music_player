// subtitles_android.dart (DIAGNOSTIC/SMOKE TEST MODE 쪽 파일)

// 1) imports 보강
import 'dart:convert';                 // ← 추가
import 'dart:io';                      // ← 추가
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../main.dart';
import '../../../read_music_metadata.dart' as meta;
import '../lyrics_overlay.dart';

// 가사/메타데이터 유틸 (경로 확인)

class ANdroidLyricsOverlay implements LYricsOverlay {
  @override
  Future<void> SHow({required String filePath, BuildContext? context}) async {
    // 1️⃣ SYSTEM_ALERT_WINDOW 권한
    if (!await Permission.systemAlertWindow.isGranted) {
      final status = await Permission.systemAlertWindow.request();
      if (!status.isGranted) {
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('오버레이 권한이 필요합니다. 설정에서 허용해주세요.')),
          );
        }
        return;
      }
    }

    // 2️⃣ OverlayWindow 권한
    final granted = await FlutterOverlayWindow.isPermissionGranted()
        || (await FlutterOverlayWindow.requestPermission() ?? false);
    if (!granted) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Overlay Window 권한이 거부되었습니다.')),
        );
      }
      return;
    }

    // 3️⃣ 실제 오버레이 실행
    await FlutterOverlayWindow.showOverlay(
      alignment: OverlayAlignment.bottomCenter,
      enableDrag: false,
      overlayTitle: '가사 오버레이 실행됨',
    );

    // 4️⃣ 가사 로드 후 오버레이로 전송 (없으면 경로만)
    final lyrics = await REsolveLyrics(filePath);    // ← 추가


    await FlutterOverlayWindow.shareData(lyrics);
    await FlutterOverlayWindow.moveOverlay(OverlayPosition(0, -350));
  }

  // 5️⃣ 가사 해석기: 메타 태그 우선, 없으면 sidecar(.lrc/.txt) 폴백
  Future<String?> REsolveLyrics(String filePath) async {
    try {
      // A) ffprobe 기반 태그에서 가사 추출 (USLT → lyrics-<lang> 매핑 포함 처리)
      final tags = await meta.readAudioTags(filePath, extractArtwork: false);
      final fromMeta = tags['lyrics']?.trim();
      if (fromMeta != null && fromMeta.isNotEmpty) {
        return _normalizeNewlines(fromMeta);
      }

      // B) sidecar: 동일 파일명의 .lrc 또는 .txt
      final f = File(filePath);
      final dir = f.parent;
      final base = f.uri.pathSegments.isEmpty ? '' : f.uri.pathSegments.last;
      final dot = base.lastIndexOf('.');
      final stem = dot > 0 ? base.substring(0, dot) : base;

      for (final ext in const ['lrc', 'txt']) {
        final cand = File('${dir.path}${Platform.pathSeparator}$stem.$ext');
        if (await cand.exists()) {
          final s = await cand.readAsString();
          final t = s.trim();
          if (t.isNotEmpty) return _normalizeNewlines(t);
        }
      }
    } catch (e) {
      // 필요시 로깅
      // debugPrint('REsolveLyrics error: $e');
    }
    return null;
  }

  // 개행/공백 정리
  String _normalizeNewlines(String s) =>
      s.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

}
