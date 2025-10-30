// lib/music/appUI/appUI.dart
import 'package:bbo_music_player/music/appUI/subtitles/lyrics_overlay.dart';
import 'package:bbo_music_player/music/appUI/subtitles/subtitle_BoxEditor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bbo_music_player/l10n/app_localizations.dart';

// ⬇︎ 추가
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import 'metadata_ui.dart';
import 'myPick.dart';

class BUttonChoice extends StatelessWidget {
  const BUttonChoice({super.key});

  static const String kWarnSkipKey = 'meta_warn_skip_non_mp3';

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─────────────────────────────────────────────────────────
          // [버튼 #1] 메타데이터/태그 편집(파일 선택 → 바텀시트)
          // ─────────────────────────────────────────────────────────
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

                if (path.isEmpty) return;

                // ⬇︎ 확장자 위험 알림(세션 1회/‘다시 보지 않기’ 지원)
                final ext = p.extension(path).toLowerCase();
                final proceed = await _maybeWarnMetadataRisk(context, ext);
                if (!proceed || !context.mounted) return;

                // 원래 흐름: 바텀시트 열기
                // (이하 동일)
                // 비율 기반 높이로 회전/키보드 대응
                // ignore: use_build_context_synchronously
                await showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  enableDrag: false,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
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
                                      ..showMaterialBanner(banner);
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

          // ─────────────────────────────────────────────────────────
          // [버튼 #2] 오버레이/자막
          // ─────────────────────────────────────────────────────────
          Card(
            elevation: 10,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(210)),
            ),
            child: IconButton(
              onPressed: () async {
                final t = AppLocalizations.of(context)!;

                // 1) SYSTEM_ALERT_WINDOW 권한
                if (!await Permission.systemAlertWindow.isGranted) {
                  final status = await Permission.systemAlertWindow.request();
                  if (!status.isGranted) {
                    if (!context.mounted) return;
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
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.overlayWindowDenied)),
                  );
                  return;
                }

                if (!context.mounted) return;
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

  // ─────────────────────────────────────────────────────────
  // 경고 노출 여부 로직
  // ─────────────────────────────────────────────────────────
  bool _shouldWarnForExt(String extLowerWithDot) {
    // MP3는 비교적 호환 안정( ID3v2 / APIC )이 높은 편.
    // 그 외 컨테이너는 플레이어/태거/도구별로 차이가 커 경고 대상에 포함.
    switch (extLowerWithDot) {
      case '.mp3':
        return false;
      case '.m4a':
      case '.mp4':
      case '.aac':
      case '.flac':
      case '.ogg':
      case '.opus':
      case '.wav':
      default:
        return true;
    }
  }

  Future<bool> _maybeWarnMetadataRisk(BuildContext ctx, String extLowerWithDot) async {
    final t = AppLocalizations.of(ctx)!;

    if (!_shouldWarnForExt(extLowerWithDot)) return true;

    // “다시 보지 않기”가 이미 설정되었으면 통과
    final sp = await SharedPreferences.getInstance();
    if (sp.getBool(kWarnSkipKey) == true) return true;

    // 경고 다이얼로그
    bool dontShowAgain = false;
    final proceed = await showDialog<bool>(
      context: ctx,
      barrierDismissible: true,
      builder: (dCtx) {
        return StatefulBuilder(
          builder: (dCtx, setState) {
            return AlertDialog(
              title: Text(t.warningTitle), // 예: “메타데이터 편집 주의”
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // 예시 문구: 로컬라이즈 키로 치환하셔도 됩니다.
                    // “MP3 외의 일부 포맷은 태그/커버 삽입이 제한되거나
                    //  플레이어별 호환성이 달라 편집이 실패할 수 있습니다.”
                    t.metadataRiskBody,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // 간단한 배경 설명 (줄이거나 제거 가능)
                    t.metadataRiskFormatsDetail, // “M4A/MP4는 iTunes atoms, Ogg/Opus는 Vorbis Comment,
                    //  FLAC은 Vorbis Comment/PICTURE, WAV는 LIST-INFO를 사용합니다.”
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: dontShowAgain,
                        onChanged: (v) => setState(() => dontShowAgain = v ?? false),
                      ),
                      Expanded(child: Text(t.doNotShowAgain)),
                    ],
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dCtx).pop(false),
                  child: Text(t.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dCtx).pop(true),
                  child: Text(t.continueLabel),
                ),
              ],
            );
          },
        );
      },
    );

    if (proceed == true && dontShowAgain) {
      await sp.setBool(kWarnSkipKey, true);
    }
    return proceed == true;
  }
}
