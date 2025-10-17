import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// 기존 앱 임포트
import 'music/admob/main_admob_top__bottom.dart';
import 'music/appUI/appUI.dart';
import 'music/appUI/metadata_ui.dart';

// ▶ 오버레이 UI 위젯(안드로이드 전용)을 참조하기 위해 추가
import 'music/appUI/subtitles/androidUser/androidUI_subtitles.dart';
import 'music/appUI/subtitles/androidUser/subtitles_android.dart' show AndroidLyricsOverlayApp;

/// ------------------------
/// 오버레이 전용 엔트리포인트
/// * 반드시 main.dart 최상위 + @pragma 필요
/// * 플러그인이 이 심볼을 찾아 별도 엔진으로 구동
/// ------------------------

bool Overlaylock = false;

@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AndroidLyricsOverlayApp());
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 상태바/내비바 숨김
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  // AdMob 초기화
  await MobileAds.instance.initialize();
  // 웹/앱 구분
  final bool isWeb = kIsWeb;
  runApp(MYapp(isWeb));
}

class MYapp extends StatefulWidget {
  final bool classification; // true: web, false: app
  const MYapp(this.classification, {super.key});

  @override
  State<MYapp> createState() => _MAinAppState();
}

class _MAinAppState extends State<MYapp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // ✅ 핵심 수정: MaterialApp 아래 컨텍스트를 얻기 위해 Builder 한 겹
      home: Builder(
        builder: (innerCtx) {
          return PopScope<Object?>(
            canPop: false,
            // Flutter 3.22+ 에서 권장. 낮은 버전은 onPopInvoked 사용
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;

              // ✅ 반드시 MaterialApp 아래 컨텍스트로 showDialog 호출
              final allow = await SHowExitConfirmDialog(innerCtx);
              if (allow && innerCtx.mounted) {
                SystemNavigator.pop();
              }
            },


                child:widget.classification
              // 웹 전용(임시)
                  ? const Scaffold(backgroundColor: Colors.black)
              // 앱 전용
                  : Scaffold(
                //backgroundColor: const Color.fromRGBO(255, 251, 241, .9),
                  body: Container (
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/backgroundImage.png'),
                        fit: BoxFit.cover, // 화면 전체 채우기
                      ),
                    ),
                    child:Column(
                      children: [
                        const Banner320x50_top(),
                        Expanded(child: Center(child: BUttonChoice())),
                        const Banner320x50_bottom(),
                      ],
                    ),
                  )

              ),


          );
        },
      ),
    );
  }
}

/// ───────────────────────────── 종료 확인 다이얼로그 ─────────────────────────────
/// returns: true=닫기(종료), false/null=취소
Future<bool> SHowExitConfirmDialog(BuildContext context) async {
  // ✅ showDialog는 MaterialLocalizations가 있는 컨텍스트여야 한다
  //    (MaterialApp 아래). 지금 context는 innerCtx라 안전.
  final res = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => const _ExitDialogWithAd(),
  );
  return res == true;
}

class _ExitDialogWithAd extends StatefulWidget {
  const _ExitDialogWithAd();

  @override
  State<_ExitDialogWithAd> createState() => _ExitDialogWithAdState();
}

class _ExitDialogWithAdState extends State<_ExitDialogWithAd> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _LOadBanner();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  // 중앙 광고 로드: MREC(300x250)
  void _LOadBanner() {
    final adUnitId = _GetDemoMrecAdUnitId(); // 개발/테스트용. 배포 전 교체 필수.
    if (adUnitId.isEmpty) return;

    final ad = BannerAd(
      size: AdSize.mediumRectangle, // 300x250
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          setState(() => _loaded = false);
        },
      ),
    );
    ad.load();
    _ad = ad;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '앱을 종료하시겠습니까?',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '광고',
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.black54),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 300,
                height: 250,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _loaded && _ad != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AdWidget(ad: _ad!),
                )
                    : const _AdPlaceholder(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('취소'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: const Text('종료',style: TextStyle(color: Color.fromRGBO(252, 238, 255, 1))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdPlaceholder extends StatelessWidget {
  const _AdPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 300, height: 250,
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

/// 플랫폼별 데모 단위 아이디(테스트 모드). 실제 배포 전 운영 ID로 교체 + 테스트 단말 등록.
String _GetDemoMrecAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111'; // Android 테스트 배너
  } else if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716'; // iOS 테스트 배너
  }
  return '';
}
