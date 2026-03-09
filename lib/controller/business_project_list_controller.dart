import 'package:get/get.dart';
import 'package:allubmarket/constant/collection_name.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/pricing_request_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class BusinessProjectListController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<BusinessModel> businessModel = BusinessModel().obs;
  RxList<PricingRequestModel> activeSentRequest = <PricingRequestModel>[].obs;

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
      await getProjectList();
    }
    isLoading.value = false;
    update();
  }

  Future<void> getProjectList() async {
    await FireStoreUtils.getProjectList(businessModel.value).then(
      (value) {
        activeSentRequest.value = value;
      },
    );
  }

  Stream<bool> checkStatus(PricingRequestModel projectRequestModel) {
    return FireStoreUtils.fireStore
        .collection(CollectionName.projectRequest)
        .doc(projectRequestModel.id)
        .collection("chat")
        .where("senderId", isEqualTo: businessModel.value.id)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty ? true : false);
  }

  Stream<int> getUnreadChatCount(PricingRequestModel projectRequestModel) {
    return FireStoreUtils.fireStore
        .collection(CollectionName.projectRequest)
        .doc(projectRequestModel.id)
        .collection("chat")
        .where("receiverId", isEqualTo: businessModel.value.id)
        .where("isRead", isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
