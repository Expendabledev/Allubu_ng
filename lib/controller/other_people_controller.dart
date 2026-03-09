import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/send_notification.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/models/bookmarks_model.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/compliment_model.dart';
import 'package:allubmarket/models/photo_model.dart';
import 'package:allubmarket/models/review_model.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class OtherPeopleController extends GetxController {
  final List<String> items = [
    'Thank you!',
    'You’re awesome!',
    'You’re amazing!',
    'You rock!',
    'You’re the best!',
    'Hot stuff',
    'You’ve got style',
    'You’re cool 😎',
    'Big brain energy 🧠',
    'Sunshine in human form ☀️',
    'Pure magic ✨'
  ];
  Rx<TextEditingController> complimentTextFieldController =
      TextEditingController().obs;

  RxInt selectedIndex = 4.obs;

  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;

  RxList<BusinessModel> myBusinessList = <BusinessModel>[].obs;
  RxList<PhotoModel> photoList = <PhotoModel>[].obs;
  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
  RxList<BookmarksModel> bookMarkList = <BookmarksModel>[].obs;
  RxList<UserModel> followingList = <UserModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
      await getUser();
      await getComplimentList();
      await getData();
    }
    update();
    isLoading.value = false;
  }

  Future<void> getUser() async {
    await FireStoreUtils.getUserProfile(userModel.value.id.toString()).then(
      (value) {
        if (value != null) {
          userModel.value = value;
        }
      },
    );
    getComplimentList();
  }

  Future<void> getData() async {
    myBusinessList.value =
        await FireStoreUtils.getBusinessListById(userModel.value.id.toString());
    photoList.value = await FireStoreUtils.getAllPhotosByUserId(
        userModel.value.id.toString());
    reviewList.value =
        await FireStoreUtils.getReviewsNyUserId(userModel.value.id.toString());
    bookMarkList.value =
        await FireStoreUtils.getBookmarks(userModel.value.id.toString());
    followingList.value =
        await FireStoreUtils.getFollowing(userModel.value.id.toString());
  }

  Future<void> followUser() async {
    ShowToastDialog.showLoader("Please wait");
    userModel.value.followers!.add(FireStoreUtils.getCurrentUid());
    await FireStoreUtils.updateUser(userModel.value);
    await getUser();
    Map<String, dynamic> playLoad = <String, dynamic>{
      "type": "user_follow",
      "userId": FireStoreUtils.getCurrentUid(),
    };

    UserModel? userModel0 =
        await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid());

    await SendNotification.sendOneNotification(
        token: userModel.value.fcmToken.toString(),
        title: userModel0!.fullName(),
        body: "You have a new follower!",
        payload: playLoad);
    ShowToastDialog.closeLoader();
    update();
  }

  Future<void> unfollow() async {
    ShowToastDialog.showLoader("Please wait");
    userModel.value.followers!.remove(FireStoreUtils.getCurrentUid());
    await FireStoreUtils.updateUser(userModel.value);
    await getUser();
    ShowToastDialog.closeLoader();
    update();
  }

  Future<void> sendCompliment() async {
    ShowToastDialog.showLoader("Please wait");
    ComplimentModel model = ComplimentModel();
    model.id = Constant.getUuid();
    model.title = items[selectedIndex.value];
    model.description = complimentTextFieldController.value.text;
    model.createdAt = Timestamp.now();
    model.from = FireStoreUtils.getCurrentUid();
    model.to = userModel.value.id;

    await FireStoreUtils.setCompliment(model);
    await getComplimentList();
    ShowToastDialog.closeLoader();
    Get.back();
  }

  RxList<ComplimentModel> complimentsList = <ComplimentModel>[].obs;

  Future<void> getComplimentList() async {
    await FireStoreUtils.getComplimentList(userModel.value.id.toString()).then(
      (value) {
        complimentsList.value = value;
      },
    );
  }
}
