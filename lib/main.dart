// lib/main.dart
import 'dart:async';
import 'dart:io' show Platform, File;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 외부 URL 오픈
import 'package:url_launcher/url_launcher.dart';

// AdMob
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

// 프라이버시 헬퍼(UMP)
import 'privacy/privacy_gate.dart';

bool Overlaylock = false;

// ─────────────────────────────────────────────────────────────
// 정책 URL 루트 & 폴더 매핑 유틸 (Locale→폴더)
// ─────────────────────────────────────────────────────────────
const String kPolicyRoot = 'https://frog-im.github.io/privacy/bbo-music-player';
const Set<String> _kPolicySupportedFolders = {
  'en','ko','es','fr','de','it','pt-br','ja','zh-hant','hi','id','tr','vi','th',
};

String _policyFolderFromLocale(Locale locale) {
  final lang = locale.languageCode.toLowerCase();
  final script = locale.scriptCode?.toLowerCase();
  final country = locale.countryCode?.toLowerCase();

  final candidates = <String>[
    if (script != null && script.isNotEmpty) '$lang-$script',
    if (country != null && country.isNotEmpty) '$lang-$country',
    lang,
  ];

  for (final c in candidates) {
    if (_kPolicySupportedFolders.contains(c)) return c;
  }
  return 'en'; // 안전 폴백
}

String GEPrivacyPolicyUrl(BuildContext context) {
  final folder = _policyFolderFromLocale(Localizations.localeOf(context));
  return '$kPolicyRoot/$folder/';
}

String GECrossBorderPolicyUrl(BuildContext context) {
  final folder = _policyFolderFromLocale(Localizations.localeOf(context));
  return '$kPolicyRoot/$folder/policy/';
}

// 상단 배너 높이(AdSize.banner = 320x50)
const double _kTopBannerHeight = 50.0;

// ─────────────────────────────────────────────────────────────────────────────
// 오버레이 엔트리포인트(별도 FlutterEngine)
// ─────────────────────────────────────────────────────────────────────────────
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AndroidLyricsOverlayApp());
}

// ─────────────────────────────────────────────────────────────────────────────
// FFmpeg 빌드 플래그 출력 (디버그 우선)
// ─────────────────────────────────────────────────────────────────────────────
Future<void> GEPrintFfmpegBuildFlags() async {
  if (kIsWeb) return;
  if (!(Platform.isAndroid || Platform.isIOS)) return;
  if (kReleaseMode) return; // 릴리스에서는 과도한 로그 억제

  try {
    await FFmpegKitConfig.init();
    final session = await FFmpegKit.execute('-version');
    final out = await session.getOutput() ?? '';
    final line = out.split('\n').firstWhere(
          (l) => l.toLowerCase().contains('configuration:'),
      orElse: () => 'no configuration line found',
    );
    // ignore: avoid_print
    print('-----------------------------------------------------------------');
    print(line);
    print('-----------------------------------------------------------------');
  } catch (e, st) {
    if (!kReleaseMode) {
      print('[FFmpegKit] failed to read build flags: $e');
      print(st);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// LGPL 점검 (디버그 위주)
// ─────────────────────────────────────────────────────────────────────────────
Future<void> GEVerifyLgplItem1() async {
  if (kIsWeb) return;
  if (!(Platform.isAndroid || Platform.isIOS)) return;
  if (kReleaseMode) return;

  try {
    await FFmpegKitConfig.init();
    final session = await FFmpegKit.execute('-version');
    final out = await session.getOutput() ?? '';
    final cfgLine = out
        .split('\n')
        .firstWhere((l) => l.toLowerCase().contains('configuration:'), orElse: () => '');

    final hasEnableGpl = cfgLine.contains('--enable-gpl');
    final hasEnableNonfree = cfgLine.contains('--enable-nonfree');

    final suspects = <String>[
      '--enable-libx264',
      '--enable-libx265',
      '--enable-libxvid',
      '--enable-libvidstab',
      '--enable-libfdk_aac',
    ].where((t) => cfgLine.contains(t)).toList();

    final pass = !(hasEnableGpl || hasEnableNonfree);

    print('===== FFmpeg LGPL #1 검사 결과 =====');
    print('configuration: ${cfgLine.isEmpty ? '(없음)' : cfgLine}');
    print('FAIL 플래그 감지: --enable-gpl=$hasEnableGpl, --enable-nonfree=$hasEnableNonfree');
    print('의심 외부 라이브러리: ${suspects.isEmpty ? '없음' : suspects.join(', ')}');
    print('최종 판정(1번): ${pass ? 'PASS' : 'FAIL'}');
    print('===================================');
  } catch (e, st) {
    print('[LGPL-Check] 예외: $e');
    print(st);
  }
}

Future<void> GEVerifyLgplItem2() async {
  if (!Platform.isAndroid) return;
  if (kReleaseMode) return;

  try {
    final maps = await File('/proc/self/maps').readAsString();
    final hits = maps
        .split('\n')
        .where((l) =>
    l.contains('.so') &&
        (l.contains('libav') || l.contains('ffmpeg') || l.contains('ffmpeg-kit')))
        .toList();

    print('===== FFmpeg LGPL #2 검사 결과 =====');
    print('총 매칭: ${hits.length}개 (발췌 최대 20줄)');
    for (final l in hits.take(20)) {
      print(l);
    }
    print('판정(2번): ${hits.isNotEmpty ? 'PASS(공유 라이브러리 로드 확인)' : '확인 필요'}');
    print('===================================');
  } catch (e, st) {
    print('[LGPL-Check2] 예외: $e');
    print(st);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 외부 URL 오픈 (로컬라이즈 메시지 사용)
// ─────────────────────────────────────────────────────────────────────────────
Future<void> LAunchExternalUrl(BuildContext context, String url) async {
  final t = AppLocalizations.of(context)!;
  try {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.openUrlFailed)),
      );
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.openUrlFailed)),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 국외 이전 안내 팝업(인앱 요약 텍스트 + 전체 정책 링크 버튼)
// ─────────────────────────────────────────────────────────────────────────────
Future<void> SHowCrossBorderNoticeDialog(BuildContext context) async {
  final t = AppLocalizations.of(context)!;
  await showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      title: Text(t.crossBorderTitle),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 420),
        child: SingleChildScrollView(
          child: SelectableText(
            t.crossBorderFullText,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => LAunchExternalUrl(ctx, GECrossBorderPolicyUrl(ctx)),
          child: Text(t.viewFullPolicy),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(t.btnClose),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 단일 "설정" 버튼 → 하단 액션 시트
// ─────────────────────────────────────────────────────────────────────────────
Future<void> SHowActionSheet(BuildContext context, {required bool privacyEntryRequired}) async {
  final t = AppLocalizations.of(context)!;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: false,
    showDragHandle: true,
    builder: (ctx) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.tune),
              title: Text(privacyEntryRequired ? t.privacyOptionsRequiredLabel : t.privacyOptionsNotRequiredLabel),
              onTap: () async {
                Navigator.of(ctx).pop();
                await PRivacy.instance.SHowPrivacyOptionsForm();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(t.privacyOptionsUpdated)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(t.menuPrivacyPolicy),
              onTap: () {
                Navigator.of(ctx).pop();
                LAunchExternalUrl(context, GEPrivacyPolicyUrl(context));
              },
            ),
            ListTile(
              leading: const Icon(Icons.public_outlined),
              title: Text(t.crossBorderTitle),
              onTap: () async {
                Navigator.of(ctx).pop();
                await SHowCrossBorderNoticeDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(t.openSource),
              onTap: () async {
                Navigator.of(ctx).pop();
                await _SHowOpenSourceDialog(context);
              },
            ),
            const SizedBox(height: 6),
          ],
        ),
      );
    },
  );
}

// 오픈소스 안내 다이얼로그
Future<void> _SHowOpenSourceDialog(BuildContext context) async {
  final t = AppLocalizations.of(context)!;
  try {
    final txt = await rootBundle.loadString('open-source/ffmpeg/WHERE-TO-GET-SOURCE.txt');
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: Text(t.openSourceGuideTitle),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 420, maxWidth: 520),
          child: SingleChildScrollView(
            child: SelectableText(txt, style: const TextStyle(fontSize: 13)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(t.btnClose)),
        ],
      ),
    );
  } catch (e) {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.errorTitle),
        content: Text(t.readFileFailed('$e')),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(AppLocalizations.of(ctx)!.commonOk)),
        ],
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 상태바/내비바 숨김
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // 1) 지역/태그 전역 설정 + UMP 동기화
  await PRivacy.instance.INit();

  // 2) (선택적) EEA/UK/CH에서 동의 적용/폴백 확정까지 잠깐 대기
  await PRivacy.instance.WAITReadyForAds(
    timeout: const Duration(seconds: 3),
    interval: const Duration(milliseconds: 100),
  );

  // 3) 광고 SDK 초기화 (동의 상태를 반영한 구성 이후)
  await MobileAds.instance.initialize();

  // 4) 전면 광고 오케스트레이터
  if (Platform.isAndroid) {
    await ADOrchestrator.instance.INit();
  }

  // 5) 앱 실행
  final bool isWeb = kIsWeb;
  runApp(MYapp(isWeb));

  // 6) FFmpeg 점검(디버그)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await GEPrintFfmpegBuildFlags();
    await GEVerifyLgplItem1();
    await GEVerifyLgplItem2();
  });
}

class MYapp extends StatefulWidget {
  final bool classification; // true: web, false: app
  const MYapp(this.classification, {super.key});

  @override
  State<MYapp> createState() => _MAinAppState();
}

class _MAinAppState extends State<MYapp> {
  bool _privacyEntryRequired = false;

  @override
  void initState() {
    super.initState();
    _refreshPrivacyEntryFlag();
  }

  Future<void> _refreshPrivacyEntryFlag() async {
    setState(() {
      _privacyEntryRequired = PRivacy.instance.GEtsPrivacyEntryRequired();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 현지화
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
          final t = AppLocalizations.of(innerCtx)!;
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
                  // 본문
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/backgroundimage.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Column(
                      children: [
                        // 배너(320x50)
                        Banner320x50_top(),
                        Expanded(child: Center(child: BUttonChoice())),
                        Banner320x50_bottom(),
                      ],
                    ),
                  ),

                  // 우상단 단일 버튼(광고 가림 방지 위해 배너만큼 아래)
                  Positioned.fill(
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: _kTopBannerHeight + 8,
                            right: 8,
                          ),
                          child: FilledButton.tonalIcon(
                            onPressed: () => SHowActionSheet(innerCtx, privacyEntryRequired: _privacyEntryRequired),
                            icon: const Icon(Icons.settings, size: 18),
                            label: Text(t.commonSettings),
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.compact,
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
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _loaded = false; // 종료 버튼은 광고와 무관하게 항상 활성
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
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.adLabel,
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
                      child: Text(t.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      child: Text(
                        t.exit,
                        style: const TextStyle(color: Color.fromRGBO(252, 238, 255, 1)),
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
    return 'ca-app-pub-3252837628484304/3059791103'/*'ca-app-pub-3940256099942544/6300978111'*/; // Android 테스트 배너
  } else if (Platform.isIOS) {
    return 'ca-app-pub-3252837628484304/6995166685'/*'ca-app-pub-3940256099942544/2934735716'*/; // iOS 테스트 배너
  }
  return '';
}
