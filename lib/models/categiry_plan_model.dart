import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allubmarket/models/category_model.dart';

class CategoryPlanModel {
  String? id;
  String? userId;
  CategoryModel? category;
  Timestamp? createdAt;

  CategoryPlanModel({this.id, this.category, this.createdAt, this.userId});

  CategoryPlanModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : CategoryModel();
    userId = json['userId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['createdAt'] = createdAt;
    return data;
  }
}
