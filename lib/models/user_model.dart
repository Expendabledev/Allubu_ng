import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstName;
  String? lastName;
  String? id;
  String? email;
  String? loginType;
  String? profilePic;
  String? dateOfBirth;
  String? fcmToken;
  String? countryCode;
  String? countryISOCode;
  String? phoneNumber;
  String? gender;
  bool? isActive;
  Timestamp? createdAt;
  List<dynamic>? followers;
  Subscription? subscription;
  String? appIdentifier;

  UserModel({
    this.firstName,
    this.lastName,
    this.id,
    this.isActive,
    this.dateOfBirth,
    this.email,
    this.loginType,
    this.profilePic,
    this.fcmToken,
    this.countryCode,
    this.countryISOCode,
    this.phoneNumber,
    this.createdAt,
    this.followers,
    this.subscription,
    this.appIdentifier,
  });

  String fullName() {
    return "$firstName $lastName";
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    id = json['id'];
    email = json['email'];
    loginType = json['loginType'];
    profilePic = json['profilePic'];
    fcmToken = json['fcmToken'];
    countryCode = json['countryCode'];
    countryISOCode = json['countryISOCode'];
    phoneNumber = json['phoneNumber'];
    createdAt = json['createdAt'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'] ?? '';
    isActive = json['isActive'];
    followers = json['followers'] ?? [];
    subscription = json['subscription'] != null ? Subscription.fromJson(json['subscription']) : Subscription();
    appIdentifier = json['appIdentifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['id'] = id;
    data['email'] = email;
    data['loginType'] = loginType;
    data['profilePic'] = profilePic;
    data['fcmToken'] = fcmToken;
    data['countryCode'] = countryCode;
    data['countryISOCode'] = countryISOCode;
    data['phoneNumber'] = phoneNumber;
    data['createdAt'] = createdAt;
    data['gender'] = gender;
    data['dateOfBirth'] = dateOfBirth;
    data['isActive'] = isActive;

    data['followers'] = followers;
    if (subscription != null) {
      data['subscription'] = subscription!.toJson();
    }
    data['appIdentifier'] = appIdentifier;
    return data;
  }
}

class Subscription {
  String? purchaseID;
  String? productID;
  String? platform;
  Timestamp? expireDate;

  Subscription({this.purchaseID, this.productID, this.expireDate, this.platform});

  Subscription.fromJson(Map<String, dynamic> json) {
    purchaseID = json['purchaseID'];
    productID = json['productID'];
    expireDate = json['expireDate'];
    platform = json['platform'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['purchaseID'] = purchaseID;
    data['productID'] = productID;
    data['expireDate'] = expireDate;
    data['platform'] = platform;
    return data;
  }
}
