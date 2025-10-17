// lib/music/appUI/subtitles/ios_user/subtitles_ios.dart
// iOS 대체 구현: 내부 WebView + 상단 주소창(고정) + 하단 가사 오버레이(두 줄 PageView)

import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
          initialUrl: 'about:blank', // 초기 빈 화면
          lyricsText: normalized,
        ),
      ),
    );
    return normalized;
  }

  // 개행/공백 정리
  String _NOrmalizeNewlines(String s) =>
      s.replaceAll('\r\n', '\n').replaceAll('\r', '\n').trim();

  // 가사 해석기: 메타 태그 → sidecar(.lrc/.txt)
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

// ───────────────── 화면: WebView + 상단 주소창(고정) + 하단 가사 오버레이 ─────────────────

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
      ..loadRequest(Uri.parse(widget.initialUrl)); // 초기 페이지

    final normalized = _NOrmalizeNewlines(widget.lyricsText);
    _pages = SPaginateLyrics(normalized);
  }

  @override
  void dispose() {
    _pc.dispose();
    _addr.dispose();
    _addrFocus.dispose();
    super.dispose();
  }

  // 주소 입력 → 로드
  Future<void> LOadFromAddressBar([String? text]) async {
    final raw = (text ?? _addr.text).trim();
    if (raw.isEmpty) return;
    final url = _NOrmalizeUrl(raw);
    await _wc.loadRequest(Uri.parse(url));
    _addrFocus.unfocus();
  }

  // 현재 URL을 주소창에 반영
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

  // 뒤/앞으로 가능 여부 갱신
  Future<void> REfreshNavState() async {
    final b = await _wc.canGoBack();
    final f = await _wc.canGoForward();
    if (!mounted) return;
    setState(() {
      _canBack = b;
      _canFwd = f;
    });
  }

  // 주소 정규화: 스킴 없으면 https 붙이기
  String _NOrmalizeUrl(String input) {
    final hasScheme =
    RegExp(r'^[a-zA-Z][a-zA-Z0-9+\-.]*://').hasMatch(input);
    if (hasScheme) return input;
    return 'https://$input';
  }

  @override
  Widget build(BuildContext context) {
    // 화면 크기
    final size = MediaQuery.of(context).size;
    final w = size.width * 0.6;

    // 접근성 텍스트 스케일 반영 최소 필요 높이
    const double kFontSize = 22;
    const double kLineHeight = 1.22;
    const double kVPadding = 16; // vertical 8 + 8
    const double kSpacing = 6;
    final double tScale =
        MediaQuery.maybeTextScalerOf(context)?.scale(1) ??
            MediaQuery.textScaleFactorOf(context);
    final double minTextBlockHeight =
        (kFontSize * kLineHeight * tScale) * 2 + kSpacing;
    final double minCardHeight = minTextBlockHeight + kVPadding;
    final double h = math.max(size.height * 0.12, minCardHeight);

    // 브라우저식 뒤로가기: 히스토리 있으면 goBack, 없으면 pop
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
        body: SafeArea( // 노치/상태바 침범 방지
          // ───────── Stack 대신 Column으로 상단 바를 “영역 분리” ─────────
          child: Column(
            children: [
              // 상단 주소창: 좌우 8, 위 8 마진으로 고정 배치
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
                      if (context.mounted) Navigator.of(context).maybePop();
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

              // WebView는 남은 영역을 모두 차지
              Expanded(
                // 하단 가사 카드는 WebView 위에만 겹치도록 Stack
                child: Stack(
                  children: [
                    // 1) WebView (상단 바와 “분리된” 영역)
                    const Positioned.fill(
                      child: _WebViewFiller(),
                    ),

                    // 2) 하단 가사 오버레이 카드
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 24,
                      child: Center(
                        child: Card(
                          color: const Color.fromRGBO(0, 0, 0, .55),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            width: w,
                            height: h,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: _pages.isEmpty
                                  ? const _EmptyContent()
                                  : PageView.builder(
                                controller: _pc,
                                physics:
                                const BouncingScrollPhysics(),
                                itemCount: _pages.length,
                                itemBuilder: (_, i) {
                                  final p = _pages[i];
                                  // 극단적 환경 대비: 자동 축소
                                  return FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: BUildTwoLineCard(
                                        top: p.top, bottom: p.bottom),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// WebView를 Expanded/Stack 안에서 깔끔히 채우는 래퍼
class _WebViewFiller extends StatelessWidget {
  const _WebViewFiller();

  @override
  Widget build(BuildContext context) {
    // 상위 State의 컨트롤러에 접근하려면 Inherited/Callback을 쓰지만,
    // 여기서는 간단히 Builder로 다시 얻는다.
    final state = context.findAncestorStateOfType<_IOSWebViewLyricsScreenState>();
    return state == null ? const SizedBox.shrink() : WebViewWidget(controller: state._wc);
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
      elevation: 6, // 살짝 떠 보이게
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
              // 버튼들 + 주소 입력
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
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color:
                        const Color.fromRGBO(255, 255, 255, .12),
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
                          hintStyle:
                          TextStyle(color: Colors.white54),
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

              // 진행 표시(선택)
              if (progress > 0 && progress < 100)
                Padding(
                  padding:
                  const EdgeInsets.only(top: 6, left: 4, right: 4),
                  child: LinearProgressIndicator(
                    value: progress / 1.0 / 100.0,
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
        top: lines[i], bottom: i + 1 < lines.length ? lines[i + 1] : ''));
  }
  return out;
}

Widget BUildTwoLineCard({required String top, required String bottom}) {
  const base = TextStyle(
    color: Colors.white,
    fontSize: 22,
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
