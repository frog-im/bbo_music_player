// lib/music/appUI/subtitles/lyrics_overlay.dart
import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';
import 'package:bbo_music_player/music/appUI/subtitles/androidUser/subtitles_android.dart' as android_impl;
import 'package:bbo_music_player/music/appUI/subtitles/iphoneUser/subtitles_ios.dart' as ios_impl;

import '../../admob/ad_orchestrator.dart';

abstract class LYricsOverlay {
  static LYricsOverlay? _instance;

  static LYricsOverlay get instance {
    final base = Platform.isAndroid
        ? android_impl.ANdroidLyricsOverlay()
        : ios_impl.IOsLyricsOverlay();
    return _instance ??= ADWrappedLyricsOverlay(base);
  }

  Future<void> SHow({required String filePath, BuildContext? context});
}

class ADWrappedLyricsOverlay implements LYricsOverlay {
  final LYricsOverlay _inner;
  ADWrappedLyricsOverlay(this._inner);

  @override
  Future<void> SHow({required String filePath, BuildContext? context}) async {
    if (Platform.isAndroid) {
      // 광고가 **닫힐 때까지** 대기
      await ADOrchestrator.instance.showInterstitialAndWaitForDismiss();
    }
    await _inner.SHow(filePath: filePath, context: context);
  }
}
