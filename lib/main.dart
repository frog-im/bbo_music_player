
// lib/main.dart
import 'dart:async';
import 'dart:io' show Platform, File;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

// FFmpegKit (new_min)
import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new_min/ffmpeg_kit_config.dart';

// l10n
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

// 광고/앱 모듈
import 'music/admob/ad_orchestrator.dart';
import 'music/admob/main_admob_top__bottom.dart';
import 'music/appUI/appUI.dart';

// 오버레이 전용(안드로이드)
import 'music/appUI/subtitles/androidUser/androidUI_subtitles.dart';

// 프라이버시 헬퍼
import 'privacy/privacy_gate.dart';

bool Overlaylock = false;

// ─────────────────────────────────────────────────────────────────────────────
// 오버레이 엔트리포인트(별도 FlutterEngine)
// 주의: 여기서는 FFmpegKit 직접 호출 금지
// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AndroidLyricsOverlayApp()); // 이 위젯 안의 MaterialApp에도 l10n 등록 필수
}

// ─────────────────────────────────────────────────────────────────────────────
// FFmpeg 빌드 플래그 출력(라이브러리 함수 아님 → 앞 두 글자 대문자 규칙 적용)
// runApp() 이후, 같은 엔진에서 첫 프레임 렌더 뒤 호출할 것
// ─────────────────────────────────────────────────────────────────────────────
Future<void> GEPrintFfmpegBuildFlags() async {
  if (kIsWeb) return; // 웹 가드
  if (!(Platform.isAndroid || Platform.isIOS)) return; // 데스크톱 가드

  try {
    await FFmpegKitConfig.init(); // 플러그인 초기화 보장

    final session = await FFmpegKit.execute('-version'); // 또는 '--version'
    final out = await session.getOutput() ?? '';

    final line = out.split('\n').firstWhere(
          (l) => l.toLowerCase().contains('configuration:'),
      orElse: () => 'no configuration line found',
    );

    // ignore: avoid_print
    print('-----------------------------------------------------------------');
    // ignore: avoid_print
    print(line);
    // ignore: avoid_print
    print('-----------------------------------------------------------------');
  } catch (e, st) {
    // ignore: avoid_print
    print('[FFmpegKit] failed to read build flags: $e');
    // ignore: avoid_print
    print(st);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LGPL 체크리스트 1번 자동 판정 헬퍼
//  - FAIL 조건: --enable-gpl 또는 --enable-nonfree 발견
//  - 참고 경고: libx264/libx265/libxvid/libvidstab/libfdk_aac 감지 시 표시
// ─────────────────────────────────────────────────────────────────────────────
Future<void> GEVerifyLgplItem1() async {
  if (kIsWeb) return;
  if (!(Platform.isAndroid || Platform.isIOS)) return;

  try {
    await FFmpegKitConfig.init();

    final session = await FFmpegKit.execute('-version');
    final out = await session.getOutput() ?? '';
    final cfgLine = out
        .split('\n')
        .firstWhere((l) => l.toLowerCase().contains('configuration:'),
        orElse: () => '');

    final hasEnableGpl = cfgLine.contains('--enable-gpl');
    final hasEnableNonfree = cfgLine.contains('--enable-nonfree');

    // 흔한 위험 외부 라이브러리(문서화용 경고)
    final suspects = <String>[
      '--enable-libx264',
      '--enable-libx265',
      '--enable-libxvid',
      '--enable-libvidstab',
      '--enable-libfdk_aac',
    ].where((t) => cfgLine.contains(t)).toList();

    final pass = !(hasEnableGpl || hasEnableNonfree);

    // 결과 출력
    // ignore: avoid_print
    print('===== FFmpeg LGPL #1 검사 결과 =====');
    // ignore: avoid_print
    print('configuration: ${cfgLine.isEmpty ? '(없음)' : cfgLine}');
    // ignore: avoid_print
    print(
        'FAIL 플래그 감지: --enable-gpl=$hasEnableGpl, --enable-nonfree=$hasEnableNonfree');
    // ignore: avoid_print
    print('의심 외부 라이브러리: ${suspects.isEmpty ? '없음' : suspects.join(', ')}');
    // ignore: avoid_print
    print('최종 판정(1번): ${pass ? 'PASS' : 'FAIL'}');
    // ignore: avoid_print
    print('===================================');
  } catch (e, st) {
    // ignore: avoid_print
    print('[LGPL-Check] 예외: $e');
    // ignore: avoid_print
    print(st);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LGPL 체크리스트 2번(동적 링크) 자동 판정 헬퍼(안드로이드 전용)
//  - /proc/self/maps 를 읽어 현재 프로세스에 로드된 .so 중 FFmpeg 관련 항목이
//    존재하는지 확인한다. 존재하면 공유 라이브러리(동적 링크) 사용이 실증됨.
// ─────────────────────────────────────────────────────────────────────────────
Future<void> GEVerifyLgplItem2() async {
  if (!Platform.isAndroid) return; // /proc/self/maps 확인은 Android에서만 수행

  try {
    // /proc/self/maps 에는 현재 프로세스에 매핑된 파일(so 포함)이 나열된다.
    final maps = await File('/proc/self/maps').readAsString();

    final hits = maps
        .split('\n')
        .where((l) =>
    l.contains('.so') &&
        (l.contains('libav') ||
            l.contains('ffmpeg') ||
            l.contains('ffmpeg-kit')))
        .toList();

    // 결과 출력
    // ignore: avoid_print
    print('===== FFmpeg LGPL #2 검사 결과 =====');
    // ignore: avoid_print
    print('로드된 공유 라이브러리(발췌):');
    for (final l in hits.take(20)) {
      // ignore: avoid_print
      print(l);
    }
    // ignore: avoid_print
    print('총 매칭: ${hits.length}개');
    // ignore: avoid_print
    print('판정(2번): ${hits.isNotEmpty ? 'PASS(공유 라이브러리 로드 확인)' : '확인 필요(런타임 매핑 없음)'}');
    // ignore: avoid_print
    print('===================================');
  } catch (e, st) {
    // ignore: avoid_print
    print('[LGPL-Check2] 예외: $e');
    // ignore: avoid_print
    print(st);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 상태바/내비바 숨김
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // 광고 SDK 초기화
  await MobileAds.instance.initialize();

  // 지역/태그 전역 설정
  await PRivacy.instance.INit();

  if (Platform.isAndroid) {
    await ADOrchestrator.instance.INit();
  }

  final bool isWeb = kIsWeb;
  runApp(MYapp(isWeb));

  // FFmpegKit 호출은 runApp 이후, 같은 엔진에서 첫 프레임 뒤에만
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await GEPrintFfmpegBuildFlags(); // 1번 점검용 출력
    await GEVerifyLgplItem1(); // 1번 자동 판정
    await GEVerifyLgplItem2(); // 2번 자동 판정(공유 라이브러리 로드)
  });
}

class MYapp extends StatefulWidget {
  final bool classification; // true: web, false: app
  const MYapp(this.classification, {super.key});

  @override
  State<MYapp> createState() => _MAinAppState();
}

class _MAinAppState extends State<MYapp> {
  // ─────────────────────────────────────────────────────────────────────────
  // 오픈소스 안내 다이얼로그: WHERE-TO-GET-SOURCE.txt 를 읽어 표시
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _showOpenSourceDialog(BuildContext context) async {
    try {
      final txt = await rootBundle
          .loadString('open-source/ffmpeg/WHERE-TO-GET-SOURCE.txt');

      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => AlertDialog(
          title: const Text('Guide to providing open source'),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 420, maxWidth: 520),
            child: SingleChildScrollView(
              child: SelectableText(
                txt,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('error'),
          content: Text('Failed to read file\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('ok'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Flutter 현지화: 각 MaterialApp 마다 등록해야 동작
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
        Locale('pt', 'BR'),
        Locale('ja'),
        Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        Locale('hi'),
        Locale('id'),
        Locale('tr'),
        Locale('vi'),
        Locale('th'),
      ],

      home: Builder(
        builder: (innerCtx) {
          return PopScope<Object?>(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              final allow = await SHowExitConfirmDialog(innerCtx);
              if (allow && innerCtx.mounted) {
                SystemNavigator.pop();
              }
            },
            child: widget.classification
                ? const Scaffold(backgroundColor: Colors.black) // 웹 임시
                : Scaffold(
              body: Stack(
                children: [
                  // 기존 본문
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                        AssetImage('assets/backgroundimage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        Banner320x50_top(),
                        Expanded(
                          child: Center(child: BUttonChoice()),
                        ),
                        Banner320x50_bottom(),
                      ],
                    ),
                  ),

                  // 화면 상단 오른쪽 버튼
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _showOpenSourceDialog(innerCtx),
                          icon: const Icon(Icons.info_outline),
                          label: const Text('Open Source Guide'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 종료 확인 다이얼로그
Future<bool> SHowExitConfirmDialog(BuildContext context) async {
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
  bool _canExit = false;
  Timer? _gateFallbackTimer;

  @override
  void initState() {
    super.initState();
    _LOadBanner();

    // 광고 느리거나 실패 시 출구 봉쇄 방지
    _gateFallbackTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      if (!_canExit) setState(() => _canExit = true);
    });
  }

  @override
  void dispose() {
    _gateFallbackTimer?.cancel();
    _gateFallbackTimer = null;
    _ad?.dispose();
    super.dispose();
  }

  void _LOadBanner() {
    final adUnitId = _GetDemoMrecAdUnitId(); // 테스트용. 배포 전에 교체
    if (adUnitId.isEmpty) return;

    _ad = BannerAd(
      size: AdSize.mediumRectangle, // 300x250
      adUnitId: adUnitId,
      request: PRivacy.instance.ADRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() => _loaded = true);
        },
        onAdImpression: (ad) {
          if (!mounted) return;
          setState(() => _canExit = true);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _loaded = false;
            _canExit = true;
          });
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                t.exitDialogTitle,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.adLabel,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: Colors.black54),
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
                      child: Text(t.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                      _canExit ? () => Navigator.of(context).pop(true) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                      ),
                      child: Text(
                        _canExit ? t.exit : t.adLoading,
                        style: const TextStyle(
                          color: Color.fromRGBO(252, 238, 255, 1),
                        ),
                      ),
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
      width: 300,
      height: 250,
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

String _GetDemoMrecAdUnitId() {
  if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111'; // Android 테스트 배너
  } else if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/2934735716'; // iOS 테스트 배너
  }
  return '';
}
