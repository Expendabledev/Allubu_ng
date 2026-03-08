import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String? id;
  String? title;
  String? description;
  String? type;
  Timestamp? createdAt;
  String? status;
  String? from;
  String? to;
  String? postId;

  ReportModel({this.id, this.title, this.description, this.type, this.createdAt, this.status, this.from,this.to,this.postId});

  ReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    createdAt = json['createdAt'];
    status = json['status'];
    from = json['from'];
    to = json['to'];
    postId = json['postId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['type'] = type;
    data['createdAt'] = createdAt;
    data['status'] = status;
    data['from'] = from;
    data['to'] = to;
    data['postId'] = postId;
    return data;
  }
}
