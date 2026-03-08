import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yelpify/models/business_model.dart';

class BookmarksModel {
  String? id;
  String? ownerId;
  String? name;
  String? description;
  bool? isDefault;
  List<dynamic>? businessIds;
  List<dynamic>? followers;
  bool? isPrivate;
  bool? byAdmin;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? shareLinkCode;
  Positions? position;
  LatLngModel? location;

  BookmarksModel({
    this.id,
    this.ownerId,
    this.name,
    this.description,
    this.isDefault,
    this.businessIds,
    this.followers,
    this.isPrivate,
    this.byAdmin,
    this.createdAt,
    this.updatedAt,
    this.shareLinkCode,
    this.position,
    this.location,
  });

  BookmarksModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ownerId = json['ownerId'];
    name = json['name'];
    description = json['description'];
    isDefault = json['isDefault'];
    businessIds = json['businessIds'] ?? [];
    followers = json['followers'] ?? [];
    isPrivate = json['isPrivate'];
    byAdmin = json['byAdmin'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    shareLinkCode = json['shareLinkCode'];
    position = json['position'] != null ? Positions.fromJson(json['position']) : Positions();
    location = json['location'] != null ? LatLngModel.fromJson(json['location']) : LatLngModel();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ownerId'] = ownerId;
    data['name'] = name;
    data['description'] = description;
    data['isDefault'] = isDefault;
    data['businessIds'] = businessIds;
    data['followers'] = followers;
    data['isPrivate'] = isPrivate;
    data['byAdmin'] = byAdmin;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['shareLinkCode'] = shareLinkCode;
    if (position != null) {
      data['position'] = position!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}
