import 'package:get/get.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class InboxController extends GetxController{

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