// lib/admob/ad_orchestrator.dart
import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../privacy/privacy_gate.dart';

class ADOrchestrator {
  ADOrchestrator._();
  static final ADOrchestrator instance = ADOrchestrator._();

  InterstitialAd? _ad;
  bool _loading = false;
  Future<void>? _pending;

  // ── 재시도 백오프 상태 ───────────────────────────────────────────────
  int _retryAttempt = 0;
  Timer? _retryTimer;

  Future<void> INit() async {
    await _preload();
  }

  Future<void> _preload() async {
    if (_ad != null || _loading) return;
    _loading = true;

    final unitId = _getInterstitialUnitId();
    if (unitId.isEmpty) {
      _loading = false;
      return;
    }

    // (선택) EEA에서 UMP 동의 전 사전 게이트: 필요 시 주석 해제
    // if (!PRivacy.instance.canRequestAdsGateOk()) {
    //   _loading = false;
    //   // 동의 완료 이후 다시 시도하도록 짧게 예약
    //   _scheduleRetry(const Duration(seconds: 15));
    //   return;
    // }

    await InterstitialAd.load(
      adUnitId: unitId,
      request: PRivacy.instance.ADRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _cancelRetry();
          _ad = ad;
          _loading = false;
          _retryAttempt = 0;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _ad = null;
              unawaited(_preload());
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _ad = null;
              _scheduleRetry(_nextBackoff());
            },
          );
        },
        onAdFailedToLoad: (e) {
          _ad = null;
          _loading = false;
          _scheduleRetry(_nextBackoff());
        },
      ),
    );
  }

  Future<void> showInterstitialAndWaitForDismiss() {
    if (_pending != null) return _pending!;

    final completer = Completer<void>();
    _pending = completer.future;

    Future<void>(() async {
      if (_ad == null) {
        await _preload();
        _pending = null;
        if (!completer.isCompleted) completer.complete();
        return;
      }

      final ad = _ad!;
      _ad = null;

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
          _scheduleRetry(_nextBackoff());
        },
      );

      try {
        ad.show();
      } catch (_) {
        try { ad.dispose(); } catch (_) {}
        if (!completer.isCompleted) completer.complete();
        _pending = null;
        _scheduleRetry(_nextBackoff());
      }
    });

    return _pending!;
  }

  // ── 백오프 계산/예약 ───────────────────────────────────────────────
  Duration _nextBackoff() {
    // 10s → 20s → 40s → 80s … 최대 5분
    final secs = 10 * (1 << (_retryAttempt.clamp(0, 5)));
    _retryAttempt = (_retryAttempt + 1).clamp(0, 10);
    final d = Duration(seconds: secs.clamp(10, 300));
    return d;
    // 필요하면 Jitter 추가 가능
  }

  void _scheduleRetry(Duration d) {
    _cancelRetry();
    _retryTimer = Timer(d, () {
      _preload();
    });
  }

  void _cancelRetry() {
    _retryTimer?.cancel();
    _retryTimer = null;
  }

  String _getInterstitialUnitId() {
   /*
   if (!kReleaseMode) {
      if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
      if (Platform.isIOS)     return 'ca-app-pub-3940256099942544/4411468910';
      return '';
    }
    */
    if (Platform.isAndroid) return 'ca-app-pub-3252837628484304/5955200142';
    if (Platform.isIOS)     return 'ca-app-pub-3252837628484304/2283548445';
    return '';
  }
}
