import 'package:cloud_firestore/cloud_firestore.dart';

class PhotoModel {
  String? id;
  String? businessId;
  List<dynamic>? likedBy;
  dynamic imageUrl;
  String? userId;
  String? reviewId;
  Timestamp? createdAt;
  String? type;
  String? fileType;

  PhotoModel({this.id, this.businessId, this.likedBy, this.imageUrl, this.userId, this.reviewId, this.createdAt, this.type});

  PhotoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['businessId'];
    likedBy = json['likedBy'] ?? [];
    imageUrl = json['imageUrl'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    reviewId = json['reviewId'];
    type = json['type'];
    fileType = json['fileType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['businessId'] = businessId;
    data['likedBy'] = likedBy;
    data['imageUrl'] = imageUrl;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['type'] = type;
    data['fileType'] = fileType;
    data['reviewId'] = reviewId;
    return data;
  }
}
