import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ← 좌표 로드
import '../../../../main.dart';
import '../../../read_music_metadata.dart' as meta;
import '../lyrics_overlay.dart';

// 에디터와 동일한 키 사용(dp로 저장)
const String _kX = 'overlay_box_x';
const String _kY = 'overlay_box_y';

class ANdroidLyricsOverlay implements LYricsOverlay {
  @override
  Future<void> SHow({required String filePath, BuildContext? context}) async {
    /*// 1) SYSTEM_ALERT_WINDOW 권한
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

    // 2) OverlayWindow 권한
    final granted = await FlutterOverlayWindow.isPermissionGranted()
        || (await FlutterOverlayWindow.requestPermission() ?? false);
    if (!granted) {
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Overlay Window 권한이 거부되었습니다.')),
        );
      }
      return;
    }*/

    // 3) 오버레이 크기(px) 계산
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final widthPx  = (view.physicalSize.width  * 0.75).round();
    final heightPx = (view.physicalSize.height * 0.10).round();

    // 3.5) 시작 좌표 로드(dp 그대로 사용)
    final startOffset = await LOadSavedOverlayOffset();

    // 4) 오버레이 실행: 시작 좌표를 startPosition으로 지정
    await FlutterOverlayWindow.showOverlay(
      width: widthPx,
      height: heightPx,
      alignment: OverlayAlignment.topLeft, // 시작 기준: 좌상단
      positionGravity: PositionGravity.none, // 스냅/흡착 비활성
      enableDrag: false,
      flag: OverlayFlag.focusPointer,
      overlayTitle: '가사 오버레이 실행됨',
      startPosition: OverlayPosition(startOffset.dx, startOffset.dy), // ← 변경 핵심
    );

    // 5) 가사 로드 및 전송
    final lyrics = await REsolveLyrics(filePath);
    await FlutterOverlayWindow.shareData(lyrics);

    // 6) (삭제) 이전에는 moveOverlay로 이동했으나 이제 필요 없음
    // await Future.delayed(const Duration(milliseconds: 16));
    // await MOveOverlayToSavedOrZero();
  }

  // 가사 해석기: 메타 태그 → sidecar(.lrc/.txt)
  Future<String?> REsolveLyrics(String filePath) async {
    try {
      // A) 태그에서 가사 추출
      final tags = await meta.readAudioTags(filePath, extractArtwork: false);
      final fromMeta = tags['lyrics']?.trim();
      if (fromMeta != null && fromMeta.isNotEmpty) {
        return _NOrmalizeNewlines(fromMeta);
      }

      // B) sidecar 파일(.lrc/.txt) 탐색
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
          if (t.isNotEmpty) return _NOrmalizeNewlines(t);
        }
      }
    } catch (_) {
      // 필요 시 로깅
    }
    return null;
  }
}

// 개행/공백 정리(요청 규칙: 앞 두 글자 대문자)
String _NOrmalizeNewlines(String s) =>
    s.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

// ───────────────────────────────────────────────────────────────
// 저장된 좌표(dp)를 읽어 startPosition에 그대로 사용
// ───────────────────────────────────────────────────────────────

Future<Offset> LOadSavedOverlayOffset() async {
  final sp = await SharedPreferences.getInstance();
  final double xDp = sp.getDouble(_kX) ?? 0.0;
  final double yDp = sp.getDouble(_kY) ?? 0.0;
  return Offset(xDp, yDp); // 변환 없음: dp 그대로 유지
}

/*// 참고: 이제 startPosition을 쓰므로 이동 함수는 사용하지 않음
Future<void> MOveOverlayToSavedOrZero() async {
  try {
    final pos = await LOadSavedOverlayOffset();
    await FlutterOverlayWindow.moveOverlay(
      OverlayPosition(pos.dx, pos.dy),
    );
  } catch (_) {
    // 오버레이 미실행 등: 조용히 무시
  }
}*/
