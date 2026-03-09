import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allubmarket/constant/collection_name.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/models/categiry_plan_model.dart';
import 'package:allubmarket/models/pricing_request_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

import '../models/category_model.dart';

class SeeAllProjectController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isLoading = true.obs;
  RxString type = ''.obs;
  late TabController tabController;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    getAddPlanList();
    super.onInit();
  }

  void getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      type.value = argumentData['type'];
      tabController = TabController(
          length: 3, vsync: this, initialIndex: type.value == "planed" ? 1 : 0);
    }
    update();
  }

  RxList<CategoryPlanModel> categoryPlanList = <CategoryPlanModel>[].obs;
  RxList<PricingRequestModel> pricingRequestList = <PricingRequestModel>[].obs;
  RxList<PricingRequestModel> archivedPricingRequestList =
      <PricingRequestModel>[].obs;

  Future<void> getAddPlanList() async {
    await FireStoreUtils.getCategoryPlaned().then(
      (value) {
        categoryPlanList.value = value;
      },
    );
    await getAllActiveRequest();
    isLoading.value = false;
  }

  Future<void> getAllActiveRequest() async {
    await FireStoreUtils.getPricingActiveList().then(
      (value) {
        pricingRequestList.value = value
            .where(
              (element) => element.status == "active",
            )
            .toList();
        archivedPricingRequestList.value = value
            .where(
              (element) => element.status == "archive",
            )
            .toList();
      },
    );
  }

  Future<void> removePlan(CategoryModel categoryModel) async {
    ShowToastDialog.showLoader("Please wait");
    CategoryPlanModel categoryPlanModel = categoryPlanList.firstWhere(
      (element) => element.category!.slug == categoryModel.slug,
    );
    await FireStoreUtils.removeCategoryPlaned(categoryPlanModel);
    await getAddPlanList();
    ShowToastDialog.closeLoader();
  }

  Stream<bool> checkStatus(PricingRequestModel projectRequestModel) {
    return FireStoreUtils.fireStore
        .collection(CollectionName.projectRequest)
        .doc(projectRequestModel.id)
        .collection("chat")
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty ? true : false);
  }

  Stream<int> getUnreadChatCount(PricingRequestModel projectRequestModel) {
    return FireStoreUtils.fireStore
        .collection(CollectionName.projectRequest)
        .doc(projectRequestModel.id)
        .collection("chat")
        .where("receiverId", isEqualTo: FireStoreUtils.getCurrentUid())
        .where("isRead", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
