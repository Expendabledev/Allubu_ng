import 'package:get/get.dart';
import 'package:allubmarket/models/compliment_model.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class ComplimentsListController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
      await getComplimentList();
    }
    update();
    isLoading.value = false;
  }

  RxList<ComplimentModel> complimentsList = <ComplimentModel>[].obs;

  Future<void> getComplimentList() async {
    complimentsList.clear();
    await FireStoreUtils.getComplimentList(userModel.value.id.toString()).then(
      (value) {
        complimentsList.value = value;
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
