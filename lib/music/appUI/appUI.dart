// lib/music/appUI/appUI.dart (예시: BUttonChoice 정의가 있는 파일을 가정)
// 필요한 경우 파일 경로에 맞게 붙여 넣으세요.

import 'package:bbo_music_player/music/appUI/subtitles/lyrics_overlay.dart';
import 'package:bbo_music_player/music/appUI/subtitles/subtitle_BoxEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';

// 로컬라이제이션: 현재 프로젝트 구조에 맞춰 패키지 경로 고정
import 'package:bbo_music_player/l10n/app_localizations.dart';

// 필요한 경우: 파일 피커, 메타데이터 UI
import 'metadata_ui.dart';
import 'myPick.dart';

class BUttonChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(210)),
            ),
            child: IconButton(
              onPressed: () async {
                final path = await PickAudioFile(
                  ['mp3','wav','flac','aac','ogg','opus','m4a','mp4'],
                );
                if (path.isNotEmpty) {
                  return showModalBottomSheet(
                    context: context,
                    isDismissible: true,
                    enableDrag: false,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      // 비율 기반 높이로 회전/키보드 대응
                      return FractionallySizedBox(
                        heightFactor: 0.8,
                        child: Material(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                          clipBehavior: Clip.antiAlias,
                          child: SafeArea(
                            top: false,
                            child: ScaffoldMessenger(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Builder(
                                  builder: (sheetCtx) => AudioTagViewer(
                                    filePath: path,
                                    onShowBanner: (banner) {
                                      final m = ScaffoldMessenger.of(sheetCtx);
                                      m
                                        ..removeCurrentMaterialBanner()
                                        ..showMaterialBanner(banner); // 시트 안에서만 표시
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              padding: EdgeInsets.zero,
              icon: Image.asset(
                'assets/buttonImage/button1.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
          ),
          Card(
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(210)),
            ),
            child: IconButton(
              onPressed: () async {
                // 1) SYSTEM_ALERT_WINDOW 권한
                if (!await Permission.systemAlertWindow.isGranted) {
                  final status = await Permission.systemAlertWindow.request();
                  if (!status.isGranted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(t.overlayPermissionNeeded)),
                    );
                    return;
                  }
                }

                // 2) OverlayWindow 권한
                final granted = await FlutterOverlayWindow.isPermissionGranted()
                    || (await FlutterOverlayWindow.requestPermission() ?? false);
                if (!granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.overlayWindowDenied)),
                  );
                  return;
                }

                await showDialog<void>(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(t.chooseActionTitle),
                      content: Text(t.chooseActionBody),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const Scaffold(
                                  body: OverlayBoxEditor(),
                                ),
                              ),
                            );
                          },
                          child: Text(t.actionEditOverlay),
                        ),
                        FilledButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final path = await PickAudioFile(
                              ['mp3','wav','flac','aac','ogg','opus','m4a','mp4'],
                            );
                            if (path.isEmpty) return;
                            await LYricsOverlay.instance.SHow(
                              filePath: path,
                              context: context,
                            );
                          },
                          child: Text(t.actionLoadSubtitles),
                        ),
                      ],
                    );
                  },
                );
              },
              padding: EdgeInsets.zero,
              icon: Image.asset(
                'assets/buttonImage/button2.png',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

