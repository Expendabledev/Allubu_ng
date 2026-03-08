import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/bookmarks_model.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/widgets/geoflutterfire/src/geoflutterfire.dart';
import 'package:yelpify/widgets/geoflutterfire/src/models/point.dart';

class CreateCollectionController extends GetxController {
  Rx<TextEditingController> collectionNameTextFieldController = TextEditingController().obs;
  Rx<TextEditingController> collectionDescriptionTextFieldController = TextEditingController().obs;

  RxBool isPublic = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> createMyBookmark() async {
    ShowToastDialog.showLoader("Please wait");
    BookmarksModel bookmarksModel = BookmarksModel();
    bookmarksModel.id = Constant.getUuid();
    bookmarksModel.name = collectionNameTextFieldController.value.text;
    bookmarksModel.description = collectionDescriptionTextFieldController.value.text;
    bookmarksModel.ownerId = FireStoreUtils.getCurrentUid();
    bookmarksModel.isDefault = false;
    bookmarksModel.isPrivate = isPublic.value == true ? false : true;
    bookmarksModel.createdAt = Timestamp.now();
    bookmarksModel.updatedAt = Timestamp.now();
    bookmarksModel.location = LatLngModel(latitude: Constant.currentLocation!.latitude.toString(),longitude:Constant.currentLocation!.longitude.toString() );
    GeoFirePoint position = Geoflutterfire().point(latitude: double.parse(Constant.currentLocation!.latitude.toString()), longitude: double.parse(Constant.currentLocation!.longitude.toString()));

    bookmarksModel.position = Positions(geoPoint: position.geoPoint, geoHash: position.hash);

    bookmarksModel.shareLinkCode = Constant.generateRandomCode(collectionNameTextFieldController.value.text
        .replaceAll(RegExp(r'[^a-zA-Z0-9 ]'), '') // Remove special characters
        .replaceAll(' ', '_'));
    await FireStoreUtils.createBookmarks(bookmarksModel);
    Get.back(result: true);
    ShowToastDialog.closeLoader();
  }
}
