class SubscriptionAdsModel {
  bool? enable;
  String? iosPlanId;
  String? id;
  String? title;
  String? duration;
  String? description;
  String? androidPlanId;
  String? price;

  SubscriptionAdsModel(
      {this.enable,
        this.iosPlanId,
        this.id,
        this.title,
        this.duration,
        this.description,
        this.androidPlanId,this.price});

  SubscriptionAdsModel.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    iosPlanId = json['iosPlanId'];
    id = json['id'];
    title = json['title'];
    duration = json['duration'];
    description = json['description'];
    androidPlanId = json['androidPlanId'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['iosPlanId'] = iosPlanId;
    data['id'] = id;
    data['title'] = title;
    data['duration'] = duration;
    data['description'] = description;
    data['androidPlanId'] = androidPlanId;
    data['price'] = price;
    return data;
  }
}
