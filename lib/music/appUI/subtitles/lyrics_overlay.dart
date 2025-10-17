import 'dart:io' show Platform;
import 'package:flutter/widgets.dart';
import 'package:bbo_music_player/music/appUI/subtitles/androidUser/subtitles_android.dart' as android_impl;
import 'package:bbo_music_player/music/appUI/subtitles/iphoneUser/subtitles_ios.dart' as ios_impl;

/// 공통 API (싱글턴)
abstract class LYricsOverlay {
  static LYricsOverlay? _instance;

  static LYricsOverlay get instance {
    return _instance ??= (Platform.isAndroid
        ? android_impl.ANdroidLyricsOverlay()
        : ios_impl.IOsLyricsOverlay());
  }

  Future<void> SHow({required String filePath, BuildContext? context});

}
