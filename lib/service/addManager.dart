import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  AppOpenAd? _appOpenAd;

  Future createAppOpenAd() async {
    await AppOpenAd.load(
        adUnitId: "ca-app-pub-7147054860971793/2965066618",
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            debugPrint("openad is loaded");
            _appOpenAd = ad;
            _appOpenAd!.show();
          },
          onAdFailedToLoad: (error) => debugPrint("adopenad failed $error"),
        ),
        orientation: AppOpenAd.orientationPortrait);
  }

  BannerAd loadBanner(BannerAd? bannerAd) {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-7147054860971793/3584330943',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();

    return bannerAd;
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-7147054860971793/8921769171",
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (ad) {
            debugPrint('$ad loaded.');
            // Keep a reference to the ad so you can show it later.
            ad.show();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ));
  }
}
