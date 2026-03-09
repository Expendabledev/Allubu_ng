import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/models/bookmarks_model.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class CollectionDetailsController extends GetxController {
  var isLoading = true.obs; // Loading state

  Rx<BookmarksModel> bookmarkModel = BookmarksModel().obs;
  final ScrollController scrollController = ScrollController();
  RxList<BusinessModel> businessList = <BusinessModel>[].obs;
  RxBool isExpanded = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookmarkModel.value = argumentData['bookmarkModel'];
      await getAllRestaurants();
      await getBookMark();
    }
    isLoading.value = false;
    update();
  }

  Future<void> getBookMark() async {
    await FireStoreUtils.getBookmarksById(bookmarkModel.value.id.toString())
        .then(
      (value) {
        if (value != null) {
          bookmarkModel.value = value;
        }
      },
    );
  }

  Future<void> collectionUpdate() async {
    ShowToastDialog.showLoader("Please wait");
    if (bookmarkModel.value.followers!
        .contains(FireStoreUtils.getCurrentUid())) {
      bookmarkModel.value.followers!.remove(FireStoreUtils.getCurrentUid());
    } else {
      bookmarkModel.value.followers!.add(FireStoreUtils.getCurrentUid());
    }
    await FireStoreUtils.createBookmarks(bookmarkModel.value);
    await getBookMark();
    ShowToastDialog.closeLoader();
    update();
  }

  Future<void> getAllRestaurants() async {
    final ids = bookmarkModel.value.businessIds ?? [];
    final businesses = await Future.wait(
      ids.map((id) => FireStoreUtils.getBusinessById(id)),
    );

    businessList.addAll(businesses.whereType<BusinessModel>());
  }
}
