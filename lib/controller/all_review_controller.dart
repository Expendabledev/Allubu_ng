import 'package:get/get.dart';
import 'package:yelpify/models/review_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class AllReviewController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;

  @override
  void onInit() {
    getAllReview();
    super.onInit();
  }

  Future<void> getAllReview() async {
    await FireStoreUtils.getReviewsNyUserId(FireStoreUtils.getCurrentUid()).then(
      (value) {
        reviewList.value = value;
      },
    );
    isLoading.value = false;
  }
}
