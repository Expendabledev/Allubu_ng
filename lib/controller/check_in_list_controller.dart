import 'package:get/get.dart';
import 'package:allubmarket/models/check_in_model.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class CheckInListController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<CheckInModel> checkInList = <CheckInModel>[].obs;

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
    }
    await getCheckIn();
    isLoading.value = false;
    update();
  }

  Future<void> getCheckIn() async {
    await FireStoreUtils.getCheckIn(userModel.value.id.toString()).then(
      (value) {
        checkInList.value = value;
      },
    );
  }
}
