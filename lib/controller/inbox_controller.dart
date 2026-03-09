import 'package:get/get.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class InboxController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> senderUserModel = UserModel().obs;

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  Future<void> getUser() async {
    await FireStoreUtils.getCurrentUserModel().then((value) {
      senderUserModel.value = value!;
    });
    isLoading.value = false;
  }
}
