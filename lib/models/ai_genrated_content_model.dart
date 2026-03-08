
import 'package:yelpify/models/category_model.dart';

class AiGeneratedContentContentModel {
  String? status;
  int? code;
  String? message;
  Data? data;

  AiGeneratedContentContentModel({this.status, this.code, this.message, this.data});

  AiGeneratedContentContentModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? title;
  String? description;
  List<CategoryModel>? category;
  String? keywords;

  Data({this.title, this.description, this.category, this.keywords});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    if (json['category'] != null) {
      category = <CategoryModel>[];
      json['category'].forEach((v) {
        category!.add(CategoryModel.fromJson(v));
      });
    }
    keywords = json['keywords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['description'] = description;
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    data['keywords'] = keywords;
    return data;
  }
}
