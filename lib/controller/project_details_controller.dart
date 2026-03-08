import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yelpify/constant/collection_name.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/pricing_request_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class ProjectDetailsController extends GetxController with GetSingleTickerProviderStateMixin {
  RxBool isLoading = true.obs;
  RxList<BusinessModel> businessList = <BusinessModel>[].obs;
  final ScrollController scrollController = ScrollController();
  late TabController tabController;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<PricingRequestModel> pricingRequestModel = PricingRequestModel().obs;

  Future<void> getArgument() async {
    tabController = TabController(length: 2, vsync: this);
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      pricingRequestModel.value = argumentData['pricingRequestModel'];
    }

    await getAllBusiness();
    print("===>");
    print(businessList.length);
    isLoading.value = false;
    update();
  }

  Future<void> getAllBusiness() async {
    final ids = pricingRequestModel.value.businessIds ?? [];
    final businesses = await Future.wait(
      ids.map((id) => FireStoreUtils.getBusinessById(id)),
    );

    businessList.addAll(businesses.whereType<BusinessModel>());
  }

  Stream<bool> checkStatus(BusinessModel businessModel) {
    return FireStoreUtils.fireStore
        .collection(CollectionName.projectRequest)
        .doc(pricingRequestModel.value.id)
        .collection("chat")
        .where("senderId", isEqualTo: businessModel.id)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty ? true : false);
  }

  Stream<int> getUnreadChatCount(BusinessModel businessModel) {
    return FireStoreUtils.fireStore
        .collection(CollectionName.projectRequest)
        .doc(pricingRequestModel.value.id)
        .collection("chat")
        .where("receiverId", isEqualTo: FireStoreUtils.getCurrentUid())
        .where("businessId", isEqualTo: businessModel.id)
        .where("isRead", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
