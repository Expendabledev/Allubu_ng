import 'package:cloud_firestore/cloud_firestore.dart';

import 'subscription_ads_model.dart';

class SubscriptionAdsHistory {
  String? id;
  String? productID;
  String? purchaseID;
  String? verificationData;
  String? transactionDate;
  String? status;
  String? userId;
  String? platform;
  String? price;
  Timestamp? expireDate;
  Timestamp? createdAt;
  SubscriptionAdsModel? subscription;

  SubscriptionAdsHistory(
      {this.id, this.productID, this.purchaseID, this.verificationData, this.transactionDate, this.status, this.userId, this.platform, this.expireDate,this.price, this.subscription,this.createdAt});

  SubscriptionAdsHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productID = json['productID'];
    purchaseID = json['purchaseID'];
    verificationData = json['verificationData'];
    transactionDate = json['transactionDate'];
    status = json['status'];
    userId = json['userId'];
    platform = json['platform'];
    expireDate = json['expireDate'];
    createdAt = json['createdAt'];
    price = json['price'];
    subscription = json['subscription'] != null ? SubscriptionAdsModel.fromJson(json['subscription']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productID'] = productID;
    data['purchaseID'] = purchaseID;
    data['verificationData'] = verificationData;
    data['transactionDate'] = transactionDate;
    data['status'] = status;
    data['userId'] = userId;
    data['platform'] = platform;
    data['expireDate'] = expireDate;
    data['createdAt'] = createdAt;
    data['price'] = price;
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    return data;
  }
}
