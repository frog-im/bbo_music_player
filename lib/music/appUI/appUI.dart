import 'package:bbo_music_player/music/appUI/subtitles/lyrics_overlay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'metadata_ui.dart';
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
                    String path = await pickAudioFile(['mp3', 'wav', 'flac', 'aac', 'ogg', 'm4a'],write);
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
                    height: MediaQuery.of(context).size.width * 0.3,
                  ),
                )
            ),
            SizedBox(height: 17),
            Card(
                elevation: 10,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.circular(36),
                    borderRadius: BorderRadiusGeometry.only(bottomRight: Radius.circular(210))
                ),
                child: IconButton(
                  onPressed: () async {
                    String path = await pickAudioFile(['mp3', 'wav', 'flac', 'aac', 'ogg', 'm4a'],subtitles);

                    if (path.isEmpty) return;
                    // ✅ 플랫폼 분기는 내부에서 1회만: 캐싱된 구현체가 실행됨
                    await LYricsOverlay.instance.SHow(filePath: path, context: context);

                  },
                  padding: EdgeInsets.zero,
                  icon: Image.asset(
                    'assets/buttonImage/button2.png',
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width /** 0.5*/,
                    height: MediaQuery.of(context).size.width * 0.3,
                  ),
                )
            ),

          ],
        )
      // )
    );
  }


}
