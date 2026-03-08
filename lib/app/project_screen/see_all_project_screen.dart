import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/home_screen/business_list_screen.dart';
import 'package:yelpify/app/project_screen/project_details_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/see_all_project_controller.dart';
import 'package:yelpify/models/categiry_plan_model.dart';
import 'package:yelpify/models/pricing_request_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/round_button_border.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';

class SeeAllPlanedScreen extends StatelessWidget {
  const SeeAllPlanedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SeeAllProjectController(),
        builder: (controller) {
          return DefaultTabController(
            length: 3, // Number of tabs
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                centerTitle: true,
                leadingWidth: 120,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icon_close.svg",
                          colorFilter: ColorFilter.mode(
                            themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01,
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
                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                            fontSize: 14,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: controller.tabController,
                  labelColor: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  unselectedLabelColor: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: AppThemeData.semiboldOpenSans,
                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: AppThemeData.regularOpenSans,
                    color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  // Makes the indicator full width
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4, color: AppThemeData.red02), // Full-width red indicator
                  ),
                  tabs: [
                    Tab(
                        text: 'active_count'.trParams({
                      'count': controller.pricingRequestList.length.toString(),
                    })),
                    Tab(
                        text: 'planned_count'.trParams({
                      'count': controller.categoryPlanList.length.toString(),
                    })),
                    Tab(
                        text: 'archived_count'.trParams({
                      'count': controller.archivedPricingRequestList.length.toString(),
                    })),
                  ],
                ),
                title: Text(
                  "All Project".tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                    fontSize: 16,
                    fontFamily: AppThemeData.semiboldOpenSans,
                  ),
                ),
              ),
              body: controller.isLoading.value
                  ? Constant.loader()
                  : TabBarView(
                      controller: controller.tabController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          child: controller.pricingRequestList.isEmpty
                              ? Constant.showEmptyView(message: "You don’t have any active projects right now.")
                              : ListView.builder(
                                  itemCount: controller.pricingRequestList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    PricingRequestModel pricingRequestModel = controller.pricingRequestList[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(ProjectDetailsScreen(), arguments: {"pricingRequestModel": pricingRequestModel});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          border: Border.all(
                                            color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              NetworkImageWidget(
                                                imageUrl: pricingRequestModel.category!.icon.toString(),
                                                width: 44,
                                                height: 44,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            Constant.formatTimestamp(pricingRequestModel.createdAt!).tr,
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                              fontSize: 12,
                                                              fontFamily: AppThemeData.regularOpenSans,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            showCommentCupertinoActionSheet(themeChange, context, controller, pricingRequestModel);
                                                          },
                                                          child:
                                                              Constant.svgPictureShow("assets/icons/icon_more.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, null, null),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      "${pricingRequestModel.category?.name}".tr,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                        fontSize: 16,
                                                        fontFamily: AppThemeData.boldOpenSans,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    StreamBuilder<bool>(
                                                        stream: controller.checkStatus(pricingRequestModel),
                                                        builder: (context, snapshot) {
                                                          bool isChatDone = snapshot.data ?? false;
                                                          return isChatDone == false
                                                              ? Container(
                                                                  decoration: BoxDecoration(
                                                                    color: themeChange.getThem() ? AppThemeData.red03 : AppThemeData.red03,
                                                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                                                    border: Border.all(
                                                                      color: themeChange.getThem() ? AppThemeData.red03 : AppThemeData.red03,
                                                                    ),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                                    child: Text(
                                                                      "Currently waiting for replies from surrounding businesses.".tr,
                                                                      textAlign: TextAlign.start,
                                                                      style: TextStyle(
                                                                        color: themeChange.getThem() ? AppThemeData.red02 : AppThemeData.red02,
                                                                        fontSize: 14,
                                                                        fontFamily: AppThemeData.regularOpenSans,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : StreamBuilder<int>(
                                                                  stream: controller.getUnreadChatCount(pricingRequestModel),
                                                                  builder: (context, snapshot) {
                                                                    final count = snapshot.data ?? 0;
                                                                    return RoundedButtonBorder(
                                                                      title: 'See all message'.tr,
                                                                      height: 5.5,
                                                                      icon: badges.Badge(
                                                                        badgeContent: Text(
                                                                          (count).toString(),
                                                                          style: TextStyle(
                                                                            color: AppThemeData.grey10,
                                                                          ),
                                                                        ),
                                                                        showBadge: count == 0 ? false : true,
                                                                        badgeStyle: badges.BadgeStyle(badgeColor: AppThemeData.red02),
                                                                        child: Constant.svgPictureShow(
                                                                          "assets/icons/icon_wechat.svg",
                                                                          themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                                          32,
                                                                          32,
                                                                        ),
                                                                      ),
                                                                      isRight: false,
                                                                      isCenter: true,
                                                                      borderColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                                                                      textColor: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                                      color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                                      onPress: () async {
                                                                        Get.to(ProjectDetailsScreen(), arguments: {"pricingRequestModel": pricingRequestModel});
                                                                      },
                                                                    );
                                                                  },
                                                                );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          child: controller.categoryPlanList.isEmpty
                              ? Constant.showEmptyView(message: "Planned project not found")
                              : ListView.builder(
                                  itemCount: controller.categoryPlanList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    CategoryPlanModel categoryModel = controller.categoryPlanList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                          borderRadius: BorderRadius.all(Radius.circular(8)),
                                          border: Border.all(
                                            color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              NetworkImageWidget(
                                                imageUrl: categoryModel.category!.icon.toString(),
                                                width: 44,
                                                height: 44,
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            Constant.formatTimestamp(categoryModel.createdAt!).tr,
                                                            textAlign: TextAlign.start,
                                                            style: TextStyle(
                                                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                              fontSize: 12,
                                                              fontFamily: AppThemeData.regularOpenSans,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            unPlanedCupertinoActionSheet(themeChange, context, controller, categoryModel);
                                                          },
                                                          child:
                                                              Constant.svgPictureShow("assets/icons/icon_more.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, null, null),
                                                        )
                                                      ],
                                                    ),
                                                    Text(
                                                      "${categoryModel.category?.name}".tr,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                        fontSize: 16,
                                                        fontFamily: AppThemeData.boldOpenSans,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    RoundedButtonFill(
                                                      title: 'Start a project'.tr,
                                                      height: 4,
                                                      width: 100,
                                                      textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                      color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02,
                                                      onPress: () {
                                                        Get.to(BusinessListScreen(), arguments: {
                                                          "categoryModel": categoryModel.category!,
                                                          "latLng": null,
                                                          "isZipCode": false,
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                          child: controller.archivedPricingRequestList.isEmpty
                              ? Constant.showEmptyView(message: "You don’t have any archived \nprojects right now.")
                              : ListView.builder(
                                  itemCount: controller.archivedPricingRequestList.length,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemBuilder: (context, index) {
                                    PricingRequestModel categoryModel = controller.archivedPricingRequestList[index];
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        border: Border.all(
                                          color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            NetworkImageWidget(
                                              imageUrl: categoryModel.category!.icon.toString(),
                                              width: 44,
                                              height: 44,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          Constant.formatTimestamp(categoryModel.createdAt!).tr,
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                            fontSize: 12,
                                                            fontFamily: AppThemeData.regularOpenSans,
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Constant.svgPictureShow("assets/icons/icon_more.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, null, null),
                                                      )
                                                    ],
                                                  ),
                                                  Text(
                                                    "${categoryModel.category?.name}".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                      fontSize: 16,
                                                      fontFamily: AppThemeData.boldOpenSans,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: themeChange.getThem() ? AppThemeData.red03 : AppThemeData.red03,
                                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                                      border: Border.all(
                                                        color: themeChange.getThem() ? AppThemeData.red03 : AppThemeData.red03,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                                      child: Text(
                                                        "Currently waiting for replies from surrounding businesses.".tr,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          color: themeChange.getThem() ? AppThemeData.red02 : AppThemeData.red02,
                                                          fontSize: 14,
                                                          fontFamily: AppThemeData.regularOpenSans,
                                                        ),
                                                      ),
                                                    ),
                                                  )
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
          );
        });
  }

  void showCommentCupertinoActionSheet(themeChange, BuildContext context, SeeAllProjectController controller, PricingRequestModel pricingRequestModel) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              ShowToastDialog.showLoader("Please wait");
              pricingRequestModel.status = "archive";
              await FireStoreUtils.setPricingRequest(pricingRequestModel);
              await controller.getAllActiveRequest();
              ShowToastDialog.closeLoader();
            },
            child: Text(
              "Archive".tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: themeChange.getThem() ? AppThemeData.tealDark02 : AppThemeData.teal02,
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
              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
              fontSize: 16,
              fontFamily: AppThemeData.boldOpenSans,
            ),
          ),
        ),
      ),
    );
  }

  void unPlanedCupertinoActionSheet(themeChange, BuildContext context, SeeAllProjectController controller, CategoryPlanModel categoryPlanList) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            onPressed: () async {
              ShowToastDialog.showLoader("Please wait");
              await controller.removePlan(categoryPlanList.category!);
              ShowToastDialog.closeLoader();
              Get.back();
            },
            child: Text(
              "UnPlan".tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: themeChange.getThem() ? AppThemeData.tealDark02 : AppThemeData.teal02,
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
              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
              fontSize: 16,
              fontFamily: AppThemeData.boldOpenSans,
            ),
          ),
        ),
      ),
    );
  }
}
