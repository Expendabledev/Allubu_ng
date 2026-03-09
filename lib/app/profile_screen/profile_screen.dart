import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/add_review_screen/add_review_screen.dart';
import 'package:allubmarket/app/auth_screen/welcome_screen.dart';
import 'package:allubmarket/app/business_details_screen/business_details_screen.dart';
import 'package:allubmarket/app/check_in_screen/check_in_list_screen.dart';
import 'package:allubmarket/app/create_bussiness_screen/create_business_screen.dart';
import 'package:allubmarket/app/other_people_screen/compliments_list_screen.dart';
import 'package:allubmarket/app/other_people_screen/followers_list.dart';
import 'package:allubmarket/app/other_people_screen/following_list.dart';
import 'package:allubmarket/app/profile_screen/all_review_screen.dart';
import 'package:allubmarket/app/profile_screen/edit_profile_screen.dart';
import 'package:allubmarket/app/search_screen/search_screen.dart';
import 'package:allubmarket/app/user_photo_screen/user_photo_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/dashboard_controller.dart';
import 'package:allubmarket/controller/profile_controller.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/service/ad_manager.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/round_button_border.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/widgets/custom_star_rating/custom_star_rating_screen.dart';
import 'package:allubmarket/widgets/debounced_inkwell.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ProfileController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              centerTitle: false,
              leadingWidth: 120,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark08
                      : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              actions: [],
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          decoration: BoxDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark10
                                  : AppThemeData.grey10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Column(
                              children: [
                                Stack(children: [
                                  Column(
                                    children: [
                                      ClipOval(
                                        child: NetworkImageWidget(
                                          imageUrl: controller
                                              .userModel.value.profilePic
                                              .toString(),
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        controller.userModel.value.fullName(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily:
                                                AppThemeData.boldOpenSans),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Constant.svgPictureShow(
                                                  "assets/icons/icon_user-business.svg",
                                                  themeChange.getThem()
                                                      ? AppThemeData.greyDark05
                                                      : AppThemeData.grey05,
                                                  20,
                                                  20),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "0",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark05
                                                      : AppThemeData.grey05,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      AppThemeData.boldOpenSans,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Row(
                                            children: [
                                              Constant.svgPictureShow(
                                                  "assets/icons/review_show.svg",
                                                  null,
                                                  20,
                                                  20),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${controller.reviewList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark05
                                                      : AppThemeData.grey05,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      AppThemeData.boldOpenSans,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Row(
                                            children: [
                                              Constant.svgPictureShow(
                                                  "assets/icons/icon_picture.svg",
                                                  themeChange.getThem()
                                                      ? AppThemeData.greyDark05
                                                      : AppThemeData.grey05,
                                                  20,
                                                  20),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "${controller.photoList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark05
                                                      : AppThemeData.grey05,
                                                  fontSize: 14,
                                                  fontFamily:
                                                      AppThemeData.boldOpenSans,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            DebouncedInkWell(
                                              onTap: () {
                                                Get.to(SearchScreen());
                                              },
                                              child: imageWidget(
                                                  themeChange,
                                                  "assets/icons/star.svg",
                                                  "Add Review"),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Get.to(SearchScreen());
                                                },
                                                child: imageWidget(
                                                    themeChange,
                                                    "assets/icons/icon_add-pic.svg",
                                                    "Add Photo")),
                                            InkWell(
                                                onTap: () {
                                                  Get.to(CheckInListScreen(),
                                                      arguments: {
                                                        "userModel": controller
                                                            .userModel.value
                                                      });
                                                },
                                                child: imageWidget(
                                                    themeChange,
                                                    "assets/icons/icon_check-one.svg",
                                                    "Check In")),
                                            // InkWell(
                                            //     onTap: () {
                                            //       showCustomBottomSheet(themeChange, context);
                                            //     },
                                            //     child: imageWidget(themeChange, "assets/icons/icon_shop.svg", "Add Business")),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                      right: 0,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () {
                                          Get.to(EditProfileScreen())
                                              ?.then((value) {
                                            if (value == true) {
                                              controller.getData();
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Constant.svgPictureShow(
                                                "assets/icons/ic_edit.svg",
                                                themeChange.getThem()
                                                    ? AppThemeData.greyDark02
                                                    : AppThemeData.grey02,
                                                null,
                                                null),
                                            SizedBox(width: 5),
                                            Text(
                                              'Edit'.tr,
                                              style: TextStyle(
                                                fontFamily:
                                                    AppThemeData.semibold,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.greyDark02
                                                    : AppThemeData.grey02,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ))
                                ])
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark10
                                  : AppThemeData.grey10,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Share your experience".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark01
                                          : AppThemeData.grey01,
                                      fontSize: 20,
                                      fontFamily: AppThemeData.boldOpenSans,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Divider(),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller
                                                .suggestedBusinessList.length >
                                            3
                                        ? 3
                                        : controller
                                            .suggestedBusinessList.length,
                                    itemBuilder: (context, index) {
                                      BusinessModel businessModel = controller
                                          .suggestedBusinessList[index];
                                      return InkWell(
                                        onTap: () {
                                          Constant.setRecentBusiness(
                                              businessModel);
                                          Get.to(BusinessDetailsScreen(),
                                              arguments: {
                                                "businessModel": businessModel
                                              });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                child: NetworkImageWidget(
                                                  imageUrl: businessModel
                                                      .coverPhoto
                                                      .toString(),
                                                  width: Responsive.width(
                                                      12, context),
                                                  height: Responsive.width(
                                                      12, context),
                                                  fit: BoxFit.cover,
                                                  errorWidget:
                                                      Constant.svgPictureShow(
                                                          "assets/icons/ic_placeholder_bussiness.svg",
                                                          null,
                                                          50,
                                                          50),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            businessModel
                                                                .businessName
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .semiboldOpenSans,
                                                              color: themeChange.getThem()
                                                                  ? AppThemeData
                                                                      .greyDark01
                                                                  : AppThemeData
                                                                      .grey01,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            businessModel
                                                                .suggestedBusinessRemovedUserId!
                                                                .add(FireStoreUtils
                                                                    .getCurrentUid());
                                                            FireStoreUtils
                                                                .addBusiness(
                                                                    businessModel);
                                                          },
                                                          child: Icon(
                                                            Icons.close,
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .greyDark04
                                                                : AppThemeData
                                                                    .grey04,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 4,
                                                    ),
                                                    businessModel
                                                            .recommendUserId!
                                                            .contains(FireStoreUtils
                                                                .getCurrentUid())
                                                        ? InkWell(
                                                            onTap: () {
                                                              if (FireStoreUtils
                                                                          .getCurrentUid() ==
                                                                      '' ||
                                                                  FireStoreUtils
                                                                          .getCurrentUid()
                                                                      .isEmpty) {
                                                                Get.offAll(
                                                                    WelcomeScreen());
                                                              } else {
                                                                Get.to(
                                                                    AddReviewScreen(),
                                                                    arguments: {
                                                                      "businessModel":
                                                                          businessModel
                                                                    });
                                                              }
                                                            },
                                                            child: Column(
                                                              children: [
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                CustomStarRating(
                                                                  initialRating:
                                                                      Constant
                                                                          .calculateReview(
                                                                    reviewCount:
                                                                        businessModel
                                                                            .reviewCount!,
                                                                    reviewSum:
                                                                        businessModel
                                                                            .reviewSum!,
                                                                  ),
                                                                  size: 18,
                                                                  enable: false,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : FireStoreUtils.getCurrentUid() !=
                                                                    '' &&
                                                                FireStoreUtils
                                                                        .getCurrentUid()
                                                                    .isNotEmpty
                                                            ? Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Do you recommend this business?"
                                                                        .tr,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      color: themeChange.getThem()
                                                                          ? AppThemeData
                                                                              .greyDark04
                                                                          : AppThemeData
                                                                              .grey04,
                                                                      fontSize:
                                                                          12,
                                                                      fontFamily:
                                                                          AppThemeData
                                                                              .regularOpenSans,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      RoundedButtonBorder(
                                                                        title: 'Yes'
                                                                            .tr,
                                                                        height:
                                                                            3,
                                                                        width:
                                                                            14,
                                                                        borderColor: themeChange.getThem()
                                                                            ? AppThemeData.greyDark06
                                                                            : AppThemeData.grey06,
                                                                        textColor: themeChange.getThem()
                                                                            ? AppThemeData.greyDark02
                                                                            : AppThemeData.grey02,
                                                                        onPress:
                                                                            () {
                                                                          businessModel.recommendYesCount =
                                                                              (double.parse(businessModel.recommendYesCount.toString()) + 1).toString();
                                                                          controller.updateRecommended(
                                                                              "yes",
                                                                              businessModel);
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      RoundedButtonBorder(
                                                                        title: 'No'
                                                                            .tr,
                                                                        height:
                                                                            3,
                                                                        width:
                                                                            14,
                                                                        borderColor: themeChange.getThem()
                                                                            ? AppThemeData.greyDark06
                                                                            : AppThemeData.grey06,
                                                                        textColor: themeChange.getThem()
                                                                            ? AppThemeData.greyDark02
                                                                            : AppThemeData.grey02,
                                                                        onPress:
                                                                            () {
                                                                          controller.updateRecommended(
                                                                              "no",
                                                                              businessModel);
                                                                        },
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      RoundedButtonBorder(
                                                                        title: 'Maybe'
                                                                            .tr,
                                                                        height:
                                                                            3,
                                                                        width:
                                                                            20,
                                                                        borderColor: themeChange.getThem()
                                                                            ? AppThemeData.greyDark06
                                                                            : AppThemeData.grey06,
                                                                        textColor: themeChange.getThem()
                                                                            ? AppThemeData.greyDark02
                                                                            : AppThemeData.grey02,
                                                                        onPress:
                                                                            () {
                                                                          controller.updateRecommended(
                                                                              "maybe",
                                                                              businessModel);
                                                                        },
                                                                      )
                                                                    ],
                                                                  ),
                                                                ],
                                                              )
                                                            : SizedBox(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: AdManager.bannerAdWidget(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark10
                                  : AppThemeData.grey10,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "Contributions".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01,
                                        fontSize: 20,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Divider(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(AllReviewScreen());
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow(
                                                  "assets/icons/star.svg",
                                                  themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  24,
                                                  24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Review".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.reviewList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData
                                                      .semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(UserPhotoScreen(),
                                                arguments: {
                                                  "userModel":
                                                      controller.userModel.value
                                                });
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow(
                                                  "assets/icons/picture.svg",
                                                  themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  24,
                                                  24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Photos".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.photoList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData
                                                      .semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        // InkWell(
                                        //   onTap: () {
                                        //     DashBoardController controller = Get.find();
                                        //     controller.selectedIndex.value = 4;
                                        //   },
                                        //   child: Row(
                                        //     children: [
                                        //       Constant.svgPictureShow("assets/icons/icon_shop.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, 24, 24),
                                        //       SizedBox(
                                        //         width: 10,
                                        //       ),
                                        //       Expanded(
                                        //         child: Text(
                                        //           "Added Business".tr,
                                        //           textAlign: TextAlign.start,
                                        //           style: TextStyle(
                                        //             color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                        //             fontSize: 16,
                                        //             fontFamily: AppThemeData.semiboldOpenSans,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Text(
                                        //         "${controller.myBusinessList.length}",
                                        //         textAlign: TextAlign.start,
                                        //         style: TextStyle(
                                        //           color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                        //           fontSize: 16,
                                        //           fontFamily: AppThemeData.semiboldOpenSans,
                                        //         ),
                                        //       )
                                        //     ],
                                        //   ),
                                        // ),
                                        // SizedBox(
                                        //   height: 20,
                                        // ),
                                        InkWell(
                                          onTap: () {
                                            DashBoardController controller =
                                                Get.find();
                                            controller.selectedIndex.value = 3;
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow(
                                                  "assets/icons/icon_bookmark-one.svg",
                                                  themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  24,
                                                  24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Collections".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.bookMarkList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData
                                                      .semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark10
                                  : AppThemeData.grey10,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(
                                      "Community".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01,
                                        fontSize: 20,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Divider(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(FollowersList(), arguments: {
                                              "userModel":
                                                  controller.userModel.value,
                                              "myProfile": true
                                            })!
                                                .then(
                                              (value) {
                                                controller.getUser();
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow(
                                                  "assets/icons/peoples-two.svg",
                                                  themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  24,
                                                  24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Followers".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.userModel.value.followers!.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData
                                                      .semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(FollowingList(), arguments: {
                                              "userModel":
                                                  controller.userModel.value,
                                              "myProfile": true
                                            })!
                                                .then(
                                              (value) {
                                                controller.getUser();
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow(
                                                  "assets/icons/peoples-two.svg",
                                                  themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  24,
                                                  24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Following".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.followingList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData
                                                      .semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(ComplimentsListScreen(),
                                                arguments: {
                                                  "userModel":
                                                      controller.userModel.value
                                                });
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow(
                                                  "assets/icons/icon_hot-air-balloon.svg",
                                                  themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  24,
                                                  24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Compliments".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.complimentsList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData
                                                      .semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  void showCustomBottomSheet(themeChange, BuildContext context) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: themeChange.getThem()
              ? AppThemeData.greyDark10
              : AppThemeData.grey10,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/bussiness_create_illustator.png',
                    width: Responsive.width(100, context),
                    height: Responsive.height(30, context),
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        "assets/icons/icon_close.svg",
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.greyDark06
                              : AppThemeData.grey01,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ), // Add an illustration
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Add a business".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark02
                            : AppThemeData.grey02,
                        fontSize: 16,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "What’s your relationship with the business you’d like to add?"
                          .tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark04
                            : AppThemeData.grey04,
                        fontSize: 16,
                        fontFamily: AppThemeData.regularOpenSans,
                      ),
                    ),
                    SizedBox(height: 15),
                    RoundedButtonFill(
                      title: 'I’m a customer',
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark06
                          : AppThemeData.grey06,
                      textColor: themeChange.getThem()
                          ? AppThemeData.greyDark02
                          : AppThemeData.grey02,
                      onPress: () {
                        Get.back();
                        Get.to(CreateBusinessScreen(),
                            arguments: {"asCustomerOrWorkAtBusiness": true});
                      },
                    ),
                    SizedBox(height: 10),
                    RoundedButtonFill(
                      title: 'I work at the business',
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark06
                          : AppThemeData.grey06,
                      textColor: themeChange.getThem()
                          ? AppThemeData.greyDark02
                          : AppThemeData.grey02,
                      onPress: () {
                        Get.back();
                        Get.to(CreateBusinessScreen(),
                            arguments: {"asCustomerOrWorkAtBusiness": false});
                      },
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  Widget imageWidget(themeChange, String imagePath, String title) {
    return Column(
      children: [
        ClipOval(
            child: Container(
          decoration: BoxDecoration(
            color: themeChange.getThem()
                ? AppThemeData.greyDark07
                : AppThemeData.grey07,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Constant.svgPictureShow(
                imagePath,
                themeChange.getThem()
                    ? AppThemeData.greyDark03
                    : AppThemeData.grey03,
                null,
                null),
          ),
        )),
        SizedBox(
          height: 5,
        ),
        Text(
          title.tr,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: themeChange.getThem()
                ? AppThemeData.greyDark02
                : AppThemeData.grey02,
            fontSize: 12,
            fontFamily: AppThemeData.mediumOpenSans,
          ),
        )
      ],
    );
  }
}
