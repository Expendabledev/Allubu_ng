import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allubmarket/models/business_model.dart';

class CheckInModel {
  String? id;
  String? description;
  Timestamp? createdAt;
  List<dynamic>? images;
  bool? shareWithFriend;
  String? businessId;
  String? userId;
  LatLngModel? location;

  CheckInModel(
      {this.id,
      this.description,
      this.createdAt,
      this.images,
      this.shareWithFriend,
      this.businessId,
      this.userId,
      this.location});

  CheckInModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    createdAt = json['createdAt'];
    images = json['images'] ?? [];
    shareWithFriend = json['shareWithFriend'];
    businessId = json['businessId'];
    userId = json['userId'];
    location = json['location'] != null
        ? LatLngModel.fromJson(json['location'])
        : LatLngModel();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['description'] = description;
    data['createdAt'] = createdAt;
    data['images'] = images;
    data['shareWithFriend'] = shareWithFriend;
    data['businessId'] = businessId;
    data['userId'] = userId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}
