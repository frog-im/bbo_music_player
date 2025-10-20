// lib/admob/ad_orchestrator.dart
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ADOrchestrator {
  ADOrchestrator._();
  static final ADOrchestrator instance = ADOrchestrator._();

  InterstitialAd? _ad;
  bool _loading = false;

  Future<void>? _pending; // 진행 중인 표시-대기 작업 공유용

  Future<void> INit() async {
    await _preload();
  }

  Future<void> _preload() async {
    if (_ad != null || _loading) return;
    _loading = true;

    final unitId = _getInterstitialUnitId();
    if (unitId.isEmpty) { _loading = false; return; }

    await InterstitialAd.load(
      adUnitId: unitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _loading = false;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _ad = null;
              // 다음 대비 미리 로드
              unawaited(_preload());
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _ad = null;
              unawaited(_preload());
            },
          );
        },
        onAdFailedToLoad: (e) {
          _ad = null;
          _loading = false;
          // 네트워크 안 좋을 수 있으니 다음 기회에 다시
        },
      ),
    );
  }

  /// 전면광고를 보여주고 '닫힘/실패' 콜백까지 **완전히** 기다린다.
  Future<void> showInterstitialAndWaitForDismiss() {
    // 이미 표시-대기가 진행 중이면 같은 Future를 돌려줌
    if (_pending != null) return _pending!;

    final completer = Completer<void>();
    _pending = completer.future;

    Future<void>(() async {
      // 준비 안 됐으면 프리로드만 시도하고 종료
      if (_ad == null) {
        await _preload();
        _pending = null;
        if (!completer.isCompleted) completer.complete();
        return;
      }

      final ad = _ad!;
      _ad = null; // 한 번 쓰면 폐기

      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          if (!completer.isCompleted) completer.complete();
          _pending = null;
          unawaited(_preload());
        },
        onAdFailedToShowFullScreenContent: (ad, err) {
          ad.dispose();
          if (!completer.isCompleted) completer.complete();
          _pending = null;
          unawaited(_preload());
        },
      );

      try {
        ad.show();
      } catch (_) {
        // show 중 예외가 나도 대기 종료 후 다음 프리로드
        try { ad.dispose(); } catch (_) {}
        if (!completer.isCompleted) completer.complete();
        _pending = null;
        unawaited(_preload());
      }
    });

    return _pending!;
  }

  String _getInterstitialUnitId() {
    if (!kReleaseMode) {
      if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
      if (Platform.isIOS)     return 'ca-app-pub-3940256099942544/4411468910';
      return '';
    }
    if (Platform.isAndroid) return 'ca-app-pub-<YOUR-ANDROID-UNIT-ID>';
    if (Platform.isIOS)     return 'ca-app-pub-<YOUR-IOS-UNIT-ID>';
    return '';
  }
}
