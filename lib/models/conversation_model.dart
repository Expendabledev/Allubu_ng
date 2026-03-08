import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  String? id;
  String? senderId;
  String? receiverId;
  String? businessId;
  String? projectId;
  String? message;
  String? messageType;
  String? isSender;
  String? imageUrl;
  String? type;
  bool? isRead;
  Timestamp? createdAt;

  ConversationModel({
    this.id,
    this.senderId,
    this.receiverId,
    this.businessId,
    this.projectId,
    this.message,
    this.messageType,
    this.isSender,
    this.createdAt,
    this.imageUrl,
    this.isRead,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> parsedJson) {
    return ConversationModel(
      id: parsedJson['id'] ?? '',
      senderId: parsedJson['senderId'] ?? '',
      receiverId: parsedJson['receiverId'] ?? '',
      businessId: parsedJson['businessId'] ?? '',
      projectId: parsedJson['projectId'] ?? '',
      message: parsedJson['message'] ?? '',
      messageType: parsedJson['messageType'] ?? '',
      isSender: parsedJson['isSender'] ?? '',
      imageUrl: parsedJson['imageUrl'] ?? '',
      isRead: parsedJson['isRead'] ?? false,
      createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'businessId': businessId,
      'projectId': projectId,
      'message': message,
      'messageType': messageType,
      'createdAt': createdAt,
      'isSender': isSender,
      'imageUrl': imageUrl,
      'isRead': isRead,
    };
  }
}

class Url {
  String mime;

  String url;

  String? videoThumbnail;

  Url({this.mime = '', this.url = '', this.videoThumbnail});

  factory Url.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Url(mime: parsedJson['mime'] ?? '', url: parsedJson['url'] ?? '', videoThumbnail: parsedJson['videoThumbnail'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'mime': mime, 'url': url, 'videoThumbnail': videoThumbnail};
  }
}
