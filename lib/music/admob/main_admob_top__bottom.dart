import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
      size: AdSize.banner, // 320x50 고정
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // (테스트용 배너 ID - Android)
          : 'ca-app-pub-3940256099942544/2934735716', // (테스트용 배너 ID - iOS)
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          debugPrint('Banner load failed: $err');
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
    // 컨테이너 크기는 광고 크기 이상이어야 하며, 패딩으로 줄어들면 표시되지 않습니다.
    // (공식 문서 참고)
    return SizedBox(
      width: _ad!.size.width.toDouble(),   // 320
      height: _ad!.size.height.toDouble(), // 50
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
      size: AdSize.banner, // 320x50 고정
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // (테스트용 배너 ID - Android)
          : 'ca-app-pub-3940256099942544/2934735716', // (테스트용 배너 ID - iOS)
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _loaded = true),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          debugPrint('Banner load failed: $err');
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
    if (!_loaded || _ad == null) {
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa    $_ad");
      return const SizedBox.shrink();
    }
    // 컨테이너 크기는 광고 크기 이상이어야 하며, 패딩으로 줄어들면 표시되지 않습니다.
    // (공식 문서 참고)
    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}