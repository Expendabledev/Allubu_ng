import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/auth_screen/welcome_screen.dart';
import 'package:allubmarket/app/complain_report_screen/complain_report_screen.dart';
import 'package:allubmarket/app/other_people_screen/other_people_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/photo_view_controller.dart';
import 'package:allubmarket/models/photo_model.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/utils/utils.dart';
import 'package:allubmarket/widgets/debounced_inkwell.dart';
import 'package:allubmarket/widgets/review_user_view.dart';
import 'package:allubmarket/widgets/video_player.dart';

class PhotoViewScreen extends StatelessWidget {
  const PhotoViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PhotoViewController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DebouncedInkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_close.svg",
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.greyDark06
                              : AppThemeData.grey01,
                          BlendMode.srcIn,
                        ),
                        width: 22,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Close".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          fontSize: 14,
                          fontFamily: AppThemeData.semiboldOpenSans,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark08
                      : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              title: Text(
                "Photo".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark01
                      : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                      onTap: () {
                        showCommentCupertinoActionSheet(
                            themeChange,
                            context,
                            controller,
                            controller
                                .photoList[controller.initialIndex.value]);
                      },
                      child: Constant.svgPictureShow(
                          "assets/icons/ic_warning.svg",
                          themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          24,
                          24)),
                )
              ],
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.photoList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                // Blurred Background Image
                                Positioned.fill(
                                  child: ImageFiltered(
                                    imageFilter: ImageFilter.blur(
                                        sigmaX: 50, sigmaY: 50), // Blur Effect
                                    child: NetworkImageWidget(
                                      imageUrl:
                                          controller.photoList[index].imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                // Foreground Main Image (Non-blurred)
                                Center(
                                  child: controller.photoList[index].fileType ==
                                          "video"
                                      ? VideoPlayerWidget(
                                          videoUrl: controller
                                              .photoList[index].imageUrl)
                                      : NetworkImageWidget(
                                          imageUrl: controller
                                              .photoList[index].imageUrl,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark10
                                : AppThemeData.grey10,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Constant.timeAgo(
                                        controller.photoList[index].createdAt!),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark03
                                          : AppThemeData.grey03,
                                      fontSize: 14,
                                      fontFamily: AppThemeData.regularOpenSans,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: DebouncedInkWell(
                                          onTap: () async {
                                            UserModel? userModel =
                                                await FireStoreUtils
                                                    .getUserProfile(controller
                                                        .photoList[index].userId
                                                        .toString());
                                            Get.to(OtherPeopleScreen(),
                                                arguments: {
                                                  "userModel": userModel
                                                });
                                          },
                                          child: ReviewUserView(
                                            userId: controller
                                                .photoList[index].userId
                                                .toString(),
                                          ),
                                        ),
                                      ),
                                      DebouncedInkWell(
                                          onTap: () {
                                            Utils.shareMultipleImages(
                                                imageUrls: [
                                                  controller
                                                      .photoList[index].imageUrl
                                                ],
                                                description:
                                                    Constant.applicationName);
                                          },
                                          child: Constant.svgPictureShow(
                                              "assets/icons/share-one.svg",
                                              AppThemeData.grey05,
                                              30,
                                              30)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      DebouncedInkWell(
                                        onTap: () {
                                          if (controller
                                              .photoList[index].likedBy!
                                              .contains(FireStoreUtils
                                                  .getCurrentUid())) {
                                            controller.photoList[index].likedBy!
                                                .remove(FireStoreUtils
                                                    .getCurrentUid());
                                          } else {
                                            controller.photoList[index].likedBy!
                                                .add(FireStoreUtils
                                                    .getCurrentUid());
                                          }
                                          FireStoreUtils.addPhotos(
                                              controller.photoList[index]);
                                          controller.updatePhoto(index,
                                              controller.photoList[index]);
                                        },
                                        child: controller
                                                .photoList[index].likedBy!
                                                .contains(FireStoreUtils
                                                    .getCurrentUid())
                                            ? Constant.svgPictureShow(
                                                "assets/icons/thumbs-up-fill.svg",
                                                AppThemeData.red02,
                                                30,
                                                30)
                                            : Constant.svgPictureShow(
                                                "assets/icons/icon_thumbs-up.svg",
                                                AppThemeData.grey05,
                                                30,
                                                30),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          );
        });
  }

  void showCommentCupertinoActionSheet(themeChange, BuildContext context,
      PhotoViewController controller, PhotoModel reviewModel) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () {
              if (FireStoreUtils.getCurrentUid() == '' ||
                  FireStoreUtils.getCurrentUid().isEmpty) {
                Get.offAll(WelcomeScreen());
              } else {
                Get.back();
                Get.to(ComplainReportScreen(), arguments: {
                  "type": Constant.photoIssues,
                  "givenBy": reviewModel.userId.toString(),
                  "postId": reviewModel.id.toString()
                });
              }
            },
            child: Text(
              "Complain/Report".tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.tealDark02
                    : AppThemeData.teal02,
                fontSize: 16,
                fontFamily: AppThemeData.semiboldOpenSans,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Get.back();
          },
          child: Text(
            "Cancel".tr,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: themeChange.getThem()
                  ? AppThemeData.greyDark01
                  : AppThemeData.grey01,
              fontSize: 16,
              fontFamily: AppThemeData.boldOpenSans,
            ),
          ),
        ),
      ),
    );
  }
}
