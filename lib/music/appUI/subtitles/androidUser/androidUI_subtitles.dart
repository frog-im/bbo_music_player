// lib/.../androidLyricsOverlayApp.dart (예시 파일명)

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../iphoneUser/subtitles_ios.dart'; // ✅ 추가

// 안내 문구를 첫 페이지로 넣기 위한 상수
const String _kHintText = '* 두 번 터치하면 오버레이가 종료됩니다.';
const String _kHintBottomText = "* 페이지를 슬라이드해서 넘깁니다.";

class AndroidLyricsOverlayApp extends StatefulWidget {
  const AndroidLyricsOverlayApp({super.key});

  @override
  State<AndroidLyricsOverlayApp> createState() => _AndroidLyricsOverlayAppState();
}

class _AndroidLyricsOverlayAppState extends State<AndroidLyricsOverlayApp> {
  final PageController _pc = PageController();

  List<LIstPage> _pages = const [];

  // ▼ 닫기 가드 (중복 닫기 방지)
  bool _closingGuard = false;

  // ▼ overlay 이벤트 구독 핸들
  StreamSubscription<dynamic>? _ovlSub;

  // ✅ 저장된 폰트 사이즈
  double _fontSize = 22.0;

  @override
  void initState() {
    super.initState();

    // 첫 프레임 직후 가드 리셋
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _closingGuard = false;
    });

    // ✅ 진입 시 폰트 로드
    LOadFontPrefs();

    // 오버레이 이벤트로 가사 수신 + "활성화 신호"로 가드 리셋
    _ovlSub = FlutterOverlayWindow.overlayListener.listen((event) {
      // overlay 재오픈 시점마다 닫기 가드 해제
      _closingGuard = false;

      // ✅ 이벤트 수신 때마다 최신 폰트 재로드(사용자가 방금 저장했을 수 있으니)
      LOadFontPrefs();

      final text = (event ?? '').toString();
      final normalized = _NOrmalizeNewlines(text);
      final lyricPages = SPaginateLyrics(normalized);

      // 첫 페이지에 안내 문구 삽입
      final combined = <LIstPage>[
        const LIstPage(top: _kHintText, bottom: _kHintBottomText),
        ...lyricPages,
      ];

      if (!mounted) return;
      setState(() => _pages = combined);
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

  // ✅ 저장된 폰트 사이즈 로드
  Future<void> LOadFontPrefs() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final f = sp.getDouble('overlay_text_font'); // 편집기와 동일 키
      if (!mounted) return;
      setState(() {
        // 합리적인 가드 범위
        final v = (f ?? 22.0);
        _fontSize = v.clamp(8.0, 96.0).toDouble();
      });
    } catch (_) {
      // 실패 시 기본값 유지
    }
  }

  // ▼ 더블 탭 → 그냥 닫기
  void _onDoubleTapClose() {
    _closeOverlaySafely();
  }

  // ▼ 중복 호출/레이스 컨디션 방지용 안전 닫기(+실패 시 가드 복구)
  Future<void> _closeOverlaySafely() async {
    if (_closingGuard) return;
    _closingGuard = true;
    try {
      final result = await FlutterOverlayWindow.closeOverlay();
      if (result != true) {
        _closingGuard = false;
      }
    } catch (_) {
      _closingGuard = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (ctx) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: GestureDetector(
                onDoubleTap: _onDoubleTapClose,
                child: Card(
                  color: const Color.fromRGBO(0, 0, 0, .5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.antiAlias,
                 // child: Padding(
                    //padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: _pages.isEmpty
                        ? const _EmptyContent()
                        : PageView.builder(
                      controller: _pc,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        final p = _pages[index];
                        return BUildTwoLineCard(
                          top: p.top,
                          bottom: p.bottom,
                          fontSize: _fontSize, // ✅ 적용
                        );
                      },
                    ),
                  ),
                ),
              ),
           // ),
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

/// 빈 컨텐츠 안내
class _EmptyContent extends StatelessWidget {
  const _EmptyContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '가사를 받지 못했습니다.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }
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
