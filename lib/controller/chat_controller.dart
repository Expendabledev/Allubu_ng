import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:yelpify/constant/collection_name.dart';
import 'package:yelpify/constant/send_notification.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/conversation_model.dart';
import 'package:yelpify/models/pricing_request_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class ChatController extends GetxController {
  Rx<TextEditingController> messageTextFieldController = TextEditingController().obs;

  Rx<BusinessModel> businessModel = BusinessModel().obs;
  Rx<PricingRequestModel> projectModel = PricingRequestModel().obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<String> isSender = ''.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      businessModel.value = argumentData['businessModel'];
      userModel.value = argumentData['userModel'];
      projectModel.value = argumentData['projectModel'];
      isSender.value = argumentData['isSender'];
      startListeningToUnreadChats();
    }
    update();
  }

  StreamSubscription? chatSubscription;

  void startListeningToUnreadChats() {
    chatSubscription = FireStoreUtils.fireStore
        .collection(CollectionName.projectRequest)
        .doc(projectModel.value.id)
        .collection("chat")
        .where("isRead", isEqualTo: false)
        .where("businessId", isEqualTo: businessModel.value.id)
        .orderBy('createdAt')
        .snapshots()
        .listen((snapshot) async {
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final chat = ConversationModel.fromJson(data);

        final isCurrentUserSender = isSender.value == "business" ? chat.senderId == businessModel.value.id : chat.senderId == FireStoreUtils.getCurrentUid();

        if (isCurrentUserSender == false) {
          // Only update if value actually changed
          chat.isRead = true;
          await FireStoreUtils.setProjectChat(chat); // Assuming this updates by chat.id
        }
      }
    });
  }

  void stopListeningToUnreadChats() {
    chatSubscription?.cancel();
    chatSubscription = null;
  }

  Future<void> sendMessage() async {
    if (messageTextFieldController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter a message");
      return;
    }
    ShowToastDialog.showLoader("Please wait...");
    ConversationModel conversationModel = ConversationModel(
      id: const Uuid().v4(),
      message: messageTextFieldController.value.text,
      senderId: isSender.value == "business" ? businessModel.value.id : userModel.value.id,
      receiverId: isSender.value == "business" ? userModel.value.id : businessModel.value.id,
      createdAt: Timestamp.now(),
      projectId: projectModel.value.id,
      isSender: isSender.value,
      businessId: businessModel.value.id,
      isRead: false,
      messageType: "text",
    );
    await FireStoreUtils.setProjectChat(conversationModel);

    if (isSender.value == "business") {
      Map<String, dynamic> playLoad = <String, dynamic>{
        "type": "project_chat",
        "isSender": isSender.value,
        "userId": userModel.value.id,
        "businessId": businessModel.value.id,
        "projectId": projectModel.value.id,
      };

      await SendNotification.sendOneNotification(
          token: userModel.value.fcmToken.toString(), title: "${businessModel.value.businessName}", body: messageTextFieldController.value.text, payload: playLoad);
    } else {
      await FireStoreUtils.getUserProfile(businessModel.value.ownerId.toString()).then(
        (value) {
          if (value != null) {
            Map<String, dynamic> playLoad = <String, dynamic>{
              "type": "project_chat",
              "isSender": isSender.value,
              "userId": userModel.value.id,
              "businessId": businessModel.value.id,
              "projectId": projectModel.value.id,
            };
            SendNotification.sendOneNotification(token: value.fcmToken.toString(), title: userModel.value.fullName(), body: messageTextFieldController.value.text, payload: playLoad);
          }
        },
      );
    }

    messageTextFieldController.value.clear();
    ShowToastDialog.closeLoader();
    // Wait for FirestorePagination to update, then scroll
    Future.delayed(const Duration(milliseconds: 400), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    stopListeningToUnreadChats();
    super.dispose();
  }
}
