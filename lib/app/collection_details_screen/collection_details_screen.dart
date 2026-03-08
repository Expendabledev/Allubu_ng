import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/auth_screen/welcome_screen.dart';
import 'package:yelpify/app/business_details_screen/business_details_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/collection_details_controller.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/service/ad_manager.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/custom_star_rating/custom_star_rating_screen.dart';
import 'package:yelpify/widgets/readmore.dart';

import '../../utils/fire_store_utils.dart' show FireStoreUtils;

class CollectionDetailsScreen extends StatelessWidget {
  const CollectionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CollectionDetailsController(),
        builder: (controller) {
          return Scaffold(
            body: controller.isLoading.value
                ? Constant.loader()
                : NestedScrollView(
                    controller: controller.scrollController,
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: Responsive.height(42, context),
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
                                        : AppThemeData.grey10,
                                    26,
                                    26),
                                Text(
                                  "Back".tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: innerBoxIsScrolled
                                        ? themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01
                                        : AppThemeData.grey10,
                                    fontSize: 14,
                                    fontFamily: AppThemeData.semiboldOpenSans,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [],
                          backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              children: [
                                controller.businessList.isNotEmpty
                                    ? Stack(
                                        children: [
                                          NetworkImageWidget(
                                            height: Responsive.height(100, context),
                                            width: Responsive.width(100, context),
                                            imageUrl: controller.businessList.first.coverPhoto.toString(),
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            height: Responsive.height(100, context),
                                            width: Responsive.width(100, context),
                                            color: Colors.black.withOpacity(0.40),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        height: Responsive.height(100, context),
                                        width: Responsive.width(100, context),
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey03,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Constant.svgPictureShow(
                                            "assets/icons/noun-map-markers.svg",
                                            themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                                            null,
                                            null,
                                          ),
                                        ),
                                      ),
                                Positioned(
                                  bottom: 12,
                                  left: 16,
                                  right: 16,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${controller.bookmarkModel.value.followers!.length} Followers".tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.grey05 : AppThemeData.grey05,
                                          fontSize: 14,
                                          fontFamily: AppThemeData.regularOpenSans,
                                        ),
                                      ),
                                      Text(
                                        controller.bookmarkModel.value.name!.tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.grey10 : AppThemeData.grey10,
                                          fontSize: 24,
                                          fontFamily: AppThemeData.bold,
                                        ),
                                      ),
                                      ReadMoreText(
                                        controller.bookmarkModel.value.description ?? '',
                                        trimLines: 2,
                                        colorClickableText: Colors.pink,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: 'Show more'.tr,
                                        trimExpandedText: 'Show less'.tr,
                                        style: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.grey05 : AppThemeData.grey05,
                                          fontSize: 14,
                                          fontFamily: AppThemeData.regularOpenSans,
                                        ),
                                        moreStyle: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.grey10 : AppThemeData.grey10,
                                          fontSize: 14,
                                          fontFamily: AppThemeData.boldOpenSans,
                                        ),
                                      ),
                                      Divider(),
                                      Text(
                                        (controller.bookmarkModel.value.byAdmin == true ? "By ${Constant.applicationName}" : "").tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.grey05 : AppThemeData.grey05,
                                          fontSize: 14,
                                          fontFamily: AppThemeData.regularOpenSans,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        Constant.timeAgo(controller.bookmarkModel.value.updatedAt!).tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem() ? AppThemeData.grey10 : AppThemeData.grey10,
                                          fontSize: 14,
                                          fontFamily: AppThemeData.boldOpenSans,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      controller.bookmarkModel.value.ownerId == FireStoreUtils.getCurrentUid()
                                          ? SizedBox()
                                          : Obx(
                                              () => RoundedButtonFill(
                                                title: controller.bookmarkModel.value.followers!.contains(FireStoreUtils.getCurrentUid()) ? 'Unfollow collection'.tr : 'Follow Collections'.tr,
                                                height: 4.5,
                                                textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02,
                                                onPress: () {
                                                  if (FireStoreUtils.getCurrentUid() == '') {
                                                    ShowToastDialog.showToast('Please create your account first before follow collections.');
                                                    Get.offAll(WelcomeScreen());
                                                  } else {
                                                    controller.collectionUpdate();
                                                  }
                                                },
                                              ),
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
                    body: Container(
                      color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AdManager.bannerAdWidget(),
                            ),
                            Text(
                              'places_sorted'.trParams({'count': controller.businessList.length.toString()}).tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                                fontSize: 14,
                                fontFamily: AppThemeData.boldOpenSans,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: controller.businessList.length,
                                itemBuilder: (context, index) {
                                  BusinessModel businessModel = controller.businessList[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: InkWell(
                                      onTap: () {
                                        Constant.setRecentBusiness(businessModel);
                                        Get.to(BusinessDetailsScreen(), arguments: {"businessModel": businessModel});
                                      },
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            child: Stack(
                                              children: [
                                                NetworkImageWidget(
                                                  height: Responsive.height(22, context),
                                                  width: Responsive.width(100, context),
                                                  imageUrl: businessModel.coverPhoto.toString(),
                                                  fit: BoxFit.cover,
                                                ),
                                                Container(
                                                  height: Responsive.height(22, context),
                                                  width: Responsive.width(100, context),
                                                  color: Colors.black.withOpacity(0.40),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 10,
                                            left: 16,
                                            right: 16,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${businessModel.businessName}".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: AppThemeData.grey10,
                                                    fontSize: 18,
                                                    fontFamily: AppThemeData.boldOpenSans,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    CustomStarRating(
                                                      size: 16,
                                                      enable: false,
                                                      initialRating: Constant.calculateReview(reviewCount: businessModel.reviewCount!, reviewSum: businessModel.reviewSum!),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      Constant.calculateReview(reviewCount: businessModel.reviewCount, reviewSum: businessModel.reviewSum).tr,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        color: AppThemeData.grey10,
                                                        fontSize: 14,
                                                        fontFamily: AppThemeData.semiboldOpenSans,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "(${double.parse(businessModel.reviewCount.toString()).toStringAsFixed(0)} reviews)",
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        color: AppThemeData.grey10,
                                                        fontSize: 14,
                                                        fontFamily: AppThemeData.semiboldOpenSans,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "${businessModel.address!.formattedAddress}".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: AppThemeData.grey10,
                                                    fontSize: 12,
                                                    fontFamily: AppThemeData.mediumOpenSans,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "View all Images".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: AppThemeData.grey10,
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData.boldOpenSans,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }
}
