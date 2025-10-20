// lib/music/appUI/subtitles/subtitle_BoxEditor.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

/// 자막 편집기:
/// - 드래그로 위치 지정
/// - 폰트 크기 모달 피커
/// - 좌표/폰트 저장/복원
/// - 2단계 오차 보정(저장 시에만 Δ 적용)
/// - 상단 팔레트: 우상단 버튼을 누르면 아래로 작게 펼쳐짐
class OverlayBoxEditor extends StatefulWidget {
  const OverlayBoxEditor({
    super.key,
    this.text1 = '짧은 글일 경우',
    this.text2 = '해당 자막이 긴 글일 경우에에ㅔㅔㅔ요',
    this.minFont = 14,
    this.maxFont = 36,
    this.initFont = 14,
  });

  final String text1;
  final String text2;
  final double minFont;
  final double maxFont;
  final double initFont;

  @override
  State<OverlayBoxEditor> createState() => _OverlayBoxEditorState();
}

class _OverlayBoxEditorState extends State<OverlayBoxEditor>
    with SingleTickerProviderStateMixin {
  // 저장 키
  static const _kX = 'overlay_box_x';
  static const _kY = 'overlay_box_y';
  static const _kFont = 'overlay_text_font';

  // 상태
  Offset _pos = const Offset(24, 120); // 에디터상 논리 좌표
  double _fontSize = 22;
  bool _lockCenter = false;

  // 저장 트리거
  bool _requestSaveAndClose = false;

  // 오차 보정 상태
  bool _calibrating = false;
  Offset? _calibStartBoxPos; // 1회차 버튼 시점 렌더 좌표
  Offset? _pendingDelta;     // 저장 시에만 적용할 보정값(1회차 − 2회차)
  Offset _lastRenderedPos = const Offset(24, 120);

  // 팔레트 상태
  bool _paletteOpen = false;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    LOadPrefs();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    CLoseOverlayIfActive();
    super.dispose();
  }

  // ───────── 저장/복원 ─────────

  Future<void> LOadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    final x = sp.getDouble(_kX);
    final y = sp.getDouble(_kY);
    final f = sp.getDouble(_kFont);
    if (!mounted) return;
    setState(() {
      _pos = Offset(x ?? _pos.dx, y ?? _pos.dy);
      _fontSize = f ?? widget.initFont;
    });
  }

  Future<void> SAvePrefsAt({required Offset pos}) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setDouble(_kX, pos.dx);
    await sp.setDouble(_kY, pos.dy);
    await sp.setDouble(_kFont, _fontSize);
  }

  // ───────── 보정/유틸 ─────────

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

  Offset CAlcCenteredOffset(Size areaSize, Size boxSize) {
    final x = (areaSize.width - boxSize.width) / 2;
    final y = (areaSize.height - boxSize.height) / 2;
    return Offset(x, y);
  }

  Future<void> CLoseOverlayIfActive() async {
    try {
      if (await FlutterOverlayWindow.isActive() == true) {
        await FlutterOverlayWindow.closeOverlay();
      }
    } catch (_) {}
  }

  void TOgglePalette() {
    setState(() => _paletteOpen = !_paletteOpen);
  }

  // ───────── 오차 버튼(2단계) ─────────

  /// 1회차(오차없애기): 현재 렌더 좌표로 오버레이 생성(고정)
  Future<void> SHowOverlayForCalib() async {
    setState(() {
      _calibrating = true;
      _calibStartBoxPos = _lastRenderedPos;
      _pendingDelta = null; // 이전 보정값 초기화
    });
    try {
      // 물리 픽셀 기준 75% × 10% 사이즈
      final view = WidgetsBinding.instance.platformDispatcher.views.first;
      final widthPx  = (view.physicalSize.width  * 0.75).round();
      final heightPx = (view.physicalSize.height * 0.10).round();

      await FlutterOverlayWindow.showOverlay(
        alignment: OverlayAlignment.topLeft,
        width:  widthPx,
        height: heightPx,
        startPosition: OverlayPosition(_lastRenderedPos.dx, _lastRenderedPos.dy),
        enableDrag: false, // 고정
        positionGravity: PositionGravity.none,
      );
    } catch (_) {
      if (mounted) setState(() => _calibrating = false);
    }
  }

  /// 2회차(겹치기): Δ = (1회차 렌더 − 현재 렌더) 저장 시만 적용. 오버레이 자동 종료.
  Future<void> FInishCalibAndQueueDelta() async {
    try {
      if (_calibStartBoxPos == null) {
        if (mounted) setState(() => _calibrating = false);
        return;
      }
      final delta = _calibStartBoxPos! - _lastRenderedPos;
      setState(() {
        _pendingDelta = delta;  // UI 이동 없음, 저장 시에만 반영
        _calibrating = false;
        _calibStartBoxPos = null;
      });
    } finally {
      await CLoseOverlayIfActive();
    }
  }

  // ───────── 폰트 선택(모달) ─────────

  Future<void> SHoWFontPicker(BuildContext context) async {
    final min = widget.minFont.floor();
    final max = widget.maxFont.floor();
    final values = [for (int v = min; v <= max; v++) v.toDouble()];
    int initial = values.indexWhere((v) => v.round() == _fontSize.round());
    if (initial < 0) initial = 0;

    final controller = FixedExtentScrollController(initialItem: initial);
    double selected = values[initial];

    final result = await showModalBottomSheet<double>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: SizedBox(
            height: 320,
            child: Column(
              children: [
                const SizedBox(height: 12),
                const Text('폰트 크기 선택', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: controller,
                    itemExtent: 40,
                    onSelectedItemChanged: (i) => selected = values[i],
                    children: [for (final v in values) Center(child: Text(v.toStringAsFixed(0)))],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(null),
                          child: const Text('취소'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.of(ctx).pop(selected),
                          child: const Text('확인'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null && mounted) {
      setState(() => _fontSize = result);
    }
  }

  // ───────── UI ─────────

  @override
  Widget build(BuildContext context) {
    // 편집 영역: 좌표계 0,0을 화면 맨 위에 맞추기 위해 상단에 별도 SafeArea 패딩 주지 않음
    final palette = _BUildPalette(); // 위에 겹쳐 띄울 작은 팔레트

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.02),
      body: Stack(
        children: [
          // 편집 영역(전체)
          Positioned.fill(child: _BUildEditor()),

          // 우상단 "팔레트" 토글 버튼
          Positioned(
            top: 8,
            right: 8,
            child: _BUildPaletteToggleButton(),
          ),

          // 팔레트(아래로 슬라이드 + 페이드)
          Positioned(
            top: 48, // 토글 버튼 바로 아래
            right: 8,
            child: palette,
          ),
        ],
      ),
    );
  }

  // 팔레트 토글 버튼(우상단 작은 버튼)
  Widget _BUildPaletteToggleButton() {
    return FilledButton.tonalIcon(
      onPressed: TOgglePalette,
      icon: Icon(_paletteOpen ? Icons.close_fullscreen : Icons.color_lens),
      label: const Text('팔레트'),
      style: FilledButton.styleFrom(
        visualDensity: VisualDensity.compact,
        minimumSize: const Size(10, 36),
      ),
    );
  }

  // 작은 팔레트: 아래로 펼쳐지는 카드
  Widget _BUildPalette() {
    // AnimatedSlide/AnimatedOpacity 조합으로 부드럽게 열고 닫힘
    // AnimatedSlide는 child 크기 기준 오프셋 비율로 이동(0, -0.1 등)한다. :contentReference[oaicite:2]{index=2}
    final content = Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 260, maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1) 폰트
              Row(
                children: [
                  const Icon(Icons.format_size, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text('폰트 ${_fontSize.toStringAsFixed(0)}')),
                  FilledButton.tonal(
                    onPressed: () => SHoWFontPicker(context),
                    child: const Text('변경'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 2) X축 중앙 고정
              Row(
                children: [
                  const Icon(Icons.center_focus_strong, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('X축 중앙 고정')),
                  Switch(
                    value: _lockCenter,
                    onChanged: (v) => setState(() => _lockCenter = v),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 3) 오차 버튼(토글)
              Row(
                children: [
                  Icon(_calibrating ? Icons.merge_type : Icons.open_in_new, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_calibrating ? '겹치기(Δ 큐에 저장)' : '오차없애기(오버레이 고정)')),
                  FilledButton(
                    onPressed: () async {
                      if (_calibrating) {
                        await FInishCalibAndQueueDelta();
                      } else {
                        await SHowOverlayForCalib();
                      }
                    },
                    child: Text(_calibrating ? '겹치기' : '오차없애기'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // 4) 저장
              Row(
                children: [
                  const Icon(Icons.save, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('보정값 적용 후 저장')),
                  FilledButton(
                    onPressed: () async {
                      _requestSaveAndClose = true;
                      await CLoseOverlayIfActive(); // 안전 종료
                      if (!mounted) return;
                      setState(() {});
                    },
                    child: const Text('저장'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return AnimatedSlide(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      offset: _paletteOpen ? Offset.zero : const Offset(0, -0.1),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: _paletteOpen ? 1 : 0,
        child: IgnorePointer(
          ignoring: !_paletteOpen,
          child: content,
        ),
      ),
    ); // AnimatedOpacity로 페이드도 함께 처리. :contentReference[oaicite:3]{index=3}
  }

  // 편집 영역(전체)
  Widget _BUildEditor() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = constraints.biggest; // 논리 픽셀
        final boxW = screen.width * 0.75;   // 폭 75%
        final boxH = screen.height * 0.10;  // 높이 10%
        final boxSize = Size(boxW, boxH);

        // 자유 모드 좌표 경계 보정
        final posWhenFree = CLampOffset(pos: _pos, areaSize: screen, boxSize: boxSize);

        // 중앙 고정 모드
        final centerPos = CAlcCenteredOffset(screen, boxSize);
        final posToUse = _lockCenter ? Offset(centerPos.dx, posWhenFree.dy) : posWhenFree;

        // 현재 프레임 렌더 좌표 캐시
        _lastRenderedPos = posToUse;

        // 저장 트리거 처리: 저장 시점에만 delta 적용
        if (_requestSaveAndClose) {
          _requestSaveAndClose = false;

          final savePos = posToUse + (_pendingDelta ?? Offset.zero);
          SAvePrefsAt(pos: savePos).then((_) {
            _pendingDelta = null; // 보정값 소진
            if (mounted) Navigator.of(context).pop(true);
          });
        }

        return Stack(
          children: [
            // 배경 가이드
            Positioned.fill(
              child: IgnorePointer(child: CustomPaint(painter: _GridPainter())),
            ),

            // 드래그 박스
            Positioned(
              left: posToUse.dx,
              top:  posToUse.dy,
              width: boxW,
              height: boxH,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    if (_lockCenter) {
                      _pos = CLampOffset(
                        pos: _pos + Offset(0, details.delta.dy),
                        areaSize: screen,
                        boxSize: boxSize,
                      );
                    } else {
                      _pos = CLampOffset(
                        pos: _pos + details.delta,
                        areaSize: screen,
                        boxSize: boxSize,
                      );
                    }
                  });
                },
                child: _DraggableTextBox(
                  width: boxW,
                  height: boxH,
                  fontSize: _fontSize,
                  topText: widget.text1,
                  bottomText: widget.text2,
                ),
              ),
            ),

            // HUD
            Positioned(
              left: 8,
              bottom: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Text(
                    'x: ${posToUse.dx.toStringAsFixed(0)}  '
                        'y: ${posToUse.dy.toStringAsFixed(0)}  '
                        'font: ${_fontSize.toStringAsFixed(0)}'
                        '${_lockCenter ? "  (X중앙 고정)" : ""}'
                        '${_pendingDelta != null ? "  Δ(${_pendingDelta!.dx.toStringAsFixed(0)}, ${_pendingDelta!.dy.toStringAsFixed(0)})" : ""}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 드래그 박스(두 줄, 각 Text는 maxLines: 1)
class _DraggableTextBox extends StatelessWidget {
  const _DraggableTextBox({
    required this.width,
    required this.height,
    required this.fontSize,
    required this.topText,
    required this.bottomText,
  });

  final double width;
  final double height;
  final double fontSize;
  final String topText;
  final String bottomText;

  @override
  Widget build(BuildContext context) {
    final base = TextStyle(
      color: Colors.white,
      fontSize: fontSize,
      height: 1.22,
      fontWeight: FontWeight.w800,
      shadows: const [Shadow(color: Colors.black45, blurRadius: 2)],
    );

    return Card(
      color: const Color.fromRGBO(0, 0, 0, .55),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(topText, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: base),
              const SizedBox(height: 6),
              Text(bottomText, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: base),
            ],
          ),
        ),
      ),
    );
  }
}

/// 배경 가이드
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = Colors.grey.withOpacity(0.15);
    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
