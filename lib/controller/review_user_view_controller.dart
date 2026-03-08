import 'package:get/get.dart';
import 'package:yelpify/models/photo_model.dart';
import 'package:yelpify/models/review_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class ReviewUserViewController extends GetxController {
  var userMap = <String, UserModel>{}.obs;
  var allPhotoMap = <String, List<PhotoModel>>{}.obs;
  var reviewMap = <String, List<ReviewModel>>{}.obs;

  Future<void> fetchUser(String userId) async {
    if (!userMap.containsKey(userId)) {
      UserModel? user = await FireStoreUtils.getUserProfile(userId);
      if (user != null) {
        userMap[userId] = user;
      }
    }
  }

  Future<void> fetchReview(String userId) async {
    if (!reviewMap.containsKey(userId)) {
      List<ReviewModel>? user = await FireStoreUtils.getReviewsNyUserId(userId);
      if (user.isNotEmpty) {
        reviewMap[userId] = user;
      }
    }
  }

  Future<void> getAllPhoto(String userId) async {
    if (!allPhotoMap.containsKey(userId)) {
      List<PhotoModel>? user = await FireStoreUtils.getAllPhotosByUserId(userId);
      if (user.isNotEmpty) {
        allPhotoMap[userId] = user;
      }
    }
  }

  var photoMap = <String, List<PhotoModel>>{}.obs; // Caches review images
  Future<void> loadReviewImages(String reviewId) async {

    if (photoMap.containsKey(reviewId)) return; // Prevent duplicate fetches

    List<PhotoModel> photos = await FireStoreUtils.getReviewImage(reviewId);

    photoMap[reviewId] = photos; // Store fetched images
  }
}
