import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allubmarket/app/photo_screen/photo_view_screen.dart';
import 'package:allubmarket/controller/review_user_view_controller.dart';
import 'package:allubmarket/models/photo_model.dart';
import 'package:allubmarket/utils/network_image_widget.dart';

class ReviewPhotoView extends StatelessWidget {
  final String reviewId;
  final ReviewUserViewController userController =
      Get.put(ReviewUserViewController());

  ReviewPhotoView({super.key, required this.reviewId});

  @override
  Widget build(BuildContext context) {
    userController.loadReviewImages(reviewId);
    return Obx(() {
      List<PhotoModel>? photos = userController.photoMap[reviewId];

      if (photos == null) {
        return Center(child: CircularProgressIndicator()); // Loading state
      } else if (photos.isEmpty) {
        return SizedBox(); // Empty state
      }

      return SizedBox(
        height: 80,
        child: ListView.builder(
          itemCount: photos.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.to(PhotoViewScreen(),
                    arguments: {"photoList": photos, "index": index});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: NetworkImageWidget(
                    width: 80,
                    imageUrl: photos[index].imageUrl.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
