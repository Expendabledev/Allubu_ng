import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yelpify/models/business_model.dart';

class EditAddressController extends GetxController {
  Rx<TextEditingController> addressOneTextFieldController = TextEditingController().obs;
  Rx<TextEditingController> addressTwoFieldController = TextEditingController().obs;
  Rx<TextEditingController> addressThreeFieldController = TextEditingController().obs;

  Rx<AddressModel> address = AddressModel().obs;
  Rx<LatLngModel> location = LatLngModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      address.value = argumentData['address'];
      location.value = argumentData['location'];

      addressOneTextFieldController.value.text = address.value.street ?? '';
      addressTwoFieldController.value.text = address.value.locality ?? '';
      addressThreeFieldController.value.text = address.value.postalCode ?? '';
    }
    update();
  }
}
