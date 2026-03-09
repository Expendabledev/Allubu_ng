import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/item_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

import '../constant/show_toast_dialog.dart';

class AddItemManuallyController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<TextEditingController> nameTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> descriptionTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> priceTextFieldController =
      TextEditingController().obs;
  RxList images = <dynamic>[].obs;

  Rx<BusinessModel> businessModel = BusinessModel().obs;
  Rx<ItemModel> itemModel = ItemModel().obs;

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
      itemModel.value = argumentData['itemModel'];
      if (itemModel.value.id != null) {
        nameTextFieldController.value.text = itemModel.value.name.toString();
        descriptionTextFieldController.value.text =
            itemModel.value.description.toString();
        priceTextFieldController.value.text = itemModel.value.price.toString();
        images.value = itemModel.value.images ?? [];
      }
    }
    isLoading.value = false;
    update();
  }

  Future<void> saveItem() async {
    ShowToastDialog.showLoader("Please wait");
    for (int i = 0; i < images.length; i++) {
      if (images[i].runtimeType == XFile) {
        String url = await Constant.uploadUserImageToFireStorage(
          File(images[i].path),
          "${businessModel.value.id}/${Constant.menuItemPhotos}",
          File(images[i].path).path.split('/').last,
        );
        images.removeAt(i);
        images.insert(i, url);
      }
    }

    itemModel.value.id = Constant.getUuid();
    itemModel.value.name = nameTextFieldController.value.text;
    itemModel.value.description = descriptionTextFieldController.value.text;
    itemModel.value.price = priceTextFieldController.value.text;
    itemModel.value.images = images;

    await FireStoreUtils.uploadItem(
            businessModel.value.id.toString(), itemModel.value)
        .then(
      (value) {
        ShowToastDialog.closeLoader();
        Get.back(result: true);
        ShowToastDialog.showToast("Item added successfully");
      },
    );
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
