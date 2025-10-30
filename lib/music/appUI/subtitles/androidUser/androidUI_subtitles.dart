// lib/music/appUI/subtitles/androidUser/androidUI_subtitles.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shared_preferences/shared_preferences.dart';

// l10n
import 'package:bbo_music_player/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AndroidLyricsOverlayApp extends StatefulWidget {
  const AndroidLyricsOverlayApp({super.key});

  @override
  State<AndroidLyricsOverlayApp> createState() => _AndroidLyricsOverlayAppState();
}

class _AndroidLyricsOverlayAppState extends State<AndroidLyricsOverlayApp> {
  final PageController _pc = PageController();
  List<LIstPage> _pages = const [];
  bool _closingGuard = false;
  StreamSubscription<dynamic>? _ovlSub;

  double _fontSize = 22.0;
  late Future<void> _boot; // ★ 초기 로드 완료 대기용

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _closingGuard = false;
    });

    _boot = LOadFontPrefs(); // ★ 최초 1회 로드 Future 저장

    _ovlSub = FlutterOverlayWindow.overlayListener.listen((event) {
      _closingGuard = false;
      LOadFontPrefs(); // ★ 이벤트마다 최신값 재로드

      final text = (event ?? '').toString();
      final normalized = _NOrmalizeNewlines(text);
      final lyricPages = SPaginateLyrics(normalized);

      if (!mounted) return;
      setState(() => _pages = lyricPages);
      if (_pc.hasClients) _pc.jumpToPage(0);
    });
  }

  @override
  void dispose() {
    _pc.dispose();
    _ovlSub?.cancel();
    _ovlSub = null;
    super.dispose();
  }

  // 저장된 폰트 사이즈 로드(캐시 무효화 포함)
  Future<void> LOadFontPrefs() async {
    try {
      final sp = await SharedPreferences.getInstance();
      await sp.reload(); // ★ 중요: 최신 디스크 값으로 재로딩
      final f = sp.getDouble('overlay_text_font'); // 편집기와 동일 키
      if (!mounted) return;
      setState(() {
        final v = (f ?? 22.0);
        _fontSize = v.clamp(8.0, 96.0).toDouble();
      });
    } catch (_) {
      // 실패 시 기본값 유지
    }
  }

  // 더블 탭 → 닫기
  void _onDoubleTapClose() {
    _closeOverlaySafely();
  }

  // 안전 닫기
  Future<void> _closeOverlaySafely() async {
    if (_closingGuard) return;
    _closingGuard = true;
    try {
      final ok = await FlutterOverlayWindow.closeOverlay();
      if (ok != true) _closingGuard = false;
    } catch (_) {
      _closingGuard = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 필요 시 테스트로 영어 고정
      // locale: const Locale('en'),

      // 오버레이 전용 트리에도 지역화 등록 필요
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],

      home: Builder(
        builder: (innerCtx) {
          final t = AppLocalizations.of(innerCtx)!;

          return FutureBuilder<void>(
            future: _boot, // ★ 초기 로드가 끝난 뒤 그리기
            builder: (_, __) {
              final pages = <LIstPage>[
                LIstPage(top: t.overlayHintDoubleTap, bottom: t.overlayHintSwipe),
                ..._pages,
              ];

              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: GestureDetector(
                    onDoubleTap: _onDoubleTapClose,
                    child: Card(
                      color: const Color.fromRGBO(0, 0, 0, .5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      clipBehavior: Clip.antiAlias,
                      child: pages.isEmpty
                          ? Center(
                        child: Text(
                          t.emptyLyrics,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      )
                          : PageView.builder(
                        controller: _pc,
                        physics: const BouncingScrollPhysics(),
                        itemCount: pages.length,
                        itemBuilder: (ctx, index) {
                          final p = pages[index];
                          return BUildTwoLineCard(
                            top: p.top,
                            bottom: p.bottom,
                            fontSize: _fontSize, // ★ 저장값 사용
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// 두 줄 페이지 모델
class LIstPage {
  final String top;
  final String bottom;
  const LIstPage({required this.top, required this.bottom});
}

/// 개행/공백 정리
String _NOrmalizeNewlines(String s) =>
    s.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

/// 가사 2줄 페이징
List<LIstPage> SPaginateLyrics(String s) {
  if (s.isEmpty) return const [];
  final lines = s.split('\n').map((e) => e.trim()).where((t) => t.isNotEmpty).toList();
  if (lines.isEmpty) return const [];

  final pages = <LIstPage>[];
  for (int i = 0; i < lines.length; i += 2) {
    final top = lines[i];
    final bottom = i + 1 < lines.length ? lines[i + 1] : '';
    pages.add(LIstPage(top: top, bottom: bottom));
  }
  return pages;
}

/// 두 줄 카드
Widget BUildTwoLineCard({
  required String top,
  required String bottom,
  double fontSize = 14, // 기본값도 22로 통일
}) {
  final base = TextStyle(
    color: Colors.white,
    fontSize: fontSize,
    height: 1.22,
    fontWeight: FontWeight.w800,
  );
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(top, maxLines: 1, overflow: TextOverflow.ellipsis, style: base),
        const SizedBox(height: 6),
        Text(bottom, maxLines: 1, overflow: TextOverflow.ellipsis, style: base),
      ],
    ),
  );
}