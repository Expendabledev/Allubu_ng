import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/sponsored_request_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class SponsoredController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<TextEditingController> noteTextFieldController = TextEditingController().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getSponsoredPackage();
    super.onInit();
  }

  Rx<UserModel> userModel = UserModel().obs;

  RxList<BusinessModel> businessList = <BusinessModel>[].obs;
  Rx<BusinessModel> selectedBusiness = BusinessModel().obs;

  Rx<DateTime> startValidityDate = DateTime.now().obs;
  Rx<DateTime> endValidityDate = DateTime.now().obs;

  Future<void> getSponsoredPackage() async {
    await FireStoreUtils.getCurrentUserModel().then(
      (value) {
        if (value != null) {
          userModel.value = value;
        }
      },
    );

    await FireStoreUtils.getOwnerBusinessListById(userModel.value.id.toString()).then(
      (value) {
        businessList.value = value;
        if (businessList.isNotEmpty) {
          selectedBusiness.value = businessList.first;
        }
      },
    );

    isLoading.value = false;
  }

  Future<void> sentSponsoredRequest() async {
    ShowToastDialog.showLoader("Please wait");
    SponsoredRequestModel sponsoredRequestModel = SponsoredRequestModel();
    sponsoredRequestModel.id = Constant.getUuid();
    sponsoredRequestModel.businessId = selectedBusiness.value.id;
    sponsoredRequestModel.startDate = Timestamp.fromDate(DateTime(startValidityDate.value.year, startValidityDate.value.month, startValidityDate.value.day, 0, 0, 0));
    sponsoredRequestModel.endDate = Timestamp.fromDate(DateTime(endValidityDate.value.year, endValidityDate.value.month, endValidityDate.value.day, 0, 0, 0));
    sponsoredRequestModel.status = 'Pending';
    sponsoredRequestModel.createdAt = Timestamp.fromDate(DateTime.now());
    sponsoredRequestModel.adminNote = noteTextFieldController.value.text;
    sponsoredRequestModel.userId = userModel.value.id;
    await FireStoreUtils.addSponsoredRequest(sponsoredRequestModel).then(
      (value) {
        Get.back();
        ShowToastDialog.showToast("Request Sent Successfully");
      },
    );
  }
}
