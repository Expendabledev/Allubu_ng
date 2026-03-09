import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allubmarket/models/category_model.dart';

class CategoryHistoryModel {
  String? id;
  Timestamp? createdAt;
  CategoryModel? category;

  CategoryHistoryModel({this.id, this.createdAt, this.category});

  CategoryHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'] != null
        ? Timestamp.fromMillisecondsSinceEpoch(json['createdAt'])
        : null;
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['createdAt'] = createdAt?.millisecondsSinceEpoch;
    data['category'] = category?.toJson();
    return data;
  }
}
