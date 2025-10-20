// lib/music/appUI/subtitles/ios_user/subtitles_ios.dart
// iOS 대체 구현: 내부 WebView + 상단 주소창(고정) + 하단 가사 오버레이(두 줄 PageView)
// 광고 제거 버전 + 박스 크기(가로 75%, 세로 10%)를 FlutterView.physicalSize 기반으로 계산
// y 위치 = 저장된 y + 박스 높이의 절반(h/2)

import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../read_music_metadata.dart' as meta;
import '../lyrics_overlay.dart';

class IOsLyricsOverlay implements LYricsOverlay {
  @override
  Future<String> SHow({required String filePath, BuildContext? context}) async {
    final ctx = context;
    if (ctx == null) return '';

    // 1) 가사 로드
    final lyrics = await REsolveLyrics(filePath);
    final normalized = (lyrics ?? '').trim();

    // 2) 내부 화면 push: WebView + 주소창 + 가사 오버레이
    await Navigator.of(ctx).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => IOSWebViewLyricsScreen(
          initialUrl: 'about:blank',
          lyricsText: normalized,
        ),
      ),
    );
    return normalized;
  }

  String _NOrmalizeNewlines(String s) =>
      s.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

  Future<String?> REsolveLyrics(String filePath) async {
    try {
      final tags = await meta.readAudioTags(filePath, extractArtwork: false);
      final fromMeta = tags['lyrics']?.trim();
      if (fromMeta != null && fromMeta.isNotEmpty) {
        return _NOrmalizeNewlines(fromMeta);
      }

      final f = File(filePath);
      final dir = f.parent;
      final base = f.uri.pathSegments.isEmpty ? '' : f.uri.pathSegments.last;
      final dot = base.lastIndexOf('.');
      final stem = dot > 0 ? base.substring(0, dot) : base;

      for (final ext in const ['lrc', 'txt']) {
        final cand = File('${dir.path}${Platform.pathSeparator}$stem.$ext');
        if (await cand.exists()) {
          final s = await cand.readAsString();
          final t = s.trim();
          if (t.isNotEmpty) return _NOrmalizeNewlines(t);
        }
      }
    } catch (_) {}
    return null;
  }
}

// ───────────────── 화면: WebView + 상단 주소창(고정) + 가사 오버레이 ─────────────────

class IOSWebViewLyricsScreen extends StatefulWidget {
  final String initialUrl;
  final String lyricsText;

  const IOSWebViewLyricsScreen({
    super.key,
    required this.initialUrl,
    required this.lyricsText,
  });

  @override
  State<IOSWebViewLyricsScreen> createState() => _IOSWebViewLyricsScreenState();
}

class _IOSWebViewLyricsScreenState extends State<IOSWebViewLyricsScreen> {
  late final WebViewController _wc;
  final PageController _pc = PageController();

  late List<LIstPage> _pages;

  // 주소창 상태
  final TextEditingController _addr = TextEditingController();
  final FocusNode _addrFocus = FocusNode();
  bool _canBack = false;
  bool _canFwd = false;
  int _progress = 0;

  // 저장 로드용 상태 (좌표, 폰트)
  static const _kX = 'overlay_box_x';
  static const _kY = 'overlay_box_y';
  static const _kFont = 'overlay_text_font';

  Offset _pos = Offset.zero; // 저장값 없으면 (0,0)
  double _fontSize = 22;     // 기본 폰트

  @override
  void initState() {
    super.initState();

    _wc = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            UPdateUrlField(url);
            REfreshNavState();
          },
          onProgress: (p) => setState(() => _progress = p),
          onPageFinished: (url) async {
            UPdateUrlField(url);
            await REfreshNavState();
            setState(() => _progress = 100);
          },
          onNavigationRequest: (req) => NavigationDecision.navigate,
        ),
      )
      ..loadRequest(Uri.parse(widget.initialUrl));

    final normalized = _NOrmalizeNewlines(widget.lyricsText);
    _pages = SPaginateLyrics(normalized);

    LOadPrefs(); // SP 로드
  }

  @override
  void dispose() {
    _pc.dispose();
    _addr.dispose();
    _addrFocus.dispose();
    super.dispose();
  }

  Future<void> LOadPrefs() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final x = sp.getDouble(_kX) ?? 0.0;
      final y = sp.getDouble(_kY) ?? 0.0;
      final f = sp.getDouble(_kFont);
      if (!mounted) return;
      setState(() {
        _pos = Offset(x, y);
        if (f != null) _fontSize = f;
      });
    } catch (_) {}
  }

  Future<void> LOadFromAddressBar([String? text]) async {
    final raw = (text ?? _addr.text).trim();
    if (raw.isEmpty) return;
    final url = _NOrmalizeUrl(raw);
    await _wc.loadRequest(Uri.parse(url));
    _addrFocus.unfocus();
  }

  Future<void> UPdateUrlField([String? url]) async {
    String? u = url;
    u ??= await _wc.currentUrl();
    if (!mounted) return;
    setState(() {
      _addr.text = u ?? '';
      _addr.selection =
          TextSelection.fromPosition(TextPosition(offset: _addr.text.length));
    });
  }

  Future<void> REfreshNavState() async {
    final b = await _wc.canGoBack();
    final f = await _wc.canGoForward();
    if (!mounted) return;
    setState(() {
      _canBack = b;
      _canFwd = f;
    });
  }

  String _NOrmalizeUrl(String input) {
    final hasScheme =
    RegExp(r'^[a-zA-Z][a-zA-Z0-9+\-.]*://').hasMatch(input);
    if (hasScheme) return input;
    return 'https://$input';
  }

  Offset CLampOffset({
    required Offset pos,
    required Size areaSize,
    required Size boxSize,
  }) {
    final double maxX =
    (areaSize.width - boxSize.width).clamp(0.0, double.infinity).toDouble();
    final double maxY =
    (areaSize.height - boxSize.height).clamp(0.0, double.infinity).toDouble();
    final double x = pos.dx.clamp(0.0, maxX).toDouble();
    final double y = pos.dy.clamp(0.0, maxY).toDouble();
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    // FlutterView 기준: 물리 픽셀(px) → DPR로 나눠 논리 픽셀(dp)
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final double widthDp  = (view.physicalSize.width  * 0.75) / view.devicePixelRatio;
    final double heightDp = (view.physicalSize.height * 0.10) / view.devicePixelRatio;

    // 카드 크기 고정: 정확히 75% × 10%
    final double w = widthDp;
    final double h = heightDp;

    return WillPopScope(
      onWillPop: () async {
        if (await _wc.canGoBack()) {
          await _wc.goBack();
          await REfreshNavState();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              // 상단 주소창
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: _BuildAddressBar(
                  canBack: _canBack,
                  canFwd: _canFwd,
                  progress: _progress,
                  addrController: _addr,
                  addrFocus: _addrFocus,
                  onBack: () async {
                    if (await _wc.canGoBack()) {
                      await _wc.goBack();
                      await REfreshNavState();
                    } else {
                      Navigator.of(context).maybePop();
                    }
                  },
                  onForward: () async {
                    if (await _wc.canGoForward()) {
                      await _wc.goForward();
                      await REfreshNavState();
                    }
                  },
                  onReload: () async => _wc.reload(),
                  onGo: (value) => LOadFromAddressBar(value),
                  onClose: () => Navigator.of(context).maybePop(),
                ),
              ),

              // WebView + 오버레이
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final areaSize = constraints.biggest;
                    final cardSize = Size(w, h);

                    // ★ 변경 핵심: y에 박스 높이의 절반(h/2)을 더해서 사용
                    final savedWithHalfH = Offset(_pos.dx, _pos.dy/* + h */);
                    final posToUse = CLampOffset(
                      pos: savedWithHalfH,
                      areaSize: areaSize,
                      boxSize: cardSize,
                    );

                    return Stack(
                      children: [
                        // 1) WebView
                        const Positioned.fill(child: _WebViewFiller()),

                        // 2) 가사 오버레이 카드 (저장된 y + h/2 적용)
                        Positioned(
                          left: posToUse.dx,
                          top: posToUse.dy,
                          width: w,
                          height: h,
                          child: Center(
                            child: Card(
                              color: const Color.fromRGBO(0, 0, 0, .55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8,
                                ),
                                child: _pages.isEmpty
                                    ? const _EmptyContent()
                                    : PageView.builder(
                                  controller: _pc,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _pages.length,
                                  itemBuilder: (_, i) {
                                    final p = _pages[i];
                                    return FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: BUildTwoLineCard(
                                        top: p.top,
                                        bottom: p.bottom,
                                        fontSize: _fontSize,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// WebView를 Expanded/Stack 안에서 채우는 래퍼
class _WebViewFiller extends StatelessWidget {
  const _WebViewFiller();

  @override
  Widget build(BuildContext context) {
    final state =
    context.findAncestorStateOfType<_IOSWebViewLyricsScreenState>();
    return state == null
        ? const SizedBox.shrink()
        : WebViewWidget(controller: state._wc);
  }
}

// ───────────── 상단 주소창 위젯 ─────────────

class _BuildAddressBar extends StatelessWidget {
  final bool canBack, canFwd;
  final int progress;
  final TextEditingController addrController;
  final FocusNode addrFocus;
  final Future<void> Function() onReload;
  final Future<void> Function()? onForward;
  final Future<void> Function()? onBack;
  final void Function(String value) onGo;
  final VoidCallback onClose;

  const _BuildAddressBar({
    required this.canBack,
    required this.canFwd,
    required this.progress,
    required this.addrController,
    required this.addrFocus,
    required this.onReload,
    required this.onForward,
    required this.onBack,
    required this.onGo,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.65),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: Icon(Icons.arrow_back_ios_new,
                        size: 18,
                        color: canBack ? Colors.white : Colors.white38),
                    tooltip: '뒤로',
                  ),
                  IconButton(
                    onPressed: onForward,
                    icon: Icon(Icons.arrow_forward_ios,
                        size: 18,
                        color: canFwd ? Colors.white : Colors.white38),
                    tooltip: '앞으로',
                  ),
                  IconButton(
                    onPressed: onReload,
                    icon: const Icon(Icons.refresh,
                        size: 18, color: Colors.white),
                    tooltip: '새로고침',
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 255, 255, .12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: addrController,
                        focusNode: addrFocus,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.go,
                        autocorrect: false,
                        enableSuggestions: false,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white70,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '주소 입력 또는 붙여넣기',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                        onSubmitted: onGo,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close,
                        size: 18, color: Colors.white70),
                    tooltip: '닫기',
                  ),
                ],
              ),
              if (progress > 0 && progress < 100)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 4, right: 4),
                  child: LinearProgressIndicator(
                    value: progress / 100.0,
                    color: Colors.white,
                    backgroundColor: Colors.white12,
                    minHeight: 2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────── 가사 페이징/표시 유틸 ─────────────

class LIstPage {
  final String top;
  final String bottom;
  const LIstPage({required this.top, required this.bottom});
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent();
  @override
  Widget build(BuildContext context) {
    return const Text(
      '가사를 받지 못했습니다.',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.white70, fontSize: 12),
    );
  }
}

String _NOrmalizeNewlines(String s) =>
    s.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

List<LIstPage> SPaginateLyrics(String s) {
  if (s.isEmpty) return const [];
  final lines = s
      .split('\n')
      .map((e) => e.trim())
      .where((t) => t.isNotEmpty)
      .toList();
  if (lines.isEmpty) return const [];
  final out = <LIstPage>[];
  for (int i = 0; i < lines.length; i += 2) {
    out.add(LIstPage(
      top: lines[i],
      bottom: i + 1 < lines.length ? lines[i + 1] : '',
    ));
  }
  return out;
}

Widget BUildTwoLineCard({
  required String top,
  required String bottom,
  double fontSize = 22,
}) {
  final base = TextStyle(
    color: Colors.white,
    fontSize: fontSize,
    height: 1.22,
    fontWeight: FontWeight.w800,
  );
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(top, maxLines: 1, overflow: TextOverflow.ellipsis, style: base),
      const SizedBox(height: 6),
      Text(bottom, maxLines: 1, overflow: TextOverflow.ellipsis, style: base),
    ],
  );
}
