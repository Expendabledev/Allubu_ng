import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String? id;
  String? businessId;
  String? userId;
  Timestamp? createdAt;
  String? review;
  String? comment;
  List<dynamic>? helpful;
  List<dynamic>? loveThis;
  List<dynamic>? ohNo;
  List<dynamic>? thanks;

  ReviewModel({
    this.id,
    this.businessId,
    this.userId,
    this.createdAt,
    this.review,
    this.comment,
    this.helpful,
    this.loveThis,
    this.ohNo,
    this.thanks,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['businessId'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    review = json['review'];
    comment = json['comment'] ?? '';
    helpful = json['helpful'] ?? [];
    loveThis = json['loveThis'] ?? [];
    ohNo = json['ohNo'] ?? [];
    thanks = json['thanks'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['businessId'] = businessId;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['review'] = review;
    data['comment'] = comment;
    data['helpful'] = helpful;
    data['loveThis'] = loveThis;
    data['ohNo'] = ohNo;
    data['thanks'] = thanks;
    return data;
  }
}
