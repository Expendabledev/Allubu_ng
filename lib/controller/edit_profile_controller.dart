import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class EditProfileController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> lastNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberTextFieldController = TextEditingController().obs;
  Rx<TextEditingController> countryCodeController = TextEditingController(text: Constant.defaultCountryCode).obs;
  Rx<TextEditingController> countryISOCodeController = TextEditingController(text: Constant.defaultCountryCode).obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid()).then((value) {
      if (value != null) {
        userModel.value = value;
        emailController.value.text = userModel.value.email.toString();
        firstNameController.value.text = userModel.value.firstName ?? '';
        lastNameController.value.text = userModel.value.lastName ?? '';
        profileImage.value = userModel.value.profilePic ?? '';
        countryCodeController.value.text = userModel.value.countryCode ?? '';
        countryISOCodeController.value.text = userModel.value.countryISOCode ?? Constant.defaultCountryCode;
        phoneNumberTextFieldController.value.text = userModel.value.phoneNumber ?? '';
        print("======>${userModel.value.countryCode!} :: ${profileImage.value}");
        isLoading.value = false;
      }
    });
  }

  final ImagePicker _imagePicker = ImagePicker();
  RxString profileImage = "".obs;

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      Get.back();
      profileImage.value = image.path;
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }
}
