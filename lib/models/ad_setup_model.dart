class AdSetupModel {
  String? type;
  bool? enable;
  bool? subscriptionEnable;
  Google? google;


  AdSetupModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    enable = json['enable'];
    subscriptionEnable = json['subscription_enable'];
    google = json['google'] != null ? Google.fromJson(json['google']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['enable'] = enable;
    data['subscription_enable'] = subscriptionEnable;

    if (google != null) {
      data['google'] = google!.toJson();
    }
    return data;
  }
}

class Google {
  GoogleAndroid? android;
  GoogleAndroid? ios;

  Google({this.android, this.ios});

  Google.fromJson(Map<String, dynamic> json) {
    android = json['android'] != null ? GoogleAndroid.fromJson(json['android']) : null;
    ios = json['ios'] != null ? GoogleAndroid.fromJson(json['ios']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (android != null) {
      data['android'] = android!.toJson();
    }
    if (ios != null) {
      data['ios'] = ios!.toJson();
    }
    return data;
  }
}

class GoogleAndroid {
  String? googleBannerAdUnitId;
  String? googleInterstitialAdUnitId;

  GoogleAndroid({this.googleBannerAdUnitId, this.googleInterstitialAdUnitId});

  GoogleAndroid.fromJson(Map<String, dynamic> json) {
    googleBannerAdUnitId = json['googleBannerAdUnitId'];
    googleInterstitialAdUnitId = json['googleInterstitialAdUnitId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['googleBannerAdUnitId'] = googleBannerAdUnitId;
    data['googleInterstitialAdUnitId'] = googleInterstitialAdUnitId;
    return data;
  }
}
