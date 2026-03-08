import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/review_user_view_controller.dart';
import 'package:yelpify/models/photo_model.dart';
import 'package:yelpify/models/review_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/network_image_widget.dart';

class ReviewUserView extends StatelessWidget {
  final String userId;
  final ReviewUserViewController userController = Get.put(ReviewUserViewController());

  ReviewUserView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    userController.fetchUser(userId); // Fetch user only if not already in cache
    userController.fetchReview(userId); // Fetch user only if not already in cache
    userController.getAllPhoto(userId); // Fetch user only if not already in cache
    return Obx(() {
      if (!userController.userMap.containsKey(userId)) {
        return Center(child: CircularProgressIndicator());
      }
      UserModel userModel = userController.userMap[userId]!;
      List<PhotoModel> photoList = userController.allPhotoMap[userId] ?? [];
      List<ReviewModel> reviewList = userController.reviewMap[userId] ?? [];
      return Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: NetworkImageWidget(
                imageUrl: userModel.profilePic.toString(),
                errorWidget: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Constant.svgPictureShow("assets/icons/user.svg", themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04, 30, 30),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.fullName(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey04,
                    fontSize: 14,
                    fontFamily: AppThemeData.boldOpenSans,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        Constant.svgPictureShow("assets/icons/icon_user-business.svg", themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05, 18, 18),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${userModel.followers!.length}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05,
                            fontSize: 12,
                            fontFamily: AppThemeData.boldOpenSans,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Constant.svgPictureShow("assets/icons/review_show.svg", null, 18, 18),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${reviewList.length}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05,
                            fontSize: 12,
                            fontFamily: AppThemeData.boldOpenSans,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Row(
                      children: [
                        Constant.svgPictureShow("assets/icons/icon_picture.svg", themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05, 18, 18),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${photoList.length}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05,
                            fontSize: 12,
                            fontFamily: AppThemeData.boldOpenSans,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      );
    });
  }
}
