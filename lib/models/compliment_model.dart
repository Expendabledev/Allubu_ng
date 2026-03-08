import 'package:cloud_firestore/cloud_firestore.dart';

class ComplimentModel {
  String? id;
  String? from;
  String? to;
  String? title;
  String? description;
  Timestamp? createdAt;

  ComplimentModel(
      {this.id,
        this.from,
        this.to,
        this.title,
        this.description,
        this.createdAt});

  ComplimentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    to = json['to'];
    title = json['title'];
    description = json['description'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from'] = from;
    data['to'] = to;
    data['title'] = title;
    data['description'] = description;
    data['createdAt'] = createdAt;
    return data;
  }
}
