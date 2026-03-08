import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yelpify/constant/collection_name.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/send_notification.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/chat_model.dart';
import 'package:yelpify/models/inbox_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class UserChatController extends GetxController {
  final Rx<TextEditingController> messageTextEditorController = TextEditingController().obs;
  final ScrollController scrollController = ScrollController();

  RxBool isLoading = true.obs;
  Rx<UserModel> receiverUserModel = UserModel().obs;
  Rx<UserModel> senderUserModel = UserModel().obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      receiverUserModel.value = argumentData['receiverModel'];
      await FireStoreUtils.getCurrentUserModel().then((value) {
        senderUserModel.value = value!;
      });
    }

    changeStatus();

    isLoading.value = false;
    update();
  }

  Future<void> sendMessage() async {
    if (messageTextEditorController.value.text.isEmpty) {
      ShowToastDialog.showToast("Please enter a message");
      return;
    }
    InboxModel inboxModel = InboxModel(
        archive: false,
        lastMessage: messageTextEditorController.value.text.trim(),
        mediaUrl: "",
        receiverId: receiverUserModel.value.id.toString(),
        seen: false,
        senderId: senderUserModel.value.id.toString(),
        timestamp: Timestamp.now(),
        type: "text",
        chatType: receiverUserModel.value.id?.contains('admin') == true ? 'adminChat' : 'chat');

    await FireStoreUtils.fireStore.collection(CollectionName.userChat).doc(senderUserModel.value.id.toString()).collection("inbox").doc(receiverUserModel.value.id.toString()).set(inboxModel.toJson());

    await FireStoreUtils.fireStore.collection(CollectionName.userChat).doc(receiverUserModel.value.id.toString()).collection("inbox").doc(senderUserModel.value.id.toString()).set(inboxModel.toJson());

    ChatModel chatModel = ChatModel(
        type: "text",
        timestamp: Timestamp.now(),
        senderId: senderUserModel.value.id.toString(),
        seen: false,
        receiverId: receiverUserModel.value.id.toString(),
        mediaUrl: "",
        chatID: Constant.getUuid(),
        message: messageTextEditorController.value.text.trim(),
        chatType: receiverUserModel.value.id?.contains('admin') == true ? 'adminChat' : 'chat');

    await FireStoreUtils.fireStore
        .collection(CollectionName.userChat)
        .doc(senderUserModel.value.id.toString())
        .collection(receiverUserModel.value.id.toString())
        .doc(chatModel.chatID)
        .set(chatModel.toJson());

    await FireStoreUtils.fireStore
        .collection(CollectionName.userChat)
        .doc(receiverUserModel.value.id.toString())
        .collection(senderUserModel.value.id.toString())
        .doc(chatModel.chatID)
        .set(chatModel.toJson());

    Map<String, dynamic> playLoad = <String, dynamic>{
      "type": "user_chat",
      "senderId": senderUserModel.value.id.toString(),
      "receiverId": receiverUserModel.value.id.toString(),
    };

    SendNotification.sendOneNotification(
        token: receiverUserModel.value.fcmToken.toString(), title: receiverUserModel.value.fullName(), body: messageTextEditorController.value.text, payload: playLoad);
    messageTextEditorController.value.clear();
  }

  late StreamSubscription<QuerySnapshot> chatListner;

  void changeStatus() {
    chatListner = FireStoreUtils.fireStore
        .collection(CollectionName.userChat)
        .doc(senderUserModel.value.id.toString())
        .collection(receiverUserModel.value.id.toString())
        .where("seen", isEqualTo: false)
        .snapshots()
        .listen((documentSnapshot) {
      for (int i = 0; i < documentSnapshot.docs.length; i++) {
        if (documentSnapshot.docs[i]['senderId'] == senderUserModel.value.id.toString()) {
          // Update the sender's side to "seen" for the current message
          FireStoreUtils.fireStore
              .collection(CollectionName.userChat)
              .doc(documentSnapshot.docs[i]['senderId'])
              .collection(documentSnapshot.docs[i]['receiverId'])
              .doc(documentSnapshot.docs[i]['chatID'])
              .update({'seen': true}).catchError((error) {
            log("Failed to update seen status: $error");
          });

          // Update the inbox for the sender to mark it as "seen"
          FireStoreUtils.fireStore
              .collection(CollectionName.userChat)
              .doc(documentSnapshot.docs[i]['senderId'])
              .collection("inbox")
              .doc(documentSnapshot.docs[i]['receiverId'])
              .update({'seen': true}).catchError((error) {
            log("Failed to update inbox: $error");
          });
        } else {
          FireStoreUtils.fireStore
              .collection(CollectionName.userChat)
              .doc(documentSnapshot.docs[i]['receiverId'])
              .collection(documentSnapshot.docs[i]['senderId'])
              .doc(documentSnapshot.docs[i]['chatID'])
              .update({'seen': true}).catchError((error) {
            log("Failed : $error");
          });

          FireStoreUtils.fireStore.collection(CollectionName.userChat).doc(documentSnapshot.docs[i]['receiverId']).collection("inbox").doc(documentSnapshot.docs[i]['senderId']).update({
            'seen': true,
          }).catchError((error) {
            log("Failed to add: $error");
          });
        }
      }
    });
  }

  @override
  void dispose() {
    chatListner.cancel();
    super.dispose();
  }
}
