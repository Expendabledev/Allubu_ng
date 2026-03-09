import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/country_model.dart';
import 'package:allubmarket/models/item_model.dart';
import 'package:allubmarket/models/photo_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class AddMenuPhotoController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    // TODO: implement onInit
    super.onInit();
  }

  Rx<BusinessModel> businessModel = BusinessModel().obs;

  RxList<PhotoModel> menuPhotosList = <PhotoModel>[].obs;
  RxList<ItemModel> itemList = <ItemModel>[].obs;
  Rx<Currency> currency = Currency().obs;

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      businessModel.value = argumentData['businessModel'];
      await getBusinessData();
      await getMenuImages();
      await getItemList();
    }
    isLoading.value = false;
    update();
  }

  Future<void> getBusinessData() async {
    await FireStoreUtils.getBusinessById(businessModel.value.id.toString())
        .then(
      (value) {
        if (value != null) {
          businessModel.value = value;
          currency.value = Constant.countryModel!.countries!.firstWhere(
              (element) => element.dialCode == businessModel.value.countryCode);
        }
      },
    );
  }

  // Item get
  Future<void> getItemList() async {
    await FireStoreUtils.getItemList(businessModel.value.id.toString()).then(
      (value) {
        itemList.value = value;
      },
    );
  }

// Menu get and upload
  Future<void> getMenuImages() async {
    await FireStoreUtils.getAllPhotosByType(
            businessModel.value.id.toString(), "menuPhoto")
        .then(
      (value) {
        menuPhotosList.value = value;
      },
    );
  }

  Future<void> uploadMenuImage() async {
    ShowToastDialog.showLoader("Please wait");
    for (int i = 0; i < menuPhotosList.length; i++) {
      if (menuPhotosList[i].imageUrl.runtimeType == XFile) {
        String url = await Constant.uploadUserImageToFireStorage(
          File(menuPhotosList[i].imageUrl.path),
          "${businessModel.value.id}/${Constant.menuPhotos}",
          File(menuPhotosList[i].imageUrl.path).path.split('/').last,
        );
        PhotoModel uploadMenuModel = menuPhotosList[i];
        uploadMenuModel.id = Constant.getUuid();
        uploadMenuModel.imageUrl = url;
        uploadMenuModel.businessId = businessModel.value.id;
        uploadMenuModel.userId = FireStoreUtils.getCurrentUid();
        uploadMenuModel.type = "menuPhoto";
        uploadMenuModel.createdAt = Timestamp.now();

        await FireStoreUtils.addPhotos(uploadMenuModel);
      }
    }
    await getBusinessData();
    ShowToastDialog.showToast("Image upload successfully");
    ShowToastDialog.closeLoader();
    Get.back();
  }

  bool hasMenuPhotos() {
    if (businessModel.value.category == null ||
        businessModel.value.category!.isEmpty) {
      return false;
    }

    return businessModel.value.category!
        .any((category) => category.menuPhotos == true);
  }

  bool hasMenuItem() {
    if (businessModel.value.category == null ||
        businessModel.value.category!.isEmpty) {
      return false;
    }

    return businessModel.value.category!
        .any((category) => category.uploadItems == true);
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      menuPhotosList.add(PhotoModel(imageUrl: image));
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }
}
