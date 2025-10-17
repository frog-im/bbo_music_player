import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// ② 오버레이 전용 네비게이터 키
final GlobalKey<NavigatorState> overlayNavigatorKey = GlobalKey<NavigatorState>();

class AndroidLyricsOverlayApp extends StatefulWidget {
  const AndroidLyricsOverlayApp({super.key});

  @override
  State<AndroidLyricsOverlayApp> createState() => _AndroidLyricsOverlayAppState();
}

class _AndroidLyricsOverlayAppState extends State<AndroidLyricsOverlayApp> {
  // 배너/다이얼로그 안내용
  final GlobalKey<ScaffoldMessengerState> _messengerKey = GlobalKey<ScaffoldMessengerState>();

  bool _hintShown = false; // 힌트 1회만
  final PageController _pc = PageController();

  List<LIstPage> _pages = const [];

  @override
  void initState() {
    super.initState();
    FlutterOverlayWindow.overlayListener.listen((event) {
      final text = (event ?? '').toString();
      final normalized = _NOrmalizeNewlines(text);
      final pages = SPaginateLyrics(normalized);

      setState(() => _pages = pages);
      if (_pc.hasClients) _pc.jumpToPage(0);
    });
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: overlayNavigatorKey,             // ② 적용
      scaffoldMessengerKey: _messengerKey,
      home: Builder(
        builder: (ctx) {
          // 첫 프레임 이후 1회만 작은 다이얼로그 표시
          if (!_hintShown) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!mounted || _hintShown) return;
              _hintShown = true;

              await SHowMiniDialog(
                message: '두 번 터치하면 오버레이가 종료됩니다.',
                duration: const Duration(milliseconds: 1600),
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 12),
              );
            });
          }

          final size = MediaQuery.of(ctx).size;
          final w = size.width * 0.6;
          final h = size.height * 0.12; // 2줄 가사용

          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: GestureDetector(
                onDoubleTap: FlutterOverlayWindow.closeOverlay,
                child: Card(
                  color: const Color.fromRGBO(0, 0, 0, .5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: w,
                    height: h,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: _pages.isEmpty
                          ? const _EmptyContent()
                          : PageView.builder(
                        controller: _pc,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _pages.length,
                        itemBuilder: (context, index) {
                          final p = _pages[index];
                          return BUildTwoLineCard(top: p.top, bottom: p.bottom);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// ------ 작은 다이얼로그(토스트 느낌) 헬퍼 ------
/// navigatorKey의 컨텍스트로 showGeneralDialog 호출
Future<void> SHowMiniDialog({
  required String message,
  Duration duration = const Duration(milliseconds: 1500),
  Alignment alignment = Alignment.topCenter,
  EdgeInsets margin = const EdgeInsets.all(12),
}) async {
  final ctx = overlayNavigatorKey.currentState?.overlay?.context
      ?? overlayNavigatorKey.currentContext;
  if (ctx == null) return; // 아직 프레임 미완성 등

  final future = showGeneralDialog<void>(
    context: ctx,
    barrierLabel: 'mini',                // barrierDismissible=true면 라벨 필수
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 160),
    useRootNavigator: true,
    pageBuilder: (_, __, ___) {
      return SafeArea(
        child: Align(
          alignment: alignment,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: margin,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info, size: 18, color: Colors.white70),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  await Future.any([future, Future.delayed(duration)]);
  final nav = Navigator.of(ctx, rootNavigator: true);
  if (nav.canPop()) nav.maybePop();
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

/// 두 줄 표시 카드
Widget BUildTwoLineCard({required String top, required String bottom}) {
  const base = TextStyle(
    color: Colors.white,
    fontSize: 22,
    height: 1.22,
    fontWeight: FontWeight.w800,
  );
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(top, maxLines: 1, overflow: TextOverflow.ellipsis, style: base),
      const SizedBox(height: 6),
      Text(bottom, maxLines: 1, overflow: TextOverflow.ellipsis, style: base),
    ],
  );
}
