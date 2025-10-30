/*
// lib/music/appUI/metadata_ui.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

// 광고
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:bbo_music_player/privacy/privacy_gate.dart';

// l10n
import 'package:bbo_music_player/l10n/app_localizations.dart';

// 태그 읽기/쓰기
import '../read_music_metadata.dart';
import '../write_music_metadata.dart';

// 파일 피커
import 'package:bbo_music_player/music/appUI/myPick.dart' as pick;

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class AudioTagViewer extends StatefulWidget {
  const AudioTagViewer({
    super.key,
    required this.filePath,
    this.onShowBanner,
  });

  final String filePath; // file://, /storage/... 또는 content://
  final void Function(MaterialBanner banner)? onShowBanner;

  @override
  State<AudioTagViewer> createState() => _AudioTagViewerState();
}

class _AudioTagViewerState extends State<AudioTagViewer> {
  // controllers
  late final TextEditingController _lyricsCtl;
  final _lyricsScrollCtl = ScrollController();
  final Map<String, TextEditingController> _fieldCtrls = {};
  final Map<String, FocusNode> _focusNodes = {};

  Map<String, String>? _tags;
  bool _loading = false;
  bool _saving = false;
  String? _artworkPath;
  String? _lastError;
  bool _dirty = false;

  // Interstitial 상태
  InterstitialAd? _interstitialAd;
  bool _interstitialReady = false;
  bool _interstitialLoading = false;

  // 메타 키 순서
  static const List<String> _orderedKeys = <String>[
    'title',
    'artist',
    'album',
    'genre',
    'year',
    'track',
    'disc',
  ];

  TextEditingController _CtrlFor(String key) =>
      _fieldCtrls.putIfAbsent(key, () => TextEditingController());
  FocusNode _FOcusFor(String key) => _focusNodes.putIfAbsent(key, () => FocusNode());

  @override
  void initState() {
    super.initState();
    _lyricsCtl = TextEditingController();
    _LOad();

    // 전면 광고 사전 로드
    _LOadInterstitial();
  }

  @override
  void dispose() {
    _lyricsCtl.dispose();
    _lyricsScrollCtl.dispose();
    for (final c in _fieldCtrls.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }
    _interstitialAd?.dispose();
    _interstitialAd = null;
    super.dispose();
  }

  /// Interstitial 로드 (정책 태그 일관 적용)
  void _LOadInterstitial() {
    if (_interstitialLoading || _interstitialReady) return;
    _interstitialLoading = true;

    final adUnitId = _GetInterstitialTestUnitId(); // 개발 단계: 테스트 단위 ID. 배포 시 교체.
    if (adUnitId.isEmpty) {
      _interstitialLoading = false;
      return;
    }

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: PRivacy.instance.ADRequest(), // ← NPA/RDP/아동/UAC 반영
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialReady = true;
          _interstitialLoading = false;

          // 풀스크린 콜백: 닫히면 저장 실행 후 다음 광고 프리로드
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _interstitialReady = false;
              _interstitialLoading = false;
              _Save();             // 광고 닫힘 → 저장 실행
              _LOadInterstitial(); // 다음번 대비
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _interstitialReady = false;
              _interstitialLoading = false;
              _Save();             // 실패 → 바로 저장
              _LOadInterstitial();
            },
          );
          setState(() {});
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _interstitialReady = false;
          _interstitialLoading = false;
          // 로드 실패는 조용히 무시. 다음 클릭에 다시 로드 시도 가능.
        },
      ),
    );
  }

  /// 저장 아이콘 클릭 시: 광고 우선 노출, 닫히면 저장. 준비 안 됐으면 즉시 저장.
  void _OnSavePressed() {
    if (_saving) return;
    if (_interstitialReady && _interstitialAd != null) {
      try {
        _interstitialAd!.show(); // show() 직후 콜백에서 저장을 이어감.
      } catch (_) {
        _interstitialAd?.dispose();
        _interstitialAd = null;
        _interstitialReady = false;
        _Save();
        _LOadInterstitial();
      }
    } else {
      _Save();             // 광고 미준비 → 즉시 저장
      _LOadInterstitial(); // 다음번 대비
    }
  }

  /// 플랫폼별 테스트 Interstitial 단위 ID (개발 전용)
  String _GetInterstitialTestUnitId() {
    // Google 제공 데모 단위 ID. 실제 배포 전 교체 필수.
    // Android: ca-app-pub-3940256099942544/1033173712
    // iOS    : ca-app-pub-3940256099942544/4411468910
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
    return '';
  }

  Future<void> _LOad() async {
    setState(() {
      _loading = true;
      _lastError = null;
    });
    try {
      final tags = await readAudioTags(widget.filePath);
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;

      for (final key in _orderedKeys) {
        _CtrlFor(key).text = tags[key] ?? '';
      }
      _lyricsCtl.text = tags['lyrics'] ?? '';

      setState(() {
        _tags = Map.of(tags);
        _artworkPath = tags['artwork_path'];
        _loading = false;
        _dirty = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _lastError = '$e';
      });
    }
  }

  void _SHowBanner(MaterialBanner b) {
    if (widget.onShowBanner != null) {
      widget.onShowBanner!(b);
    } else {
      final m = ScaffoldMessenger.of(context)..removeCurrentMaterialBanner();
      m.showMaterialBanner(b);
    }
  }

  Future<void> _OnTapPickCover() async {
    final path = await pick.PickImageFile(['jpg', 'jpeg', 'png', 'webp']);
    if (path.isEmpty || path == 'a') return;

    setState(() {
      _artworkPath = path;
      _dirty = true;
    });

    final t = AppLocalizations.of(context)!;
    _SHowBanner(
      MaterialBanner(
        content: Text(t.bannerCoverSelected(p.basename(path))),
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: Text(t.btnClose),
          ),
        ],
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Future<void> _ClearCover() async {
    setState(() {
      _artworkPath = null;
      _dirty = true;
    });
  }

  Future<void> _Save() async {
    if (_tags == null || _saving) return;

    // snapshot
    final updated = Map<String, String>.from(_tags!);
    for (final key in _orderedKeys) {
      updated[key] = _CtrlFor(key).text;
    }
    updated['lyrics'] = _lyricsCtl.text;

    setState(() {
      _saving = true;
      _lastError = null;
    });

    final t = AppLocalizations.of(context)!;

    try {
      final result = await saveWithUserPicker(
        inputPath: widget.filePath,
        tags: updated,
        artworkPath: _artworkPath,
        suggestedName: _SUggestedName(),
      );

      if (!mounted) return;
      setState(() {
        _saving = false;
        _tags = updated;
        _dirty = false;
      });

      _SHowBanner(
        MaterialBanner(
          content: Text(t.saveDone(result.displayName)),
          actions: [
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: Text(t.btnClose),
            ),
          ],
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
    } on SaveCancelledException {
      if (!mounted) return;
      setState(() => _saving = false);
      _SHowBanner(
        MaterialBanner(
          content: Text(t.saveCancelled),
          actions: [
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: Text(t.btnClose),
            ),
          ],
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _lastError = '$e';
      });
      final onErr = Theme.of(context).colorScheme.onErrorContainer;
      _SHowBanner(
        MaterialBanner(
          content: Text(t.saveFailed('$e'), style: TextStyle(color: onErr)),
          actions: [
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: Text(t.btnClose),
            ),
          ],
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }

  String _SUggestedName() {
    final ext = p.extension(widget.filePath).toLowerCase();
    final title = _CtrlFor('title').text.trim();
    final baseFromPath = p.basenameWithoutExtension(widget.filePath);
    final base = (title.isNotEmpty ? title : (baseFromPath.isNotEmpty ? baseFromPath : 'audio'));
    return '$base${ext.isNotEmpty ? ext : '.mp3'}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final fileName = p.basename(widget.filePath);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.audioMetadataTitle(fileName),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: _dirty ? t.tooltipSaveAs : t.tooltipNoChanges,
            onPressed: (_saving || !_dirty) ? null : _OnSavePressed,
            icon: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save),
          ),
          IconButton(
            tooltip: t.tooltipReload,
            onPressed: _loading ? null : _LOad,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const SafeArea(child: Center(child: CircularProgressIndicator()))
          : SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double lyricsTarget =
            (constraints.maxHeight * 0.38).clamp(160.0, 360.0);

            return AnimatedPadding(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_lastError != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _lastError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 커버 카드(탭=선택, 롱탭=제거)
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: _OnTapPickCover,
                              onLongPress: _ClearCover,
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: _CoverPreview(_artworkPath),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: _BUildEditableFields()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // 가사: 고정 높이 + 내부 스크롤
                      SizedBox(
                        height: lyricsTarget,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Scrollbar(
                              controller: _lyricsScrollCtl,
                              child: ScrollConfiguration(
                                behavior: const NoGlowScrollBehavior(),
                                child: TextField(
                                  controller: _lyricsCtl,
                                  scrollController: _lyricsScrollCtl,
                                  scrollPhysics: const ClampingScrollPhysics(),
                                  decoration: InputDecoration(
                                    hintText: t.hintNone,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    border: const OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  onChanged: (_) => setState(() => _dirty = true),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _BUildEditableFields() {
    final t = AppLocalizations.of(context)!;

    // 메타 키 → 라벨 매핑
    final Map<String, String> labels = {
      'title': t.metaLabelTitle,
      'artist': t.metaLabelArtist,
      'album': t.metaLabelAlbum,
      'genre': t.metaLabelGenre,
      'year': t.metaLabelYear,
      'track': t.metaLabelTrack,
      'disc': t.metaLabelDisc,
    };

    final children = <Widget>[];
    for (var i = 0; i < _orderedKeys.length; i++) {
      final key = _orderedKeys[i];
      final label = labels[key] ?? key;
      final next = i < _orderedKeys.length - 1 ? _FOcusFor(_orderedKeys[i + 1]) : null;
      children.add(_KV(label: label, keyName: key, nextFocus: next));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _CoverPreview(String? artworkPath) {
    try {
      if (artworkPath != null && artworkPath.isNotEmpty) {
        final f = File(artworkPath);
        if (f.existsSync() && f.lengthSync() > 0) {
          return Image.file(f, width: 120, height: 120, fit: BoxFit.cover);
        }
      }
    } catch (_) {}
    return const Icon(Icons.album, size: 80, color: Colors.grey);
  }

  Widget _KV({
    required String label,
    required String keyName,
    FocusNode? nextFocus,
  }) {
    final c = _CtrlFor(keyName);
    final node = _FOcusFor(keyName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: c,
              focusNode: node,
              textInputAction: nextFocus == null ? TextInputAction.done : TextInputAction.next,
              onSubmitted: (_) {
                if (nextFocus != null) {
                  FocusScope.of(context).requestFocus(nextFocus);
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (_) => setState(() => _dirty = true),
            ),
          ),
        ],
      ),
    );
  }
}
*/
// lib/music/appUI/metadata_ui.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

// 광고
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:bbo_music_player/privacy/privacy_gate.dart';

// l10n
import 'package:bbo_music_player/l10n/app_localizations.dart';

// 태그 읽기/쓰기
import '../read_music_metadata.dart';
import '../write_music_metadata.dart';

// 파일 피커
import 'package:bbo_music_player/music/appUI/myPick.dart' as pick;

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class AudioTagViewer extends StatefulWidget {
  const AudioTagViewer({
    super.key,
    required this.filePath,
    this.onShowBanner,
  });

  final String filePath; // file://, /storage/... 또는 content://
  final void Function(MaterialBanner banner)? onShowBanner;

  @override
  State<AudioTagViewer> createState() => _AudioTagViewerState();
}

class _AudioTagViewerState extends State<AudioTagViewer> {
  // controllers
  late final TextEditingController _lyricsCtl;
  final _lyricsScrollCtl = ScrollController();
  final Map<String, TextEditingController> _fieldCtrls = {};
  final Map<String, FocusNode> _focusNodes = {};

  Map<String, String>? _tags;
  bool _loading = false;
  bool _saving = false;
  String? _artworkPath;
  String? _lastError;
  bool _dirty = false;

  // Interstitial 상태
  InterstitialAd? _interstitialAd;
  bool _interstitialReady = false;
  bool _interstitialLoading = false;

  // 메타 키 순서
  static const List<String> _orderedKeys = <String>[
    'title',
    'artist',
    'album',
    'genre',
    'year',
    'track',
    'disc',
  ];

  TextEditingController _CtrlFor(String key) =>
      _fieldCtrls.putIfAbsent(key, () => TextEditingController());
  FocusNode _FOcusFor(String key) => _focusNodes.putIfAbsent(key, () => FocusNode());

  @override
  void initState() {
    super.initState();
    _lyricsCtl = TextEditingController();
    _LOad();

    // 전면 광고 사전 로드
    _LOadInterstitial();
  }

  @override
  void dispose() {
    _lyricsCtl.dispose();
    _lyricsScrollCtl.dispose();
    for (final c in _fieldCtrls.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }
    _interstitialAd?.dispose();
    _interstitialAd = null;
    super.dispose();
  }

  /// Interstitial 로드 (정책 태그 일관 적용)
  void _LOadInterstitial() {
    if (_interstitialLoading || _interstitialReady) return;
    _interstitialLoading = true;

    final adUnitId = _GetInterstitialTestUnitId(); // 개발 단계: 테스트 단위 ID. 배포 시 교체.
    if (adUnitId.isEmpty) {
      _interstitialLoading = false;
      return;
    }

    InterstitialAd.load(
      adUnitId: adUnitId,
      request: PRivacy.instance.ADRequest(), // ← NPA/RDP/아동/UAC 반영
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialReady = true;
          _interstitialLoading = false;

          // 풀스크린 콜백: 닫히면 저장 실행 후 다음 광고 프리로드
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _interstitialReady = false;
              _interstitialLoading = false;
              _Save();             // 광고 닫힘 → 저장 실행
              _LOadInterstitial(); // 다음번 대비
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              _interstitialReady = false;
              _interstitialLoading = false;
              _Save();             // 실패 → 바로 저장
              _LOadInterstitial();
            },
          );
          setState(() {});
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _interstitialReady = false;
          _interstitialLoading = false;
          // 로드 실패는 조용히 무시. 다음 클릭에 다시 로드 시도 가능.
        },
      ),
    );
  }

  /// 저장 아이콘 클릭 시: 광고 우선 노출, 닫히면 저장. 준비 안 됐으면 즉시 저장.
  void _OnSavePressed() {
    if (_saving) return;
    if (_interstitialReady && _interstitialAd != null) {
      try {
        _interstitialAd!.show(); // show() 직후 콜백에서 저장을 이어감.
      } catch (_) {
        _interstitialAd?.dispose();
        _interstitialAd = null;
        _interstitialReady = false;
        _Save();
        _LOadInterstitial();
      }
    } else {
      _Save();             // 광고 미준비 → 즉시 저장
      _LOadInterstitial(); // 다음번 대비
    }
  }

  /// 플랫폼별 테스트 Interstitial 단위 ID (개발 전용)
  String _GetInterstitialTestUnitId() {
    // Google 제공 데모 단위 ID. 실제 배포 전 교체 필수. :contentReference[oaicite:2]{index=2}
    // Android: ca-app-pub-3940256099942544/1033173712
    // iOS    : ca-app-pub-3940256099942544/4411468910
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
    return '';
  }

  Future<void> _LOad() async {
    setState(() {
      _loading = true;
      _lastError = null;
    });
    try {
      final tags = await readAudioTags(widget.filePath);
      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;

      for (final key in _orderedKeys) {
        _CtrlFor(key).text = tags[key] ?? '';
      }
      _lyricsCtl.text = tags['lyrics'] ?? '';

      setState(() {
        _tags = Map.of(tags);
        _artworkPath = tags['artwork_path'];
        _loading = false;
        _dirty = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _lastError = '$e';
      });
    }
  }

  void _SHowBanner(MaterialBanner b) {
    if (widget.onShowBanner != null) {
      widget.onShowBanner!(b);
    } else {
      final m = ScaffoldMessenger.of(context)..removeCurrentMaterialBanner();
      m.showMaterialBanner(b);
    }
  }

  Future<void> _OnTapPickCover() async {
    final path = await pick.PickImageFile(['jpg', 'jpeg', 'png', 'webp']);
    if (path.isEmpty || path == 'a') return;

    setState(() {
      _artworkPath = path;
      _dirty = true;
    });

    final t = AppLocalizations.of(context)!;
    _SHowBanner(
      MaterialBanner(
        content: Text(t.bannerCoverSelected(p.basename(path))),
        actions: [
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
            child: Text(t.btnClose),
          ),
        ],
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Future<void> _ClearCover() async {
    setState(() {
      _artworkPath = null;
      _dirty = true;
    });
  }

  Future<void> _Save() async {
    if (_tags == null || _saving) return;

    // snapshot
    final updated = Map<String, String>.from(_tags!);
    for (final key in _orderedKeys) {
      updated[key] = _CtrlFor(key).text;
    }
    updated['lyrics'] = _lyricsCtl.text;

    setState(() {
      _saving = true;
      _lastError = null;
    });

    final t = AppLocalizations.of(context)!;

    try {
      final result = await saveWithUserPicker(
        inputPath: widget.filePath,
        tags: updated,
        artworkPath: _artworkPath,
        suggestedName: _SUggestedName(),
      );

      if (!mounted) return;
      setState(() {
        _saving = false;
        _tags = updated;
        _dirty = false;
      });

      _SHowBanner(
        MaterialBanner(
          content: Text(t.saveDone(result.displayName)),
          actions: [
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: Text(t.btnClose),
            ),
          ],
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
    } on SaveCancelledException {
      if (!mounted) return;
      setState(() => _saving = false);
      _SHowBanner(
        MaterialBanner(
          content: Text(t.saveCancelled),
          actions: [
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: Text(t.btnClose),
            ),
          ],
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _lastError = '$e';
      });
      final onErr = Theme.of(context).colorScheme.onErrorContainer;
      _SHowBanner(
        MaterialBanner(
          content: Text(t.saveFailed('$e'), style: TextStyle(color: onErr)),
          actions: [
            TextButton(
              onPressed: () => ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: Text(t.btnClose),
            ),
          ],
          elevation: 2,
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    }
  }

  String _SUggestedName() {
    final ext = p.extension(widget.filePath).toLowerCase();
    final title = _CtrlFor('title').text.trim();
    final baseFromPath = p.basenameWithoutExtension(widget.filePath);
    final base = (title.isNotEmpty ? title : (baseFromPath.isNotEmpty ? baseFromPath : 'audio'));
    return '$base${ext.isNotEmpty ? ext : '.mp3'}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final fileName = p.basename(widget.filePath);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.audioMetadataTitle(fileName),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            tooltip: _dirty ? t.tooltipSaveAs : t.tooltipNoChanges,
            onPressed: (_saving || !_dirty) ? null : _OnSavePressed,
            icon: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save),
          ),
          IconButton(
            tooltip: t.tooltipReload,
            onPressed: _loading ? null : _LOad,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const SafeArea(child: Center(child: CircularProgressIndicator()))
          : SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double lyricsTarget =
            (constraints.maxHeight * 0.38).clamp(160.0, 360.0);

            return AnimatedPadding(
              duration: const Duration(milliseconds: 160),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_lastError != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _lastError!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 커버 카드(탭=선택, 롱탭=제거)
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: _OnTapPickCover,
                              onLongPress: _ClearCover,
                              child: SizedBox(
                                width: 120,
                                height: 120,
                                child: _CoverPreview(_artworkPath),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(child: _BUildEditableFields()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // 가사: 고정 높이 + 내부 스크롤
                      SizedBox(
                        height: lyricsTarget,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Scrollbar(
                              controller: _lyricsScrollCtl,
                              child: ScrollConfiguration(
                                behavior: const NoGlowScrollBehavior(),
                                child: TextField(
                                  controller: _lyricsCtl,
                                  scrollController: _lyricsScrollCtl,
                                  scrollPhysics: const ClampingScrollPhysics(),
                                  decoration: InputDecoration(
                                    hintText: t.hintNone,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    border: const OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  onChanged: (_) => setState(() => _dirty = true),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _BUildEditableFields() {
    final t = AppLocalizations.of(context)!;

    // 메타 키 → 라벨 매핑
    final Map<String, String> labels = {
      'title': t.metaLabelTitle,
      'artist': t.metaLabelArtist,
      'album': t.metaLabelAlbum,
      'genre': t.metaLabelGenre,
      'year': t.metaLabelYear,
      'track': t.metaLabelTrack,
      'disc': t.metaLabelDisc,
    };

    final children = <Widget>[];
    for (var i = 0; i < _orderedKeys.length; i++) {
      final key = _orderedKeys[i];
      final label = labels[key] ?? key;
      final next = i < _orderedKeys.length - 1 ? _FOcusFor(_orderedKeys[i + 1]) : null;
      children.add(_KV(label: label, keyName: key, nextFocus: next));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _CoverPreview(String? artworkPath) {
    try {
      if (artworkPath != null && artworkPath.isNotEmpty) {
        final f = File(artworkPath);
        if (f.existsSync() && f.lengthSync() > 0) {
          return Image.file(f, width: 120, height: 120, fit: BoxFit.cover);
        }
      }
    } catch (_) {}
    return const Icon(Icons.album, size: 80, color: Colors.grey);
  }

  Widget _KV({
    required String label,
    required String keyName,
    FocusNode? nextFocus,
  }) {
    final c = _CtrlFor(keyName);
    final node = _FOcusFor(keyName);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: c,
              focusNode: node,
              textInputAction: nextFocus == null ? TextInputAction.done : TextInputAction.next,
              onSubmitted: (_) {
                if (nextFocus != null) {
                  FocusScope.of(context).requestFocus(nextFocus);
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (_) => setState(() => _dirty = true),
            ),
          ),
        ],
      ),
    );
  }
}
