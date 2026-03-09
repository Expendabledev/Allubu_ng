import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/business_details_screen/business_details_screen.dart';
import 'package:allubmarket/app/search_screen/search_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/collection_view_controller.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/themes/text_field_widget.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/widgets/custom_star_rating/custom_star_rating_screen.dart';

class CollectionViewScreen extends StatelessWidget {
  const CollectionViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CollectionViewController(),
        builder: (controller) {
          return Scaffold(
            body: controller.isLoading.value
                ? Constant.loader()
                : NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: Responsive.height(50, context),
                          floating: false,
                          pinned: true,
                          scrolledUnderElevation: 0,
                          automaticallyImplyLeading: false,
                          leadingWidth: 120,
                          leading: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Row(
                              children: [
                                Constant.svgPictureShow(
                                    "assets/icons/icon_left.svg",
                                    innerBoxIsScrolled
                                        ? themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01
                                        : AppThemeData.teal02,
                                    26,
                                    26),
                                Text(
                                  "Collections".tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: innerBoxIsScrolled
                                        ? themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01
                                        : AppThemeData.teal02,
                                    fontSize: 14,
                                    fontFamily: AppThemeData.semiboldOpenSans,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      editCollectionBottomSheet(
                                          themeChange, context, controller);
                                    },
                                    child: Constant.svgPictureShow(
                                      "assets/icons/icon_setting-two.svg",
                                      themeChange.getThem()
                                          ? AppThemeData.teal02
                                          : AppThemeData.teal02,
                                      24,
                                      24,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                          backgroundColor: themeChange.getThem()
                              ? AppThemeData.surfaceDark50
                              : AppThemeData.surface50,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: controller.bookmarkModel.value
                                          .businessIds!.isEmpty
                                      ? Container(
                                          width:
                                              Responsive.height(100, context),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: themeChange.getThem()
                                                ? AppThemeData.greyDark08
                                                : AppThemeData.grey08,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: SvgPicture.asset(
                                                "assets/icons/noun-map-markers.svg"),
                                          ),
                                        )
                                      : FutureBuilder<BusinessModel?>(
                                          future: FireStoreUtils
                                              .getBusinessByCollection(
                                                  controller
                                                      .bookmarkModel.value),
                                          builder: (context, snapshot) {
                                            // if (!snapshot.hasData) return SizedBox();
                                            BusinessModel? businessModel =
                                                snapshot.data;
                                            return businessModel == null
                                                ? Container(
                                                    width: Responsive.height(
                                                        100, context),
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark08
                                                          : AppThemeData.grey08,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: SvgPicture.asset(
                                                          "assets/icons/noun-map-markers.svg"),
                                                    ),
                                                  )
                                                : NetworkImageWidget(
                                                    imageUrl: businessModel
                                                        .coverPhoto
                                                        .toString(),
                                                    width: Responsive.height(
                                                        100, context),
                                                    fit: BoxFit.cover,
                                                  );
                                          },
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'followers_count'.trParams({
                                          'count': controller.bookmarkModel
                                                  .value.followers?.length
                                                  .toString() ??
                                              '0',
                                        }).tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark01
                                              : AppThemeData.grey01,
                                          fontSize: 14,
                                          fontFamily:
                                              AppThemeData.regularOpenSans,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        controller.bookmarkModel.value.name!.tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark02
                                              : AppThemeData.grey02,
                                          fontSize: 20,
                                          fontFamily: AppThemeData.boldOpenSans,
                                        ),
                                      ),
                                      Text(
                                        controller.bookmarkModel.value
                                                .description ??
                                            ''.tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark02
                                              : AppThemeData.grey02,
                                          fontSize: 12,
                                          fontFamily:
                                              AppThemeData.regularOpenSans,
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Create by".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData
                                                        .boldOpenSans,
                                                  ),
                                                ),
                                                Text(
                                                  controller.userModel.value
                                                      .fullName()
                                                      .tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark02
                                                        : AppThemeData.grey02,
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData
                                                        .mediumOpenSans,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Text(
                                            'last_updated'.trParams({
                                              'timeAgo': Constant.timeAgo(
                                                  controller.bookmarkModel.value
                                                          .updatedAt ??
                                                      Timestamp.now()),
                                            }).tr,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.greyDark04
                                                  : AppThemeData.grey04,
                                              fontSize: 12,
                                              fontFamily:
                                                  AppThemeData.regularOpenSans,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      // Container(
                                      //   decoration: BoxDecoration(
                                      //       color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                      //       border: Border.all(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                                      //       borderRadius: BorderRadius.all(Radius.circular(8))),
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      //     child: Row(
                                      //       children: [
                                      //         Container(
                                      //           decoration: BoxDecoration(
                                      //             color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                                      //             borderRadius: BorderRadius.all(
                                      //               Radius.circular(10),
                                      //             ),
                                      //           ),
                                      //           child: Padding(
                                      //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      //             child: ,
                                      //           ),
                                      //         ),
                                      //         SizedBox(
                                      //           width: 10,
                                      //         ),
                                      //         // Container(
                                      //         //   decoration: BoxDecoration(
                                      //         //     color: themeChange.getThem() ? AppThemeData.tealDark03 : AppThemeData.teal03,
                                      //         //     borderRadius: BorderRadius.all(
                                      //         //       Radius.circular(10),
                                      //         //     ),
                                      //         //   ),
                                      //         //   child: Padding(
                                      //         //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      //         //     child: Row(
                                      //         //       mainAxisSize: MainAxisSize.min,
                                      //         //       children: [
                                      //         //         Constant.svgPictureShow("assets/icons/people-plus.svg", null, 18, 18),
                                      //         //         SizedBox(
                                      //         //           width: 10,
                                      //         //         ),
                                      //         //         Text(
                                      //         //           'Add Member'.tr,
                                      //         //           textAlign: TextAlign.start,
                                      //         //           style: TextStyle(
                                      //         //             color: themeChange.getThem() ? AppThemeData.tealDark02 : AppThemeData.teal02,
                                      //         //             fontSize: 14,
                                      //         //             fontFamily: AppThemeData.mediumOpenSans,
                                      //         //           ),
                                      //         //         ),
                                      //         //       ],
                                      //         //     ),
                                      //         //   ),
                                      //         // )
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(height: 20),
                                      RoundedButtonFill(
                                        title: 'Add Places'.tr,
                                        height: 5.5,
                                        textColor: themeChange.getThem()
                                            ? AppThemeData.greyDark10
                                            : AppThemeData.grey10,
                                        color: themeChange.getThem()
                                            ? AppThemeData.redDark02
                                            : AppThemeData.red02,
                                        onPress: () {
                                          Get.to(SearchScreen());
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'place_count'.trParams({
                              'count': controller
                                      .bookmarkModel.value.businessIds?.length
                                      .toString() ??
                                  '0',
                            }).tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark02
                                  : AppThemeData.grey02,
                              fontSize: 16,
                              fontFamily: AppThemeData.semiboldOpenSans,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: controller
                                  .bookmarkModel.value.businessIds!.length,
                              itemBuilder: (context, index) {
                                return FutureBuilder<BusinessModel?>(
                                  future: FireStoreUtils.getBusinessById(
                                      controller.bookmarkModel.value
                                          .businessIds![index]),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError ||
                                        snapshot.data == null) {
                                      return Center(
                                          child: Text("Business not found".tr));
                                    }

                                    BusinessModel business = snapshot.data!;
                                    return InkWell(
                                      onTap: () {
                                        Get.to(BusinessDetailsScreen(),
                                            arguments: {
                                              "businessModel": business
                                            });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: NetworkImageWidget(
                                                imageUrl: business.coverPhoto
                                                    .toString(),
                                                fit: BoxFit.cover,
                                                height: Responsive.height(
                                                    10, context),
                                                width: Responsive.width(
                                                    22, context),
                                                errorWidget:
                                                    Constant.svgPictureShow(
                                                        "assets/icons/ic_placeholder_bussiness.svg",
                                                        null,
                                                        50,
                                                        50),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          business.businessName
                                                              .toString()
                                                              .tr,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .greyDark01
                                                                : AppThemeData
                                                                    .grey01,
                                                            fontSize: 16,
                                                            fontFamily:
                                                                AppThemeData
                                                                    .boldOpenSans,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          ShowToastDialog
                                                              .showLoader(
                                                                  "Please wait");
                                                          controller
                                                              .bookmarkModel
                                                              .value
                                                              .businessIds!
                                                              .remove(business
                                                                  .id
                                                                  .toString());
                                                          await FireStoreUtils
                                                              .createBookmarks(
                                                                  controller
                                                                      .bookmarkModel
                                                                      .value);

                                                          business
                                                              .bookmarkUserId!
                                                              .remove(FireStoreUtils
                                                                  .getCurrentUid());

                                                          await FireStoreUtils
                                                              .addBusiness(
                                                                  business);
                                                          await controller
                                                              .getCollection();
                                                          ShowToastDialog
                                                              .showToast(
                                                                  'removed_from'
                                                                      .trParams({
                                                            'name': controller
                                                                    .bookmarkModel
                                                                    .value
                                                                    .name ??
                                                                '',
                                                          }));
                                                        },
                                                        child: Constant
                                                            .svgPictureShow(
                                                          "assets/icons/bookmark-one_fill.svg",
                                                          AppThemeData.red02,
                                                          24,
                                                          24,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Row(
                                                      children: [
                                                        CustomStarRating(
                                                          initialRating: Constant
                                                              .calculateReview(
                                                                  reviewCount:
                                                                      business
                                                                          .reviewCount,
                                                                  reviewSum:
                                                                      business
                                                                          .reviewSum),
                                                          enable: false,
                                                          size: 18,
                                                          bgColor: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .greyDark05
                                                              : AppThemeData
                                                                  .grey05,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          Constant.calculateReview(
                                                                  reviewCount:
                                                                      business
                                                                          .reviewCount,
                                                                  reviewSum:
                                                                      business
                                                                          .reviewSum)
                                                              .tr,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .greyDark01
                                                                : AppThemeData
                                                                    .grey01,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                AppThemeData
                                                                    .boldOpenSans,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          'review_count'
                                                              .trParams({
                                                            'count': Constant
                                                                .formatReviewCount(
                                                                    business
                                                                        .reviewSum
                                                                        .toString()),
                                                          }).tr,
                                                          textAlign:
                                                              TextAlign.start,
                                                          style: TextStyle(
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .greyDark04
                                                                : AppThemeData
                                                                    .grey04,
                                                            fontSize: 12,
                                                            fontFamily:
                                                                AppThemeData
                                                                    .boldOpenSans,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    business.address!
                                                        .formattedAddress
                                                        .toString()
                                                        .tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark01
                                                          : AppThemeData.grey01,
                                                      fontSize: 12,
                                                      fontFamily: AppThemeData
                                                          .regularOpenSans,
                                                    ),
                                                  ),
                                                  Text(
                                                    business.category!
                                                        .map((e) => e.name)
                                                        .join(", ")
                                                        .tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark01
                                                          : AppThemeData.grey01,
                                                      fontSize: 12,
                                                      fontFamily: AppThemeData
                                                          .regularOpenSans,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          );
        });
  }

  void editCollectionBottomSheet(
      themeChange, BuildContext context, CollectionViewController controller) {
    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.62, // Starts at 30% of screen height
        minChildSize: 0.62, // Minimum height (30% of screen)
        maxChildSize: 0.9, // Can expand up to 90% of screen
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SvgPicture.asset(
                          "assets/icons/icon_close.svg",
                          colorFilter: ColorFilter.mode(
                            themeChange.getThem()
                                ? AppThemeData.greyDark06
                                : AppThemeData.grey01,
                            BlendMode.srcIn,
                          ),
                          width: 22,
                        ),
                      ),
                    ),
                    TextFieldWidget(
                      controller:
                          controller.collectionNameTextFieldController.value,
                      hintText: 'Enter new collection name',
                      title: 'Collection Name',
                    ),
                    TextFieldWidget(
                      controller: controller
                          .collectionDescriptionTextFieldController.value,
                      hintText: 'Enter Description',
                      maxLine: 4,
                    ),
                    Text(
                      "Make Collection Public".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark01
                            : AppThemeData.grey01,
                        fontSize: 12,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'public_collection_info'.trParams({
                              'app': Constant.applicationName,
                            }).tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark01
                                  : AppThemeData.grey01,
                              fontSize: 14,
                              fontFamily: AppThemeData.regularOpenSans,
                            ),
                          ),
                        ),
                        Obx(
                          () => Transform.scale(
                            scale: 0.9, // Adjust the scale factor
                            child: CupertinoSwitch(
                              value: controller.isPublic.value,
                              onChanged: (bool value) async {
                                controller.isPublic.value = value;
                              },
                              activeTrackColor:
                                  AppThemeData.red02, // Color when switch is ON
                              inactiveTrackColor: themeChange.getThem()
                                  ? AppThemeData.greyDark06
                                  : AppThemeData
                                      .grey06, // Color when switch is OFF
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    controller.bookmarkModel.value.isDefault == true
                        ? SizedBox()
                        : Center(
                            child: InkWell(
                              onTap: () async {
                                ShowToastDialog.showLoader("Please wait");
                                final userId = FireStoreUtils.getCurrentUid();
                                final businessIds = controller
                                        .bookmarkModel.value.businessIds ??
                                    [];
                                Future.wait(
                                  businessIds.map((id) async {
                                    final business =
                                        await FireStoreUtils.getBusinessById(
                                            id);
                                    if (business != null &&
                                        business.bookmarkUserId != null) {
                                      business.bookmarkUserId!.remove(userId);
                                      // Optionally update the business back to Firestore if needed
                                      await FireStoreUtils.addBusiness(
                                          business); // You must implement this
                                    }
                                  }),
                                );

                                await FireStoreUtils.deleteBookmark(controller
                                        .bookmarkModel.value.id
                                        .toString())
                                    .then(
                                  (value) {
                                    Get.back();
                                    Get.back();
                                    ShowToastDialog.showToast(
                                        "Collection Delete");
                                  },
                                );
                              },
                              child: Text(
                                "Remove Collection".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.red02
                                      : AppThemeData.red02,
                                  fontSize: 12,
                                  fontFamily: AppThemeData.boldOpenSans,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    RoundedButtonFill(
                      title: 'Save'.tr,
                      height: 5.5,
                      textColor: themeChange.getThem()
                          ? AppThemeData.greyDark10
                          : AppThemeData.grey10,
                      color: themeChange.getThem()
                          ? AppThemeData.redDark02
                          : AppThemeData.red02,
                      onPress: () {
                        controller.updateMyBookmark();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true,
    );
  }
}
