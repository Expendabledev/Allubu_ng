import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:allubmarket/models/business_model.dart';

class BusinessHistoryModel {
  String? id;
  Timestamp? createdAt;
  BusinessModel? business;

  BusinessHistoryModel({this.id, this.createdAt, this.business});

  BusinessHistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['createdAt'] != null
        ? Timestamp.fromMillisecondsSinceEpoch(json['createdAt'])
        : null;
    business = json['business'] != null
        ? BusinessModel.fromJson(json['business'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['createdAt'] = createdAt?.millisecondsSinceEpoch;
    data['business'] = business?.toJsonRecent();
    return data;
  }
}
