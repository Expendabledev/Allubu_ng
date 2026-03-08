import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';

class OtpController extends GetxController {
  Rx<TextEditingController> otpController = TextEditingController().obs;

  RxString countryCode = "".obs;
  RxString countryISOCode = "".obs;
  RxString phoneNumber = "".obs;
  RxString verificationId = "".obs;
  RxInt resendToken = 0.obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      countryCode.value = argumentData['countryCode'];
      countryISOCode.value = argumentData['countryISOCode'];
      phoneNumber.value = argumentData['phoneNumber'];
      verificationId.value = argumentData['verificationId'];
      resendToken.value = argumentData['resendToken'];
      log("getArgument :: ${countryCode.value} :: ${countryISOCode.value} :: ${phoneNumber.value} :: ${verificationId.value} :: ${resendToken.value}");
    }
    isLoading.value = false;
    update();
  }

  Future<bool> reSendOTP() async {
    try {
      ShowToastDialog.showLoader("Please wait");
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: countryCode.value + phoneNumber.value,
        forceResendingToken: resendToken.value, // ✅ Required for resend
        timeout: const Duration(minutes: 2),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-verification (mostly Android)
        },
        verificationFailed: (FirebaseAuthException e) {
          ShowToastDialog.showToast(e.message);
          throw Exception(e.message);
        },
        codeSent: (String vId, int? rToken) {
          ShowToastDialog.closeLoader();
          verificationId.value = vId;
          resendToken.value = rToken!; // 🔄 Update resend token
          ShowToastDialog.showToast('OTP resent successfully'.tr);
        },
        codeAutoRetrievalTimeout: (String vId) {
          verificationId.value = vId;
        },
      );

      return true;
    } catch (e) {
      print("Resend OTP failed: $e");
      return false;
    }
  }
}
