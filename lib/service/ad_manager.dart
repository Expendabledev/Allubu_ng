import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yelpify/constant/constant.dart';

class AdManager {
  static void initialize() {
    MobileAds.instance.initialize();
  }

  static String get googleBannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Constant.adSetupModel!.google!.android!.googleBannerAdUnitId.toString();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Constant.adSetupModel!.google!.ios!.googleBannerAdUnitId.toString();
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get googleInterstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return Constant.adSetupModel!.google!.android!.googleInterstitialAdUnitId.toString();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return Constant.adSetupModel!.google!.ios!.googleInterstitialAdUnitId.toString();
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static Widget bannerAdWidget() {
    if (Constant.adSetupModel?.enable == true) {
      // Plan doesn't matter if ads are enabled
      if (Constant.isPlanExpire() == true) {
        final bannerAd = BannerAd(
          adUnitId: googleBannerAdUnitId,
          size: AdSize.banner,
          request: AdRequest(),
          listener: BannerAdListener(),
        )..load();

        return SizedBox(
          height: 55,
          child: AdWidget(ad: bannerAd),
        );
      } else {
        return const SizedBox();
      }
    }
    return const SizedBox();
  }
}
