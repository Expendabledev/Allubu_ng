import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/bookmarks_model.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/compliment_model.dart';
import 'package:yelpify/models/photo_model.dart';
import 'package:yelpify/models/recommend_model.dart';
import 'package:yelpify/models/review_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class ProfileController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<UserModel> userModel = UserModel().obs;
  RxList<BusinessModel> myBusinessList = <BusinessModel>[].obs;
  RxList<PhotoModel> photoList = <PhotoModel>[].obs;
  RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
  RxList<BookmarksModel> bookMarkList = <BookmarksModel>[].obs;
  RxList<ComplimentModel> complimentsList = <ComplimentModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  Future<void> getData() async {
    await getUser();
    await getBusiness();
    isLoading.value = false;
  }

  RxList<BusinessModel> suggestedBusinessList = <BusinessModel>[].obs;
  RxList<UserModel> followingList = <UserModel>[].obs;

  Future getBusiness() async {
    FireStoreUtils.getAllSuggestedBusiness(Constant.currentLocation == null
            ? LatLng(Constant.currentLocationLatLng!.latitude, Constant.currentLocationLatLng!.longitude)
            : LatLng(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude))
        .listen((event) async {
      suggestedBusinessList.clear();
      suggestedBusinessList.addAll(event);
    });

    update();
  }

  Future<void> getUser() async {
    if (FireStoreUtils.getCurrentUid() != '') {
      await FireStoreUtils.getCurrentUserModel().then(
        (value) {
          if (value != null) {
            userModel.value = value;
          }
        },
      );
    }

    myBusinessList.value = await FireStoreUtils.getMyBusiness();
    photoList.value = await FireStoreUtils.getAllPhotosByUserId(FireStoreUtils.getCurrentUid());
    reviewList.value = await FireStoreUtils.getReviewsNyUserId(FireStoreUtils.getCurrentUid());
    bookMarkList.value = await FireStoreUtils.getBookmarks(FireStoreUtils.getCurrentUid());
    followingList.value = await FireStoreUtils.getFollowing(FireStoreUtils.getCurrentUid());
    complimentsList.value = await FireStoreUtils.getComplimentList(FireStoreUtils.getCurrentUid());
  }

  Future<void> updateRecommended(String vote, BusinessModel businessModel) async {
    ShowToastDialog.showLoader("Please wait");
    RecommendModel model = RecommendModel();
    model.id = Constant.getUuid();
    model.businessId = businessModel.id;
    model.userId = FireStoreUtils.getCurrentUid();
    model.vote = vote;

    businessModel.recommendUserId!.add(FireStoreUtils.getCurrentUid());
    await FireStoreUtils.addRecommended(model);
    await FireStoreUtils.addBusiness(businessModel);
    await getBusiness();
    update();
    ShowToastDialog.closeLoader();
  }
}
