import 'package:get/get.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class FollowersListController extends GetxController {
  RxBool isLoading = true.obs;

  Rx<UserModel> userModel = UserModel().obs;

  RxBool myProfile = false.obs;
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
      myProfile.value = argumentData['myProfile'] ?? false;

      await getUser();
    }
    update();
    isLoading.value = false;
  }

  Future<void> getUser() async {
    await FireStoreUtils.getUserProfile(userModel.value.id.toString()).then(
      (value) {
        if (value != null) {
          userModel.value = value;
        }
      },
    );
  }

  Future<void> unfollow() async {
    ShowToastDialog.showLoader("Please wait");
    userModel.value.followers!.remove(FireStoreUtils.getCurrentUid());
    await FireStoreUtils.updateUser(userModel.value);
    await getUser();
    ShowToastDialog.closeLoader();
    update();
  }
}
