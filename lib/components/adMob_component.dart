import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../main.dart';

InterstitialAd? interstitialAd;

adShow() async {
  if (interstitialAd == null) {
    print('Warning: attempt to show interstitial before loaded.');
    return;
  }
  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      print('$ad onAdDismissedFullScreenContent.');
      ad.dispose();

    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      print('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createInterstitialAd();
    },
  );
  interstitialAd!.show();
}

 createInterstitialAd() {
  InterstitialAd.load(
    adUnitId: kReleaseMode
        ? getInterstitialAdUnitId()!
        : Platform.isIOS
            ? userStore.admobInterstitialIdIos
            : userStore.admobInterstitialId,
    request: AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (InterstitialAd ad) {
        print('$ad loaded');
        interstitialAd = ad;
      },
      onAdFailedToLoad: (LoadAdError error) {
        print('InterstitialAd failed to load: $error.');
        interstitialAd = null;
      },
    ),
  );
}

String? getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return userStore.admobInterstitialIdIos;
  } else if (Platform.isAndroid) {
    return userStore.admobInterstitialId;
  }
  return null;
}

String? getBannerAdUnitId() {
  if (Platform.isIOS) {
    return userStore.admobInterstitialIdIos;
  } else if (Platform.isAndroid) {
    return userStore.admobBannerId;
  }
  return null;
}

Widget showBannerAds( BuildContext context) {
  return Container(
    height: 50,
    width: MediaQuery.of(context).size.width,
    child: AdWidget(
      ad: BannerAd(
        adUnitId: getBannerAdUnitId()!,
        size: AdSize.fullBanner,
        request: AdRequest(),
        listener: BannerAdListener(),
      )..load(),
    ),
  );
}

void loadInterstitialAds() {
  createInterstitialAd();
}

void showInterstitialAds() {
  adShow();
}
