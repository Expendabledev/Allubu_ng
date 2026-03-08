import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:yelpify/constant/collection_name.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/categiry_plan_model.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/models/pricing_request_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class ProjectController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    await getUser();
  }

  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;

  RxList<CategoryPlanModel> categoryPlanList = <CategoryPlanModel>[].obs;
  RxList<PricingRequestModel> activeSentRequest = <PricingRequestModel>[].obs;

  Future<void> getUser() async {
    await FireStoreUtils.getCurrentUserModel().then(
      (value) {
        if (value != null) {
          userModel.value = value;
        }
      },
    );

    await FireStoreUtils.getProjectCategory().then(
      (value) {
        categoryList.value = value;
      },
    );
    await getAddPlanList();
    await getAllActiveRequest();
    isLoading.value = false;
  }

  Future<void> getAddPlanList() async {
    await FireStoreUtils.getCategoryPlaned().then(
      (value) {
        categoryPlanList.value = value;
      },
    );
  }

  Future<void> getAllActiveRequest() async {
    await FireStoreUtils.getPricingActiveList().then(
      (value) {
        activeSentRequest.value = value;
      },
    );
  }

  Future<void> addAsPlan(CategoryModel categoryModel) async {
    ShowToastDialog.showLoader("Please wait");
    CategoryPlanModel model = CategoryPlanModel();
    model.id = Constant.getUuid();
    model.userId = FireStoreUtils.getCurrentUid();
    model.category = categoryModel;
    model.createdAt = Timestamp.now();

    await FireStoreUtils.setCategoryPlaned(model);
    await getAddPlanList();
    ShowToastDialog.closeLoader();
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
    return FireStoreUtils.fireStore.collection(CollectionName.projectRequest).doc(projectRequestModel.id).collection("chat").snapshots().map((snapshot) => snapshot.docs.isNotEmpty ? true : false);
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
