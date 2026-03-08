import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/check_in_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class AddCheckInController extends GetxController {
  Rx<TextEditingController> commentTextFieldController = TextEditingController().obs;
  RxBool isLoading = true.obs;
  Rx<BusinessModel> businessModel = BusinessModel().obs;
  RxList images = <dynamic>[].obs;
  RxBool shareWithFriends = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      businessModel.value = argumentData['businessModel'];
    }
    isLoading.value = false;
    update();
  }

  Future<void> checkIn() async {
    final distance = Constant.calculateDistance(
      Constant.currentLocation == null ? Constant.currentLocationLatLng!.latitude : Constant.currentLocation!.latitude,
      Constant.currentLocation == null ? Constant.currentLocationLatLng!.longitude : Constant.currentLocation!.longitude,
      double.parse(businessModel.value.location!.latitude!),
      double.parse(businessModel.value.location!.longitude!),
    );

    if (distance < double.parse(Constant.checkInRadius)) {
      ShowToastDialog.showLoader("Please wait");
      for (int i = 0; i < images.length; i++) {
        if (images[i].runtimeType == XFile) {
          String url = await Constant.uploadUserImageToFireStorage(
            File(images[i].path),
            "${businessModel.value.id}/${Constant.checkInPhotos}",
            File(images[i].path).path.split('/').last,
          );
          images.removeAt(i);
          images.insert(i, url);
        }
      }

      CheckInModel checkInModel = CheckInModel();
      checkInModel.id = Constant.getUuid();
      checkInModel.userId = FireStoreUtils.getCurrentUid();
      checkInModel.createdAt = Timestamp.now();
      checkInModel.description = commentTextFieldController.value.text;
      checkInModel.images = images;
      checkInModel.shareWithFriend = shareWithFriends.value;
      checkInModel.businessId = businessModel.value.id;
      checkInModel.location = LatLngModel(
          latitude: (Constant.currentLocation == null ? Constant.currentLocationLatLng!.latitude : Constant.currentLocation!.latitude).toString(),
          longitude: (Constant.currentLocation == null ? Constant.currentLocationLatLng!.longitude : Constant.currentLocation!.longitude).toString());

      await FireStoreUtils.setCheckIn(checkInModel).then(
        (value) {
          ShowToastDialog.showToast("Check in successfully");
          ShowToastDialog.closeLoader();
          Get.back();
        },
      );
    } else {
      ShowToastDialog.showToast("You are not in check in radius");
    }
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      images.add(image);
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }
}
