import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/add_review_screen/add_review_screen.dart';
import 'package:allubmarket/app/auth_screen/welcome_screen.dart';
import 'package:allubmarket/app/business_details_screen/pricing_form_screen.dart';
import 'package:allubmarket/app/business_details_screen/see_full_menu_screen.dart';
import 'package:allubmarket/app/check_in_screen/add_check_in_screen.dart';
import 'package:allubmarket/app/complain_report_screen/complain_report_screen.dart';
import 'package:allubmarket/app/other_people_screen/other_people_screen.dart';
import 'package:allubmarket/app/photo_screen/photo_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/business_details_controller.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/highlight_model.dart';
import 'package:allubmarket/models/item_model.dart';
import 'package:allubmarket/models/review_model.dart';
import 'package:allubmarket/models/service_model.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/service/ad_manager.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/round_button_border.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/utils/utils.dart';
import 'package:allubmarket/widgets/bookmark_bottomsheet.dart';
import 'package:allubmarket/widgets/custom_star_rating/custom_star_rating_screen.dart';
import 'package:allubmarket/widgets/readmore.dart';
import 'package:allubmarket/widgets/review_photo_view.dart';
import 'package:allubmarket/widgets/review_user_view.dart';
import 'package:allubmarket/widgets/debounced_inkwell.dart';

class BusinessDetailsScreen extends StatelessWidget {
  const BusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: BusinessDetailsController(),
        builder: (controller) {
          return DefaultTabController(
            length: controller.hasPricing() && controller.hasMenuItem()
                ? 4
                : controller.hasPricing() || controller.hasMenuItem()
                    ? 3
                    : 2,
            child: Scaffold(
              body: controller.isLoading.value
                  ? Constant.loader()
                  : NestedScrollView(
                      controller: controller.scrollController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            expandedHeight: 410,
                            floating: false,
                            pinned: true,
                            scrolledUnderElevation: 0,
                            automaticallyImplyLeading: false,
                            leadingWidth: 120,
                            leading: DebouncedInkWell(
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
                            actions: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    DebouncedInkWell(
                                      onTap: () async {
                                        if (FireStoreUtils.getCurrentUid() ==
                                                '' ||
                                            FireStoreUtils.getCurrentUid()
                                                .isEmpty) {
                                          Get.offAll(WelcomeScreen());
                                        } else {
                                          var result = await Get.bottomSheet(
                                            BookMarkBottomSheet(
                                                businessModel: controller
                                                    .businessModel.value),
                                            isScrollControlled: true,
                                            backgroundColor:
                                                AppThemeData.grey10,
                                          );
                                          if (result == true) {
                                            await controller.getBusiness();
                                          }
                                        }
                                      },
                                      child: Obx(
                                        () => Constant.svgPictureShow(
                                          controller.businessModel.value
                                                  .bookmarkUserId!
                                                  .contains(FireStoreUtils
                                                      .getCurrentUid())
                                              ? "assets/icons/bookmark-one_fill.svg"
                                              : "assets/icons/icon_bookmark-one.svg",
                                          controller.businessModel.value
                                                  .bookmarkUserId!
                                                  .contains(FireStoreUtils
                                                      .getCurrentUid())
                                              ? AppThemeData.red02
                                              : innerBoxIsScrolled
                                                  ? themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01
                                                  : AppThemeData.grey10,
                                          24,
                                          24,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    DebouncedInkWell(
                                      onTap: () async {
                                        showBusinessCupertinoActionSheet(
                                            themeChange, context, controller);
                                      },
                                      child: Constant.svgPictureShow(
                                        "assets/icons/icon_more.svg",
                                        innerBoxIsScrolled
                                            ? themeChange.getThem()
                                                ? AppThemeData.greyDark01
                                                : AppThemeData.grey01
                                            : AppThemeData.grey10,
                                        24,
                                        24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            backgroundColor: themeChange.getThem()
                                ? AppThemeData.greyDark10
                                : AppThemeData.grey10,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Padding(
                                padding: const EdgeInsets.only(bottom: 50),
                                child: Stack(
                                  children: [
                                    controller.businessModel.value.coverPhoto !=
                                                null &&
                                            controller.businessModel.value
                                                .coverPhoto!.isNotEmpty
                                        ? Stack(
                                            children: [
                                              NetworkImageWidget(
                                                width: Responsive.width(
                                                    100, context),
                                                height: Responsive.width(
                                                    100, context),
                                                imageUrl: controller
                                                    .businessModel
                                                    .value
                                                    .coverPhoto
                                                    .toString(),
                                                fit: BoxFit.cover,
                                              ),
                                              Container(
                                                width: Responsive.width(
                                                    100, context),
                                                height: Responsive.width(
                                                    100, context),
                                                color: Colors.black
                                                    .withOpacity(0.70),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/business_cover_placeholder.png"),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                    Positioned(
                                      top: 100,
                                      bottom: 20,
                                      left: 16,
                                      right: 16,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            controller.businessModel.value
                                                            .ownerId ==
                                                        null ||
                                                    controller.businessModel
                                                        .value.ownerId!.isEmpty
                                                ? RoundedButtonFill(
                                                    title: 'Unclaimed'.tr,
                                                    height: 3,
                                                    width: 30,
                                                    fontSizes: 12,
                                                    isRight: true,
                                                    isCenter: true,
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark01
                                                          : AppThemeData.grey01,
                                                      size: 16,
                                                    ),
                                                    textColor: themeChange
                                                            .getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark10
                                                        : AppThemeData.grey10,
                                                    onPress: () {
                                                      Constant.launchUrlOfClimBusiness(
                                                          context,
                                                          Constant
                                                              .claimBusinessURL);
                                                    },
                                                  )
                                                : RoundedButtonFill(
                                                    title: 'Claimed'.tr,
                                                    height: 3,
                                                    width: 28,
                                                    fontSizes: 12,
                                                    isRight: true,
                                                    isCenter: true,
                                                    icon: Icon(
                                                      Icons.info_outline,
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark01
                                                          : AppThemeData.grey01,
                                                      size: 16,
                                                    ),
                                                    textColor: themeChange
                                                            .getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark10
                                                        : AppThemeData.grey10,
                                                    onPress: () {},
                                                  ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              controller.businessModel.value
                                                  .businessName!.tr,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey10
                                                    : AppThemeData.grey10,
                                                fontSize: 24,
                                                fontFamily: AppThemeData.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                CustomStarRating(
                                                  size: 18,
                                                  enable: false,
                                                  bgColor: themeChange.getThem()
                                                      ? AppThemeData.grey03
                                                      : AppThemeData.grey03,
                                                  emptyColor: themeChange
                                                          .getThem()
                                                      ? AppThemeData.greyDark10
                                                      : AppThemeData.grey10,
                                                  initialRating:
                                                      Constant.calculateReview(
                                                    reviewCount: controller
                                                        .businessModel
                                                        .value
                                                        .reviewCount!,
                                                    reviewSum: controller
                                                        .businessModel
                                                        .value
                                                        .reviewSum!,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  Constant.calculateReview(
                                                    reviewCount: controller
                                                        .businessModel
                                                        .value
                                                        .reviewCount!,
                                                    reviewSum: controller
                                                        .businessModel
                                                        .value
                                                        .reviewSum!,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey10
                                                        : AppThemeData.grey10,
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "(${double.parse(controller.businessModel.value.reviewCount.toString()).toStringAsFixed(0)} reviews)",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.grey10
                                                        : AppThemeData.grey10,
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              Constant.getCategoryNames(
                                                      controller.businessModel
                                                          .value.category)
                                                  .tr,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.grey10
                                                    : AppThemeData.grey10,
                                                fontSize: 14,
                                                fontFamily: AppThemeData
                                                    .semiboldOpenSans,
                                              ),
                                            ),
                                            controller.businessModel.value
                                                            .businessHours ==
                                                        null ||
                                                    controller
                                                            .businessModel
                                                            .value
                                                            .showWorkingHours ==
                                                        false
                                                ? SizedBox()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Row(
                                                      children: [
                                                        Constant.buildStatusText(
                                                            themeChange,
                                                            Constant.getBusinessStatus(
                                                                controller
                                                                    .businessModel
                                                                    .value
                                                                    .businessHours!),
                                                            false),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(
                                                          Icons.circle_rounded,
                                                          size: 8,
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .greyDark10
                                                              : AppThemeData
                                                                  .grey10,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        DebouncedInkWell(
                                                          onTap: () {
                                                            seeHoursFilterBottomSheet(
                                                                themeChange,
                                                                controller);
                                                          },
                                                          child: Text(
                                                            "See hours".tr,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                              color: themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .teal02
                                                                  : AppThemeData
                                                                      .teal02,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  AppThemeData
                                                                      .boldOpenSans,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                            SizedBox(height: 5),
                                            LayoutBuilder(builder:
                                                (context, constraints) {
                                              return ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxHeight:
                                                        Responsive.height(
                                                            8, context),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    child: ReadMoreText(
                                                      controller.businessModel
                                                          .value.description
                                                          .toString()
                                                          .tr,
                                                      trimLines: 2,
                                                      colorClickableText:
                                                          Colors.pink,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText:
                                                          'Show more'.tr,
                                                      trimExpandedText:
                                                          'Show less'.tr,
                                                      style: TextStyle(
                                                        color:
                                                            AppThemeData.grey10,
                                                        fontSize: 14,
                                                        fontFamily: AppThemeData
                                                            .regularOpenSans,
                                                      ),
                                                      moreStyle: TextStyle(
                                                        color:
                                                            AppThemeData.red02,
                                                        fontSize: 14,
                                                        fontFamily: AppThemeData
                                                            .boldOpenSans,
                                                      ),
                                                    ),
                                                  ));
                                            }),
                                            SizedBox(height: 20),
                                            Obx(
                                              () => RoundedButtonFill(
                                                title:
                                                    controller.allPhotos.isEmpty
                                                        ? 'Upload Photo'.tr
                                                        : 'see_all_images'
                                                            .trParams({
                                                            'count': controller
                                                                .allPhotos
                                                                .length
                                                                .toString(),
                                                          }).tr,
                                                height: 4.5,
                                                textColor: themeChange.getThem()
                                                    ? AppThemeData.greyDark10
                                                    : AppThemeData.grey10,
                                                color: themeChange.getThem()
                                                    ? AppThemeData.redDark02
                                                    : AppThemeData.grey02,
                                                onPress: () {
                                                  Get.to(PhotoScreen(),
                                                      arguments: {
                                                        "businessModel":
                                                            controller
                                                                .businessModel
                                                                .value
                                                      });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            bottom: PreferredSize(
                              preferredSize: Size.fromHeight(48),
                              child: Align(
                                alignment:
                                    Alignment.centerLeft, // 👈 Align to left
                                child: Container(
                                  color: themeChange.getThem()
                                      ? AppThemeData.greyDark10
                                      : AppThemeData.grey10,
                                  child: TabBar(
                                    controller: controller.tabController,
                                    isScrollable: false,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    // or Tab if you want full tab width
                                    // 👈 This makes it scrollable
                                    onTap: (value) {
                                      controller.currentIndex.value = value;
                                      if (controller.hasPricing() &&
                                          controller.hasMenuItem()) {
                                        if (value == 0) {
                                          controller.scrollToSection(
                                              controller.getTouch);
                                        } else if (value == 1) {
                                          controller.scrollToSection(
                                              controller.menuKey);
                                        } else if (value == 2) {
                                          controller.scrollToSection(
                                              controller.infoKey);
                                        } else {
                                          controller.scrollToSection(
                                              controller.reviewKey);
                                        }
                                      } else if (controller.hasPricing() ||
                                          controller.hasMenuItem()) {
                                        if (value == 0) {
                                          if (controller.hasPricing()) {
                                            controller.scrollToSection(
                                                controller.getTouch);
                                          } else {
                                            controller.scrollToSection(
                                                controller.menuKey);
                                          }
                                        } else if (value == 1) {
                                          controller.scrollToSection(
                                              controller.infoKey);
                                        } else {
                                          controller.scrollToSection(
                                              controller.reviewKey);
                                        }
                                      } else {
                                        if (value == 0) {
                                          controller.scrollToSection(
                                              controller.infoKey);
                                        } else {
                                          controller.scrollToSection(
                                              controller.reviewKey);
                                        }
                                      }
                                    },
                                    indicatorColor: themeChange.getThem()
                                        ? AppThemeData.red02
                                        : AppThemeData.red02,
                                    labelColor: themeChange.getThem()
                                        ? AppThemeData.greyDark01
                                        : AppThemeData.grey01,
                                    unselectedLabelColor: themeChange.getThem()
                                        ? AppThemeData.greyDark04
                                        : AppThemeData.grey04,
                                    labelPadding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                    // 👈 Equal padding
                                    indicator: UnderlineTabIndicator(
                                      insets: EdgeInsets.symmetric(
                                          horizontal:
                                              controller.tabController.length >
                                                      3
                                                  ? -20
                                                  : -50),
                                      borderSide: BorderSide(
                                        color: themeChange.getThem()
                                            ? AppThemeData.red02
                                            : AppThemeData.red02,
                                        width: 4,
                                      ),
                                    ),
                                    tabs: controller.hasPricing() &&
                                            controller.hasMenuItem()
                                        ? [
                                            Tab(text: "Get in touch".tr),
                                            Tab(text: "Menu".tr),
                                            Tab(text: "Info".tr),
                                            Tab(text: "Reviews".tr),
                                          ]
                                        : controller.hasPricing() ||
                                                controller.hasMenuItem()
                                            ? [
                                                controller.hasPricing()
                                                    ? Tab(
                                                        text: "Get in touch".tr)
                                                    : Tab(text: "Menu".tr),
                                                Tab(text: "Info".tr),
                                                Tab(text: "Reviews".tr),
                                              ]
                                            : [
                                                Tab(text: "Info".tr),
                                                Tab(text: "Reviews".tr),
                                              ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: Container(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark10
                              : AppThemeData.grey10,
                          child: infoPage(themeChange, controller)),
                    ),
            ),
          );
        });
  }

  Widget infoPage(themeChange, BusinessDetailsController controller) {
    return Obx(
      () => SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdManager.bannerAdWidget(),
            if (FireStoreUtils.getCurrentUid() != '')
              pricingWidget(controller, themeChange),
            Obx(
              () => controller.businessModel.value.recommendUserId
                          ?.contains(FireStoreUtils.getCurrentUid()) ==
                      true
                  ? SizedBox()
                  : FireStoreUtils.getCurrentUid() != ''
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Do you recommend this business?".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark02
                                        : AppThemeData.grey02,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.boldOpenSans,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: RoundedButtonBorder(
                                          title: 'Yes',
                                          height: 4,
                                          borderColor: themeChange.getThem()
                                              ? AppThemeData.greyDark06
                                              : AppThemeData.grey06,
                                          textColor: themeChange.getThem()
                                              ? AppThemeData.greyDark02
                                              : AppThemeData.grey02,
                                          onPress: () {
                                            controller.businessModel.value
                                                    .recommendYesCount =
                                                (double.parse(controller
                                                            .businessModel
                                                            .value
                                                            .recommendYesCount
                                                            .toString()) +
                                                        1)
                                                    .toString();
                                            controller.updateRecommended("yes");
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: RoundedButtonBorder(
                                          title: 'No',
                                          height: 4,
                                          borderColor: themeChange.getThem()
                                              ? AppThemeData.greyDark06
                                              : AppThemeData.grey06,
                                          textColor: themeChange.getThem()
                                              ? AppThemeData.greyDark02
                                              : AppThemeData.grey02,
                                          onPress: () {
                                            controller.updateRecommended("no");
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: RoundedButtonBorder(
                                          title: 'Maybe',
                                          height: 4,
                                          borderColor: themeChange.getThem()
                                              ? AppThemeData.greyDark06
                                              : AppThemeData.grey06,
                                          textColor: themeChange.getThem()
                                              ? AppThemeData.greyDark02
                                              : AppThemeData.grey02,
                                          onPress: () {
                                            controller
                                                .updateRecommended("maybe");
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Divider(
                                    height: 1,
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark06
                                        : AppThemeData.grey06,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(height: 10),
            ),
            menuWidget(controller, themeChange),
            infoWidget(controller, themeChange),
            if (controller.businessModel.value.fbLink?.isNotEmpty == true ||
                controller.businessModel.value.instaLink?.isNotEmpty == true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark09
                          : AppThemeData.grey09,
                      height: 14),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 14, right: 14, bottom: 16, top: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Social media links".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                            fontSize: 20,
                            fontFamily: AppThemeData.boldOpenSans,
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (controller
                                    .businessModel.value.fbLink?.isNotEmpty ==
                                true)
                              DebouncedInkWell(
                                  onTap: () async {
                                    Utils.launchURL(controller
                                        .businessModel.value.fbLink
                                        .toString()
                                        .toString());
                                  },
                                  child: imageWidget(
                                      themeChange,
                                      "assets/images/fb.png",
                                      "Facebook Link".tr)),
                            if (controller.businessModel.value.instaLink
                                    ?.isNotEmpty ==
                                true)
                              DebouncedInkWell(
                                  onTap: () {
                                    Utils.launchURL(controller
                                        .businessModel.value.instaLink
                                        .toString()
                                        .toString()
                                        .toString());
                                  },
                                  child: imageWidget(
                                      themeChange,
                                      "assets/images/insta.png",
                                      "Instagram Link".tr)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark09
                          : AppThemeData.grey09,
                      height: 14),
                ],
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Share this business".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark02
                          : AppThemeData.grey02,
                      fontSize: 16,
                      fontFamily: AppThemeData.boldOpenSans,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DebouncedInkWell(
                          onTap: () {
                            Utils.sendSMS(
                                phoneNumber: '',
                                message:
                                    "${controller.businessModel.value.businessName} \n ${Constant.deepLinkUrl}${Constant.businessDeepLink}${controller.businessModel.value.id}");
                          },
                          child: imageWidget(
                              themeChange,
                              "assets/icons/icon_message-unread.svg",
                              "Message".tr)),
                      DebouncedInkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(
                                    text:
                                        "${Constant.deepLinkUrl}${Constant.businessDeepLink}${controller.businessModel.value.id}"))
                                .then((_) {
                              ShowToastDialog.showToast("Link Copied".tr);
                            });
                          },
                          child: imageWidget(themeChange,
                              "assets/icons/icon_copy.svg", "Copy link".tr)),
                      DebouncedInkWell(
                          onTap: () {
                            Utils.shareBusiness(
                                "${controller.businessModel.value.businessName} \n ${Constant.deepLinkUrl}${Constant.businessDeepLink}${controller.businessModel.value.id}");
                          },
                          child: imageWidget(themeChange,
                              "assets/icons/icon_more-one.svg", "More".tr)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: themeChange.getThem()
                  ? AppThemeData.greyDark09
                  : AppThemeData.grey09,
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "You might also consider".tr,
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
            ListView.builder(
              itemCount: controller.allBusinessList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                BusinessModel businessModel = controller.allBusinessList[index];
                return DebouncedInkWell(
                  onTap: () {
                    Constant.setRecentBusiness(businessModel);
                    Get.back();
                    Get.to(BusinessDetailsScreen(), arguments: {
                      "businessModel": businessModel,
                      "categoryModel": controller.categoryModel.value
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: NetworkImageWidget(
                                imageUrl: businessModel.coverPhoto.toString(),
                                width: Responsive.width(22, context),
                                height: Responsive.height(10, context),
                                fit: BoxFit.cover,
                                errorWidget: Constant.svgPictureShow(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${businessModel.businessName}".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark02
                                          : AppThemeData.grey02,
                                      fontSize: 16,
                                      fontFamily: AppThemeData.boldOpenSans,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  CustomStarRating(
                                    initialRating: Constant.calculateReview(
                                        reviewCount: businessModel.reviewCount,
                                        reviewSum: businessModel.reviewSum),
                                    size: 20,
                                    enable: false,
                                    bgColor: themeChange.getThem()
                                        ? AppThemeData.greyDark06
                                        : AppThemeData.grey06,
                                    emptyColor: themeChange.getThem()
                                        ? AppThemeData.greyDark10
                                        : AppThemeData.grey10,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Constant.calculateReview(
                                                reviewCount:
                                                    businessModel.reviewCount,
                                                reviewSum:
                                                    businessModel.reviewSum)
                                            .tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark04
                                              : AppThemeData.grey04,
                                          fontSize: 14,
                                          fontFamily:
                                              AppThemeData.semiboldOpenSans,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "(${double.parse(businessModel.reviewCount.toString()).toStringAsFixed(0)} reviews)",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark04
                                              : AppThemeData.grey04,
                                          fontSize: 14,
                                          fontFamily:
                                              AppThemeData.semiboldOpenSans,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            reviewWidget(controller, themeChange),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: RoundedButtonBorder(
                      title: 'Add Photo'.tr,
                      height: 5.5,
                      icon: Constant.svgPictureShow(
                          "assets/icons/icon_picture.svg",
                          themeChange.getThem()
                              ? AppThemeData.greyDark02
                              : AppThemeData.grey02,
                          null,
                          null),
                      borderColor: themeChange.getThem()
                          ? AppThemeData.greyDark06
                          : AppThemeData.grey06,
                      textColor: themeChange.getThem()
                          ? AppThemeData.greyDark02
                          : AppThemeData.grey02,
                      isRight: false,
                      onPress: () {
                        if (FireStoreUtils.getCurrentUid() == '' ||
                            FireStoreUtils.getCurrentUid().isEmpty) {
                          Get.offAll(WelcomeScreen());
                        } else {
                          Get.to(PhotoScreen(), arguments: {
                            "businessModel": controller.businessModel.value
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: RoundedButtonBorder(
                      title: 'Check in'.tr,
                      height: 5.5,
                      icon: Constant.svgPictureShow(
                          "assets/icons/icon_check-one.svg",
                          themeChange.getThem()
                              ? AppThemeData.greyDark02
                              : AppThemeData.grey02,
                          null,
                          null),
                      isRight: false,
                      borderColor: themeChange.getThem()
                          ? AppThemeData.greyDark06
                          : AppThemeData.grey06,
                      textColor: themeChange.getThem()
                          ? AppThemeData.greyDark02
                          : AppThemeData.grey02,
                      onPress: () {
                        if (FireStoreUtils.getCurrentUid() == '' ||
                            FireStoreUtils.getCurrentUid().isEmpty) {
                          Get.offAll(WelcomeScreen());
                        } else {
                          Get.to(AddCheckInScreen(), arguments: {
                            "businessModel": controller.businessModel.value
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showBusinessCupertinoActionSheet(
      themeChange, BuildContext context, BusinessDetailsController controller) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () {
              Utils.shareBusiness(
                  "${controller.businessModel.value.businessName} \n ${Constant.deepLinkUrl}${Constant.businessDeepLink}${controller.businessModel.value.id}");
            },
            child: Text(
              "Share Business".tr,
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
          CupertinoActionSheetAction(
            onPressed: () {
              if (FireStoreUtils.getCurrentUid() == '' ||
                  FireStoreUtils.getCurrentUid().isEmpty) {
                Get.offAll(WelcomeScreen());
              } else {
                Get.back();
                Get.to(ComplainReportScreen(), arguments: {
                  "type": Constant.businessIssues,
                  "givenBy": controller.businessModel.value.id.toString(),
                  "postId": controller.businessModel.value.id.toString()
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

  void showReviewCupertinoActionSheet(themeChange, BuildContext context,
      BusinessDetailsController controller, ReviewModel reviewModel) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () {
              Utils.shareBusiness(
                  "${controller.businessModel.value.businessName} \n\n${reviewModel.comment} \n${"Review : ${reviewModel.review}"}");
            },
            child: Text(
              "Share Review".tr,
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
          CupertinoActionSheetAction(
            onPressed: () {
              if (FireStoreUtils.getCurrentUid() == '' ||
                  FireStoreUtils.getCurrentUid().isEmpty) {
                Get.offAll(WelcomeScreen());
              } else {
                Get.back();
                Get.to(ComplainReportScreen(), arguments: {
                  "type": Constant.reviewIssues,
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

  Widget imageWidget(themeChange, String imagePath, String title,
      {double? fontSize}) {
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
            child: imagePath.contains('.png')
                ? Image.asset(
                    imagePath,
                    width: 25,
                    height: 25,
                    fit: BoxFit.cover,
                  )
                : Constant.svgPictureShow(
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
            fontSize: fontSize ?? 14,
            fontFamily: AppThemeData.mediumOpenSans,
          ),
        )
      ],
    );
  }

  Widget buildStatusText(themeChange, String status) {
    TextStyle defaultStyle = TextStyle(
        fontSize: 12,
        color: themeChange.getThem()
            ? AppThemeData.greyDark04
            : AppThemeData.grey04,
        fontFamily: AppThemeData.boldOpenSans);
    TextStyle openStyle = TextStyle(
        fontSize: 12,
        color: themeChange.getThem()
            ? AppThemeData.greenDark02
            : AppThemeData.green02,
        fontFamily: AppThemeData.boldOpenSans);
    TextStyle closedStyle = TextStyle(
        fontSize: 12,
        color: themeChange.getThem()
            ? AppThemeData.greenDark02
            : AppThemeData.red02,
        fontFamily: AppThemeData.boldOpenSans);

    if (status.startsWith("Open until")) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Open Now".tr, style: openStyle),
          ],
        ),
      );
    } else if (status.startsWith("Closed until")) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Closed".tr, style: closedStyle),
          ],
        ),
      );
    } else if (status == "Closed") {
      return RichText(
        text: TextSpan(
          text: "Closed".tr,
          style: closedStyle,
        ),
      );
    } else {
      return Text(status, style: defaultStyle);
    }
  }

  Widget overallRatingWidget(
      themeChange, BusinessModel businessModel, List<ReviewModel> reviews) {
    Map<double, double> ratingCount = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    // Count how many reviews are in each rating bucket
    for (var review in reviews) {
      double rating = double.parse(review.review.toString());
      if (ratingCount.containsKey(rating)) {
        ratingCount[rating] = ratingCount[rating]! + 1;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Overall rating'.tr,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark01
                      : AppThemeData.grey01,
                  fontSize: 14,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
              const SizedBox(height: 10),
              CustomStarRating(
                initialRating: Constant.calculateReview(
                    reviewCount: businessModel.reviewCount!,
                    reviewSum: businessModel.reviewSum!),
                enable: false,
                size: 20,
                bgColor: themeChange.getThem()
                    ? AppThemeData.greyDark06
                    : AppThemeData.grey06,
                emptyColor: themeChange.getThem()
                    ? AppThemeData.greyDark10
                    : AppThemeData.grey10,
              ),
              const SizedBox(height: 10),
              Text(
                '${double.parse(businessModel.reviewCount.toString()).toStringAsFixed(0)} reviews',
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark04
                      : AppThemeData.grey04,
                  fontSize: 14,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                int star = 5 - index;
                double count = ratingCount[star] ?? 0;
                double percent = double.parse(businessModel.reviewCount!) > 0
                    ? count / double.parse(businessModel.reviewCount!)
                    : 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          fontSize: 12,
                          fontFamily: AppThemeData.semiboldOpenSans,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: percent,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              star == 5
                                  ? Colors.red
                                  : star == 4
                                      ? Colors.orange
                                      : Colors.amber,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void seeHoursFilterBottomSheet(
      themeChange, BusinessDetailsController controller) {
    Get.bottomSheet(
      DraggableScrollableSheet(
          initialChildSize: 0.4,
          // Starts at 30% of screen height
          minChildSize: 0.4,
          // Minimum height (30% of screen)
          maxChildSize: 0.9,
          // Can expand up to
          shouldCloseOnMinExtent: false,
          builder: (context, scrollController) {
            return Container(
              height: Responsive.height(32, Get.context!),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: themeChange.getThem()
                    ? AppThemeData.surfaceDark50
                    : AppThemeData.surface50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Hours",
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                            fontSize: 22,
                            fontFamily: AppThemeData.boldOpenSans,
                          ),
                        ),
                      ),
                      DebouncedInkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            "assets/icons/icon_close.svg",
                            width: 22,
                            colorFilter: ColorFilter.mode(
                              themeChange.getThem()
                                  ? AppThemeData.greyDark06
                                  : AppThemeData.grey01,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: controller.days.length,
                      itemBuilder: (context, index) {
                        final day = controller.days[index];
                        final isToday =
                            day == DateFormat('EEEE').format(DateTime.now());
                        final slots = Constant.getFormattedSlots(
                            Constant.getDayHours(
                                controller.businessModel.value.businessHours ??
                                    BusinessHours(
                                        sunday: [],
                                        monday: [],
                                        thursday: [],
                                        wednesday: [],
                                        tuesday: [],
                                        friday: [],
                                        saturday: []),
                                day));

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark01
                                        : AppThemeData.grey01,
                                    fontSize: 16,
                                    fontFamily: isToday
                                        ? AppThemeData.boldOpenSans
                                        : AppThemeData.mediumOpenSans,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: slots
                                    .map((slot) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            slot,
                                            style: TextStyle(
                                              color: slot == "Closed"
                                                  ? AppThemeData.red02
                                                  : themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                              fontSize: 14,
                                              fontFamily: isToday
                                                  ? AppThemeData.boldOpenSans
                                                  : AppThemeData
                                                      .regularOpenSans,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }),
      isScrollControlled: true, // Allows BottomSheet to take full height
      isDismissible: false,
    );
  }

  Container pricingWidget(BusinessDetailsController controller, themeChange) {
    return Container(
      key: controller.getTouch,
      child: controller.hasPricing() == false
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${controller.categoryModel.value.getPricingFormTitle!.isEmpty ? "Get Pricing & availability" : controller.categoryModel.value.getPricingFormTitle}"
                        .tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark01
                          : AppThemeData.grey01,
                      fontSize: 20,
                      fontFamily: AppThemeData.boldOpenSans,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RoundedButtonFill(
                    title:
                        '${controller.categoryModel.value.getPricingFormTitle!.isEmpty ? "Get Pricing & availability" : controller.categoryModel.value.getPricingFormTitle}'
                            .tr,
                    height: 5,
                    textColor: themeChange.getThem()
                        ? AppThemeData.greyDark10
                        : AppThemeData.grey10,
                    color: themeChange.getThem()
                        ? AppThemeData.redDark02
                        : AppThemeData.red02,
                    onPress: () {
                      Get.to(PricingFormScreen(), arguments: {
                        "businessModel": controller.businessModel.value,
                        "categoryModel": controller.categoryModel.value,
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }

  Container menuWidget(BusinessDetailsController controller, themeChange) {
    return Container(
      key: controller.menuKey,
      child: controller.hasMenuItem() == false
          ? SizedBox()
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Menu".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark01
                          : AppThemeData.grey01,
                      fontSize: 20,
                      fontFamily: AppThemeData.boldOpenSans,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Popular dishes".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark01
                          : AppThemeData.grey01,
                      fontSize: 16,
                      fontFamily: AppThemeData.semiboldOpenSans,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: Responsive.height(18, Get.context!),
                    child: controller.itemList.isEmpty
                        ? Constant.showEmptyView(
                            message: "Menu Item Not available".tr)
                        : ListView.builder(
                            itemCount: controller.itemList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              ItemModel itemModel = controller.itemList[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Stack(
                                    children: [
                                      NetworkImageWidget(
                                        imageUrl: itemModel.images!.first,
                                        width:
                                            Responsive.width(60, Get.context!),
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        width:
                                            Responsive.width(60, Get.context!),
                                        color: Colors.black.withOpacity(0.20),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        child: SizedBox(
                                          width: Responsive.width(
                                              60, Get.context!),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  itemModel.name.toString(),
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark10
                                                        : AppThemeData.grey10,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    itemModel.description
                                                        .toString(),
                                                    textAlign: TextAlign.start,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark05
                                                          : AppThemeData.grey05,
                                                      fontSize: 10,
                                                      fontFamily: AppThemeData
                                                          .semiboldOpenSans,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  "${controller.currency.value.symbol} ${double.parse(itemModel.price.toString()).toStringAsFixed(2)}"
                                                      .tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark10
                                                        : AppThemeData.grey10,
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData
                                                        .boldOpenSans,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  controller.itemList.isEmpty
                      ? SizedBox()
                      : RoundedButtonFill(
                          title: 'See full menu'.tr,
                          height: 5,
                          textColor: themeChange.getThem()
                              ? AppThemeData.greyDark10
                              : AppThemeData.grey10,
                          color: themeChange.getThem()
                              ? AppThemeData.redDark02
                              : AppThemeData.red02,
                          onPress: () {
                            Get.to(SeeFullMenuScreen(), arguments: {
                              "businessModel": controller.businessModel.value
                            });
                          },
                        ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
    );
  }

  Container infoWidget(BusinessDetailsController controller, themeChange) {
    return Container(
      key: controller.infoKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Info".tr,
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
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.businessModel.value.businessHours == null ||
                      controller.businessModel.value.showWorkingHours == false
                  ? SizedBox()
                  : Expanded(
                      child: DebouncedInkWell(
                        onTap: () {
                          seeHoursFilterBottomSheet(themeChange, controller);
                        },
                        child: Column(
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
                                    "assets/icons/icon_alarm-clock.svg",
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
                              "Hours".tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.greyDark01
                                    : AppThemeData.grey01,
                                fontSize: 16,
                                fontFamily: AppThemeData.boldOpenSans,
                              ),
                            ),
                            controller.businessModel.value.businessHours == null
                                ? SizedBox()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: buildStatusText(
                                        themeChange,
                                        Constant.getBusinessStatus(controller
                                            .businessModel
                                            .value
                                            .businessHours!)),
                                  ),
                            SizedBox(
                              height: 5,
                            ),
                            controller.businessModel.value.businessHours == null
                                ? SizedBox()
                                : Text(
                                    Constant.getTodaySingleTimeSlot(controller
                                            .businessModel.value.businessHours!)
                                        .tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark03
                                          : AppThemeData.grey03,
                                      fontSize: 12,
                                      fontFamily: AppThemeData.regularOpenSans,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
              Expanded(
                child: DebouncedInkWell(
                  onTap: () {
                    if (controller.businessModel.value.website!.isEmpty) {
                      ShowToastDialog.showToast("Website not available".tr);
                    } else {
                      Utils.launchURL(
                          controller.businessModel.value.website.toString());
                    }
                  },
                  child: Column(
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
                              "assets/icons/icon_globe.svg",
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
                        "Website".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          fontSize: 16,
                          fontFamily: AppThemeData.boldOpenSans,
                        ),
                      ),
                      Text(
                        "${controller.businessModel.value.website}".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark03
                              : AppThemeData.grey03,
                          fontSize: 12,
                          fontFamily: AppThemeData.regularOpenSans,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: DebouncedInkWell(
                  onTap: () {
                    if (controller.businessModel.value.website!.isEmpty) {
                      ShowToastDialog.showToast(
                          "Phone number not available ".tr);
                    } else {
                      Utils.dialPhoneNumber(
                          "${controller.businessModel.value.countryCode} ${controller.businessModel.value.phoneNumber}");
                    }
                  },
                  child: Column(
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
                              "assets/icons/icon_phone-call.svg",
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
                        "Call".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          fontSize: 16,
                          fontFamily: AppThemeData.boldOpenSans,
                        ),
                      ),
                      Text(
                        "${controller.businessModel.value.countryCode} ${controller.businessModel.value.phoneNumber}"
                            .tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark03
                              : AppThemeData.grey03,
                          fontSize: 12,
                          fontFamily: AppThemeData.regularOpenSans,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              color: themeChange.getThem()
                  ? AppThemeData.greyDark09
                  : AppThemeData.grey09,
              height: 14,
            ),
          ),
          SizedBox(
            height: 200,
            width: Responsive.width(100, Get.context!),
            child: Obx(
              () => GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      double.parse(
                          controller.businessModel.value.location!.latitude ??
                              "0.0"),
                      double.parse(
                          controller.businessModel.value.location!.longitude ??
                              "0.0")),
                  // Example coordinates
                  zoom: 16,
                ),
                markers: controller.markers,
                onMapCreated: controller.onMapCreated,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Constant.getFullAddressModel(
                      controller.businessModel.value.address!),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark02
                        : AppThemeData.grey02,
                    fontSize: 16,
                    fontFamily: AppThemeData.semiboldOpenSans,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Divider(
                    height: 1,
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark08
                        : AppThemeData.grey08,
                  ),
                ),
                DebouncedInkWell(
                  onTap: () {
                    Utils.openMap(
                        label: controller.businessModel.value.businessName
                            .toString(),
                        lat: double.parse(controller
                            .businessModel.value.location!.latitude
                            .toString()),
                        lng: double.parse(controller
                            .businessModel.value.location!.longitude
                            .toString()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "Get Direction".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark02
                                : AppThemeData.grey02,
                            fontSize: 16,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                      ),
                      Constant.svgPictureShow(
                          'assets/icons/icon_map-draw.svg',
                          themeChange.getThem()
                              ? AppThemeData.greyDark02
                              : AppThemeData.grey02,
                          24,
                          24)
                    ],
                  ),
                ),
              ],
            ),
          ),
          controller.serviceList.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Divider(
                    height: 1,
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark08
                        : AppThemeData.grey08,
                  ),
                )
              : SizedBox(height: 14),
          if (controller.serviceList.isNotEmpty)
            Container(
              color: themeChange.getThem()
                  ? AppThemeData.greyDark09
                  : AppThemeData.grey09,
              height: 14,
            ),
          controller.serviceList.isEmpty
              ? SizedBox()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: ListView.separated(
                    itemCount: controller.serviceList.length,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final item = controller.serviceList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark01
                                  : AppThemeData.grey01,
                              fontSize: 16,
                              fontFamily: AppThemeData.boldOpenSans,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                              item['options'].length,
                              (index) {
                                OptionModel optionModel =
                                    item['options'][index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      NetworkImageWidget(
                                        imageUrl: optionModel.icon.toString(),
                                        width: 22,
                                        height: 22,
                                      ),
                                      SizedBox(
                                        width: 14,
                                      ),
                                      Text(
                                        optionModel.name.toString(),
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark01
                                              : AppThemeData.grey01,
                                          fontSize: 16,
                                          fontFamily:
                                              AppThemeData.regularOpenSans,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark07
                              : AppThemeData.grey07,
                        ),
                      );
                    },
                  ),
                ),
          if (controller.highLightList.isNotEmpty)
            Container(
              color: themeChange.getThem()
                  ? AppThemeData.greyDark09
                  : AppThemeData.grey09,
              height: 14,
            ),
          controller.highLightList.isEmpty
              ? SizedBox()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Highlights from the business".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          fontSize: 16,
                          fontFamily: AppThemeData.boldOpenSans,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: Responsive.height(10, Get.context!),
                        child: ListView.separated(
                          itemCount: controller.highLightList.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            HighlightModel item =
                                controller.highLightList[index];
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: SizedBox(
                                width: Responsive.width(20, Get.context!),
                                child: Column(
                                  children: [
                                    NetworkImageWidget(
                                      imageUrl: item.photo.toString(),
                                      width: 36,
                                      height: 36,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      item.title.toString(),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01,
                                        fontSize: 12,
                                        fontFamily:
                                            AppThemeData.semiboldOpenSans,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Divider(
                                color: themeChange.getThem()
                                    ? AppThemeData.greyDark07
                                    : AppThemeData.grey07,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Container reviewWidget(BusinessDetailsController controller, themeChange) {
    return Container(
      key: controller.reviewKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: themeChange.getThem()
                ? AppThemeData.greyDark09
                : AppThemeData.grey09,
            height: 14,
          ),
          if (FireStoreUtils.getCurrentUid() != '')
            Container(
              width: Responsive.width(100, Get.context!),
              decoration: BoxDecoration(
                color: themeChange.getThem()
                    ? AppThemeData.greyDark10
                    : AppThemeData.grey10,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Leave a review".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark01
                            : AppThemeData.grey01,
                        fontSize: 20,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark10
                            : AppThemeData.grey10,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1), // soft shadow
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 2), // vertical offset
                          ),
                        ],
                      ),
                      child: DebouncedInkWell(
                        onTap: () {
                          if (FireStoreUtils.getCurrentUid() == '' ||
                              FireStoreUtils.getCurrentUid().isEmpty) {
                            Get.offAll(WelcomeScreen());
                          } else {
                            Get.to(AddReviewScreen(), arguments: {
                              "businessModel": controller.businessModel.value
                            })?.then(
                              (value) {
                                if (value == true) {
                                  controller.reviewList.clear();
                                  controller.getReview();
                                }
                              },
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ReviewUserView(
                                userId: Constant.userModel!.id.toString(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              CustomStarRating(
                                initialRating: "0.0",
                                enable: false,
                                bgColor: themeChange.getThem()
                                    ? AppThemeData.greyDark06
                                    : AppThemeData.grey06,
                                emptyColor: themeChange.getThem()
                                    ? AppThemeData.greyDark10
                                    : AppThemeData.grey10,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Tap to review".tr,
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
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          Container(
            color: themeChange.getThem()
                ? AppThemeData.greyDark09
                : AppThemeData.grey09,
            height: 14,
          ),
          controller.reviewList.isEmpty
              ? Container(
                  width: Responsive.width(100, Get.context!),
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark09
                      : AppThemeData.grey09,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "No Review yet".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark02
                                : AppThemeData.grey02,
                            fontSize: 20,
                            fontFamily: AppThemeData.boldOpenSans,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        DebouncedInkWell(
                          onTap: () {
                            if (FireStoreUtils.getCurrentUid() == '' ||
                                FireStoreUtils.getCurrentUid().isEmpty) {
                              Get.offAll(WelcomeScreen());
                            } else {
                              Get.to(AddReviewScreen(), arguments: {
                                "businessModel": controller.businessModel.value
                              })?.then(
                                (value) {
                                  if (value == true) {
                                    controller.reviewList.clear();
                                    controller.getReview();
                                  }
                                },
                              );
                            }
                          },
                          child: Container(
                            width: Responsive.width(100, Get.context!),
                            decoration: BoxDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark10
                                  : AppThemeData.grey10,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Be the first to review".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark02
                                            : AppThemeData.grey02,
                                        fontSize: 16,
                                        fontFamily:
                                            AppThemeData.semiboldOpenSans,
                                      ),
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/send_review.gif",
                                    height: 50,
                                    width: 50,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Recommended reviews".tr,
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
                    overallRatingWidget(themeChange,
                        controller.businessModel.value, controller.reviewList),
                    Container(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark09
                          : AppThemeData.grey09,
                      height: 14,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: controller.reviewList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        ReviewModel reviewModel = controller.reviewList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: DebouncedInkWell(
                                      onTap: () async {
                                        if (FireStoreUtils.getCurrentUid() ==
                                                '' ||
                                            FireStoreUtils.getCurrentUid()
                                                .isEmpty) {
                                          Get.offAll(WelcomeScreen());
                                        } else {
                                          ShowToastDialog.showLoader(
                                              "Please wait");
                                          UserModel? userModel0 =
                                              await FireStoreUtils
                                                  .getUserProfile(reviewModel
                                                      .userId
                                                      .toString());
                                          ShowToastDialog.closeLoader();
                                          Get.to(OtherPeopleScreen(),
                                              arguments: {
                                                "userModel": userModel0
                                              });
                                        }
                                      },
                                      child: ReviewUserView(
                                        userId: reviewModel.userId.toString(),
                                      ),
                                    ),
                                  ),
                                  DebouncedInkWell(
                                      onTap: () {
                                        showReviewCupertinoActionSheet(
                                            themeChange,
                                            context,
                                            controller,
                                            reviewModel);
                                      },
                                      child: Constant.svgPictureShow(
                                          "assets/icons/icon_more.svg",
                                          AppThemeData.grey05,
                                          30,
                                          30))
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  CustomStarRating(
                                    initialRating:
                                        reviewModel.review.toString(),
                                    enable: false,
                                    bgColor: themeChange.getThem()
                                        ? AppThemeData.greyDark06
                                        : AppThemeData.grey06,
                                    emptyColor: themeChange.getThem()
                                        ? AppThemeData.greyDark10
                                        : AppThemeData.grey10,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    Constant.timeAgo(reviewModel.createdAt!).tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark04
                                          : AppThemeData.grey04,
                                      fontSize: 12,
                                      fontFamily: AppThemeData.regularOpenSans,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${reviewModel.comment}".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.greyDark02
                                      : AppThemeData.grey02,
                                  fontSize: 14,
                                  fontFamily: AppThemeData.regularOpenSans,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ReviewPhotoView(
                                  reviewId: reviewModel.id.toString()),
                              SizedBox(
                                height: 14,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DebouncedInkWell(
                                    onTap: () async {
                                      if (FireStoreUtils.getCurrentUid() ==
                                              '' ||
                                          FireStoreUtils.getCurrentUid()
                                              .isEmpty) {
                                        Get.offAll(WelcomeScreen());
                                      } else {
                                        if (reviewModel.helpful!.contains(
                                            FireStoreUtils.getCurrentUid())) {
                                          reviewModel.helpful!.remove(
                                              FireStoreUtils.getCurrentUid());
                                        } else {
                                          reviewModel.helpful!.add(
                                              FireStoreUtils.getCurrentUid());
                                        }
                                        FireStoreUtils.updateReview(
                                            reviewModel);
                                        controller.updateReviewList(
                                            index, reviewModel);
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: reviewModel.helpful?.contains(
                                                          FireStoreUtils
                                                              .getCurrentUid()) ==
                                                      true
                                                  ? AppThemeData.red02
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: reviewModel.helpful
                                                              ?.contains(
                                                                  FireStoreUtils
                                                                      .getCurrentUid()) ==
                                                          true
                                                      ? AppThemeData.red02
                                                      : themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark05
                                                          : AppThemeData
                                                              .grey05),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40))),
                                          child: Center(
                                              child: Constant.svgPictureShow(
                                                  "assets/icons/icon_light.svg",
                                                  reviewModel.helpful?.contains(
                                                              FireStoreUtils
                                                                  .getCurrentUid()) ==
                                                          true
                                                      ? AppThemeData.grey10
                                                      : themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark02
                                                          : AppThemeData.grey02,
                                                  24,
                                                  24)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: 'Helpful '.tr,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark02
                                                      : AppThemeData.grey02,
                                                  fontSize: 12,
                                                  fontFamily: AppThemeData
                                                      .regularOpenSans,
                                                ),
                                              ),
                                              TextSpan(
                                                text: reviewModel
                                                    .helpful!.length
                                                    .toString(),
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark02
                                                      : AppThemeData.grey02,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemeData.semibold,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  DebouncedInkWell(
                                    onTap: () async {
                                      if (FireStoreUtils.getCurrentUid() ==
                                              '' ||
                                          FireStoreUtils.getCurrentUid()
                                              .isEmpty) {
                                        Get.offAll(WelcomeScreen());
                                      } else {
                                        if (reviewModel.thanks!.contains(
                                            FireStoreUtils.getCurrentUid())) {
                                          reviewModel.thanks!.remove(
                                              FireStoreUtils.getCurrentUid());
                                        } else {
                                          reviewModel.thanks!.add(
                                              FireStoreUtils.getCurrentUid());
                                        }
                                        FireStoreUtils.updateReview(
                                            reviewModel);
                                        controller.updateReviewList(
                                            index, reviewModel);
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: reviewModel.thanks?.contains(
                                                          FireStoreUtils
                                                              .getCurrentUid()) ==
                                                      true
                                                  ? AppThemeData.red02
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: reviewModel.thanks
                                                              ?.contains(
                                                                  FireStoreUtils
                                                                      .getCurrentUid()) ==
                                                          true
                                                      ? AppThemeData.red02
                                                      : themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark05
                                                          : AppThemeData
                                                              .grey05),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40))),
                                          child: Center(
                                              child: Constant.svgPictureShow(
                                                  "assets/icons/icon_thumbs-up.svg",
                                                  reviewModel.thanks?.contains(
                                                              FireStoreUtils
                                                                  .getCurrentUid()) ==
                                                          true
                                                      ? AppThemeData.grey10
                                                      : themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark02
                                                          : AppThemeData.grey02,
                                                  24,
                                                  24)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: 'Thanks '.tr,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark02
                                                      : AppThemeData.grey02,
                                                  fontSize: 12,
                                                  fontFamily: AppThemeData
                                                      .regularOpenSans,
                                                ),
                                              ),
                                              TextSpan(
                                                text: reviewModel.thanks!.length
                                                    .toString(),
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark02
                                                      : AppThemeData.grey02,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemeData.semibold,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  DebouncedInkWell(
                                    onTap: () async {
                                      if (FireStoreUtils.getCurrentUid() ==
                                              '' ||
                                          FireStoreUtils.getCurrentUid()
                                              .isEmpty) {
                                        Get.offAll(WelcomeScreen());
                                      } else {
                                        if (reviewModel.loveThis!.contains(
                                            FireStoreUtils.getCurrentUid())) {
                                          reviewModel.loveThis!.remove(
                                              FireStoreUtils.getCurrentUid());
                                        } else {
                                          reviewModel.loveThis!.add(
                                              FireStoreUtils.getCurrentUid());
                                        }
                                        FireStoreUtils.updateReview(
                                            reviewModel);
                                        controller.updateReviewList(
                                            index, reviewModel);
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: reviewModel.loveThis
                                                          ?.contains(FireStoreUtils
                                                              .getCurrentUid()) ==
                                                      true
                                                  ? AppThemeData.red02
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: reviewModel.loveThis
                                                              ?.contains(
                                                                  FireStoreUtils
                                                                      .getCurrentUid()) ==
                                                          true
                                                      ? AppThemeData.red02
                                                      : themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark05
                                                          : AppThemeData
                                                              .grey05),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40))),
                                          child: Center(
                                              child: Constant.svgPictureShow(
                                                  "assets/icons/icon_like.svg",
                                                  reviewModel.loveThis?.contains(
                                                              FireStoreUtils
                                                                  .getCurrentUid()) ==
                                                          true
                                                      ? AppThemeData.grey10
                                                      : themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark02
                                                          : AppThemeData.grey02,
                                                  24,
                                                  24)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: 'Love this '.tr,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark02
                                                      : AppThemeData.grey02,
                                                  fontSize: 12,
                                                  fontFamily: AppThemeData
                                                      .regularOpenSans,
                                                ),
                                              ),
                                              TextSpan(
                                                text: reviewModel
                                                    .loveThis!.length
                                                    .toString(),
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark02
                                                      : AppThemeData.grey02,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemeData.semibold,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  DebouncedInkWell(
                                    onTap: () async {
                                      if (FireStoreUtils.getCurrentUid() ==
                                              '' ||
                                          FireStoreUtils.getCurrentUid()
                                              .isEmpty) {
                                        Get.offAll(WelcomeScreen());
                                      } else {
                                        if (reviewModel.ohNo!.contains(
                                            FireStoreUtils.getCurrentUid())) {
                                          reviewModel.ohNo!.remove(
                                              FireStoreUtils.getCurrentUid());
                                        } else {
                                          reviewModel.ohNo!.add(
                                              FireStoreUtils.getCurrentUid());
                                        }
                                        FireStoreUtils.updateReview(
                                            reviewModel);
                                        controller.updateReviewList(
                                            index, reviewModel);
                                      }
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: reviewModel.ohNo!.contains(
                                                      FireStoreUtils
                                                          .getCurrentUid())
                                                  ? AppThemeData.red02
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: reviewModel.ohNo!
                                                          .contains(FireStoreUtils
                                                              .getCurrentUid())
                                                      ? AppThemeData.red02
                                                      : themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark05
                                                          : AppThemeData
                                                              .grey05),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(40))),
                                          child: Center(
                                              child: Constant.svgPictureShow(
                                                  "assets/icons/icon_emotion-unhappy.svg",
                                                  reviewModel.ohNo!.contains(
                                                          FireStoreUtils
                                                              .getCurrentUid())
                                                      ? AppThemeData.grey10
                                                      : themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark02
                                                          : AppThemeData.grey02,
                                                  24,
                                                  24)),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: <InlineSpan>[
                                              TextSpan(
                                                text: 'Oh no '.tr,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark02
                                                      : AppThemeData.grey02,
                                                  fontSize: 12,
                                                  fontFamily: AppThemeData
                                                      .regularOpenSans,
                                                ),
                                              ),
                                              TextSpan(
                                                text: reviewModel.ohNo!.length
                                                    .toString(),
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark02
                                                      : AppThemeData.grey02,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      AppThemeData.semibold,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Divider(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark07
                                : AppThemeData.grey07,
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
