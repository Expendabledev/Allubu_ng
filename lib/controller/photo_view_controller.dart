import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:yelpify/models/photo_model.dart';
import 'package:yelpify/models/user_model.dart';

class PhotoViewController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<PhotoModel> photoList = <PhotoModel>[].obs;
  Rx<UserModel> userModel = UserModel().obs;

  late PageController pageController;

  RxInt initialIndex = 0.obs;

  @override
  void onInit() {
    getArgument();
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      photoList.value = argumentData['photoList'];
      initialIndex.value = argumentData['index'];
      pageController = PageController(initialPage: initialIndex.value);
      pageController.addListener(() {
        initialIndex.value = pageController.page!.toInt();
      },);
    }
    isLoading.value = false;
    update();
  }

  void updatePhoto(int index, PhotoModel reviewModel) {
    photoList.removeAt(index );
    photoList.insert(index, reviewModel);
  }
}
