import 'package:cloud_firestore/cloud_firestore.dart';

class SponsoredRequestModel {
  String? id;
  Timestamp? startDate;
  Timestamp? endDate;
  String? status;
  String? businessId;
  String? canceledNote;
  String? adminNote;
  String? userId;
  Timestamp? createdAt;

  SponsoredRequestModel(
      {this.id,
        this.startDate,
        this.endDate,
        this.status,
        this.businessId,
        this.canceledNote,
        this.adminNote,
        this.userId,
        this.createdAt});

  SponsoredRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    status = json['status'];
    businessId = json['businessId'];
    canceledNote = json['canceledNote'];
    adminNote = json['adminNote'];
    userId = json['userId'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['status'] = status;
    data['businessId'] = businessId;
    data['canceledNote'] = canceledNote;
    data['adminNote'] = adminNote;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    return data;
  }
}
