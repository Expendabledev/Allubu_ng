import 'package:get/get.dart';
import 'package:yelpify/models/photo_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class UserPhotoController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<PhotoModel> photosList = <PhotoModel>[].obs;
  Rx<UserModel> userModel = UserModel().obs;


  @override
  void onInit() {
    // TODO: implement onInit
    getArguments();
    super.onInit();
  }

  Future<void> getArguments() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      userModel.value = argumentData['userModel'];
      await getUser();
      await getPhotos();
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

  Future<void> getPhotos() async {
    await FireStoreUtils.getAllPhotosByUserId(userModel.value.id.toString()).then(
      (value) {
        photosList.value = value;
        update();
      },
    );
  }

  void updateMenuPhoto(int index, PhotoModel reviewModel) {
    photosList.removeAt(index);
    photosList.insert(index, reviewModel);
  }
}
