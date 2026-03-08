import 'package:cloud_firestore/cloud_firestore.dart';

class HighlightModel {
  String? name;
  bool? publish;
  String? id;
  String? title;
  String? photo;
  Timestamp? createdAt;

  HighlightModel({this.name, this.publish, this.id, this.title, this.createdAt, this.photo});

  HighlightModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    publish = json['publish'];
    id = json['id'];
    title = json['title'];
    createdAt = json['createdAt'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['publish'] = publish;
    data['id'] = id;
    data['title'] = title;
    data['createdAt'] = createdAt;
    data['photo'] = photo;
    return data;
  }
}
