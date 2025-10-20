import 'package:bbo_music_player/music/appUI/subtitles/lyrics_overlay.dart';
import 'package:bbo_music_player/music/appUI/subtitles/subtitle_BoxEditor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import 'package:permission_handler/permission_handler.dart';
import 'metadata_ui.dart';
import 'metadata_ui.dart' as pick;
import 'myPick.dart';


class BUttonChoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      //padding: const EdgeInsets.all(20),
        padding: EdgeInsetsGeometry.only(bottom: 20,top: 20),
        // child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
                elevation: 10,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(

                  //borderRadius: BorderRadius.circular(36),
                    borderRadius: BorderRadiusGeometry.only(topLeft: Radius.circular(210))
                ),
                child: IconButton(
                  onPressed: () async {
                    //print("이미지 버튼 클릭");
                    final path = await PickAudioFile(
                      ['mp3','wav','flac','aac','ogg','opus','m4a','mp4']
                    );
                    //String path = await PickAudioFile(['mp3', 'wav', 'flac', 'aac', 'ogg', 'm4a'],write);
                    if (path.isNotEmpty) {
                      //print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@---------------------$path'); getPath(path);

                      return showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        enableDrag: false,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          // MediaQuery 의존 최소화: 비율 기반으로 높이 지정(키보드/회전에도 안정)
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
                    width: MediaQuery.of(context).size.width /** 0.5*/,
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                )
            ),
            //SizedBox(height: 1.7),
            Card(
                elevation: 10,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.circular(36),
                    borderRadius: BorderRadiusGeometry.only(bottomRight: Radius.circular(210))
                ),
                child: IconButton(
                  onPressed: () async {
                    // 1) SYSTEM_ALERT_WINDOW 권한
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
                    }

                    await showDialog<void>(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text('어떤 동작을 실행할까요?'),
                          content: const Text('둘 중 하나를 선택하면 즉시 실행됩니다.'),
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
                                }, child: const Text('사이즈 위치 설정')),

                            FilledButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final path = await PickAudioFile(
                                    ['mp3','wav','flac','aac','ogg','opus','m4a','mp4']
                                  );
                                  //String path = await PickAudioFile(['mp3', 'wav', 'flac', 'aac', 'ogg', 'm4a'],subtitles);
                                  if (path.isEmpty) return;
                                  // ✅ 플랫폼 분기는 내부에서 1회만: 캐싱된 구현체가 실행됨
                                  await LYricsOverlay.instance.SHow(filePath: path, context: context);
                                }, child: const Text('자막 불러오기')),
                          ],
                        );
                      },
                    );


                  },
                  padding: EdgeInsets.zero,
                  icon: Image.asset(
                    'assets/buttonImage/button2.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width /** 0.5*/,
                    height: MediaQuery.of(context).size.height * 0.17,
                  ),
                )
            ),

          ],
        )
      // )
    );
  }


}
