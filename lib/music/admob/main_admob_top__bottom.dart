// lib/music/admob/main_admob_top__bottom.dart
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../privacy/privacy_gate.dart';

class Banner320x50_top extends StatefulWidget {
  const Banner320x50_top({super.key});
  @override
  State<Banner320x50_top> createState() => _Banner320x50_topState();
}

class _Banner320x50_topState extends State<Banner320x50_top> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      size: AdSize.banner, // 320x50
      adUnitId: Platform.isAndroid
          ? /*'ca-app-pub-3940256099942544/6300978111'*/ 'ca-app-pub-3252837628484304/2261714757'
          : /*'ca-app-pub-3940256099942544/2934735716'*/'ca-app-pub-3252837628484304/6364611292',
      request: PRivacy.instance.ADRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          // 필요 시 재시도 로직 추가 가능
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}

class Banner320x50_bottom extends StatefulWidget {
  const Banner320x50_bottom({super.key});
  @override
  State<Banner320x50_bottom> createState() => _Banner320x50State();
}

class _Banner320x50State extends State<Banner320x50_bottom> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _ad = BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isAndroid
          ? /*'ca-app-pub-3940256099942544/6300978111'*/ 'ca-app-pub-3252837628484304/1650684124'
          : /*'ca-app-pub-3940256099942544/2934735716'*/'ca-app-pub-3252837628484304/9621330020',
      request: PRivacy.instance.ADRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() => _loaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}
