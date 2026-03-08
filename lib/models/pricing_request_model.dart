import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yelpify/models/category_model.dart';

class PricingRequestModel {
  String? id;
  List<dynamic>? businessIds;
  CategoryModel? category;
  String? userId;
  String? description;
  String? status;
  List<dynamic>? images;
  Timestamp? createdAt;

  PricingRequestModel({
    this.id,
    this.businessIds,
    this.userId,
    this.description,
    this.status,
    this.images,
    this.createdAt,
    this.category,
  });

  PricingRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessIds = json['businessIds'] ?? [];
    userId = json['userId'];
    description = json['description'];
    images = json['images'].cast<String>();
    createdAt = json['createdAt'];
    status = json['status'];
    category = json['category'] != null ? CategoryModel.fromJson(json['category']) : CategoryModel();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['businessIds'] = businessIds;
    data['userId'] = userId;
    data['description'] = description;
    data['images'] = images;
    data['createdAt'] = createdAt;
    data['status'] = status;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    return data;
  }
}
