import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/bookmarks_model.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/widgets/geoflutterfire/src/geoflutterfire.dart';
import 'package:yelpify/widgets/geoflutterfire/src/models/point.dart';

class CollectionViewController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<TextEditingController> collectionNameTextFieldController = TextEditingController().obs;
  Rx<TextEditingController> collectionDescriptionTextFieldController = TextEditingController().obs;

  RxBool isPublic = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<BookmarksModel> bookmarkModel = BookmarksModel().obs;
  Rx<UserModel> userModel = UserModel().obs;

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookmarkModel.value = argumentData['bookmarkModel'];
      collectionNameTextFieldController.value.text = bookmarkModel.value.name.toString();
      collectionDescriptionTextFieldController.value.text = bookmarkModel.value.description.toString();
      isPublic.value = bookmarkModel.value.isPrivate == true ? false : true;
      await getUser();
    }
    isLoading.value = false;
    update();
  }

  Future<void> getCollection() async {
    await FireStoreUtils.getBookmarksById(bookmarkModel.value.id.toString()).then(
      (value) {
        if (value != null) {
          bookmarkModel.value = value;
        }
      },
    );
  }

  Future<void> getUser() async {
    await FireStoreUtils.getUserProfile(bookmarkModel.value.ownerId.toString()).then(
      (value) {
        if (value != null) {
          userModel.value = value;
        }
      },
    );
  }

  Future<void> updateMyBookmark() async {
    ShowToastDialog.showLoader("Please wait");
    bookmarkModel.value.name = collectionNameTextFieldController.value.text;
    bookmarkModel.value.description = collectionDescriptionTextFieldController.value.text;
    bookmarkModel.value.ownerId = FireStoreUtils.getCurrentUid();
    bookmarkModel.value.isDefault = false;
    bookmarkModel.value.isPrivate = isPublic.value == true ? false : true;
    bookmarkModel.value.updatedAt = Timestamp.now();
    bookmarkModel.value.location = LatLngModel(latitude: Constant.currentLocation!.latitude.toString(),longitude:Constant.currentLocation!.longitude.toString() );
    GeoFirePoint position  = Geoflutterfire().point(latitude: double.parse(Constant.currentLocation!.latitude.toString()), longitude: double.parse(Constant.currentLocation!.longitude.toString()));

    bookmarkModel.value.position = Positions(geoPoint: position.geoPoint, geoHash: position.hash);

    await FireStoreUtils.createBookmarks(bookmarkModel.value);
    await getCollection();
    Get.back();
    ShowToastDialog.closeLoader();
  }
}
