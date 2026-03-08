import 'package:badges/badges.dart' as badges;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/home_screen/business_list_screen.dart';
import 'package:yelpify/app/project_screen/project_details_screen.dart';
import 'package:yelpify/app/project_screen/see_all_project_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/project_controller.dart';
import 'package:yelpify/models/categiry_plan_model.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/models/pricing_request_model.dart';
import 'package:yelpify/service/ad_manager.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/round_button_border.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ProjectController(),
        builder: (controller) {
          return controller.isLoading.value
              ? Constant.loader()
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                    centerTitle: false,
                    leadingWidth: 120,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(4.0),
                      child: Container(
                        color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                        height: 2.0,
                      ),
                    ),
                    actions: [],
                    title: Text(
                      'user_project'.trParams({
                        'name': controller.userModel.value.fullName(),
                      }).tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                        fontSize: 20,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await controller.getAddPlanList();
                        await controller.getAllActiveRequest();
                      },
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          if (controller.activeSentRequest.isEmpty)
                            SizedBox()
                          else
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "Active".tr,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                              fontSize: 16,
                                              fontFamily: AppThemeData.boldOpenSans,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(SeeAllPlanedScreen(), arguments: {"type": "active"});
                                          },
                                          child: Text(
                                            "See all".tr,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.teal02 : AppThemeData.teal02,
                                              fontSize: 14,
                                              fontFamily: AppThemeData.boldOpenSans,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(),
                                    ),
                                    ListView.builder(
                                      itemCount: controller.activeSentRequest.length > 2 ? 2 : controller.activeSentRequest.length,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        PricingRequestModel pricingRequestModel = controller.activeSentRequest[index];
                                        return InkWell(
                                          onTap: () {
                                            Get.to(ProjectDetailsScreen(), arguments: {"pricingRequestModel": pricingRequestModel});
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 20),
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
                                                            child: Constant.svgPictureShow(
                                                                "assets/icons/icon_more.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, null, null),
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
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          controller.categoryPlanList.isEmpty
                              ? SizedBox()
                              : Container(
                                  decoration: BoxDecoration(
                                    color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Planned".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData.boldOpenSans,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Get.to(SeeAllPlanedScreen(), arguments: {"type": "planed"});
                                              },
                                              child: Text(
                                                "See all".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.teal02 : AppThemeData.teal02,
                                                  fontSize: 14,
                                                  fontFamily: AppThemeData.boldOpenSans,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                        ListView.builder(
                                          itemCount: controller.categoryPlanList.length > 2 ? 2 : controller.categoryPlanList.length,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            CategoryPlanModel categoryModel = controller.categoryPlanList[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(bottom: 20),
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
                                                              child: Constant.svgPictureShow(
                                                                  "assets/icons/icon_more.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, null, null),
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
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "What’s next on your list?".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                              fontSize: 20,
                              fontFamily: AppThemeData.boldOpenSans,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: AdManager.bannerAdWidget(),
                                  ),
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.categoryList.length > 3 ? 3 : controller.categoryList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      CategoryModel categoryModel = controller.categoryList[index];
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                NetworkImageWidget(
                                                  imageUrl: categoryModel.icon.toString(),
                                                  width: 44,
                                                  height: 44,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${categoryModel.name}".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                      fontSize: 16,
                                                      fontFamily: AppThemeData.boldOpenSans,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                RoundedButtonFill(
                                                  title: 'Start a project'.tr,
                                                  height: 4,
                                                  width: 35,
                                                  textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                  color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02,
                                                  onPress: () {
                                                    Get.to(BusinessListScreen(), arguments: {
                                                      "categoryModel": categoryModel,
                                                      "latLng": null,
                                                      "isZipCode": false,
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                controller.categoryPlanList.where((p0) => p0.category?.slug == categoryModel.slug).isNotEmpty
                                                    ? RoundedButtonBorder(
                                                        title: 'Added'.tr,
                                                        height: 4,
                                                        width: 35,
                                                        isRight: false,
                                                        icon: Icon(
                                                          Icons.check,
                                                          color: themeChange.getThem() ? AppThemeData.green02 : AppThemeData.green02,
                                                        ),
                                                        borderColor: themeChange.getThem() ? AppThemeData.green02 : AppThemeData.green02,
                                                        textColor: themeChange.getThem() ? AppThemeData.green02 : AppThemeData.green02,
                                                        color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                        onPress: () {
                                                          controller.removePlan(categoryModel);
                                                        },
                                                      )
                                                    : RoundedButtonFill(
                                                        title: 'Add to Plan'.tr,
                                                        height: 4,
                                                        width: 30,
                                                        textColor: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                        color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
                                                        onPress: () {
                                                          controller.addAsPlan(categoryModel);
                                                        },
                                                      ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Hire a local pro today".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                              fontSize: 20,
                              fontFamily: AppThemeData.boldOpenSans,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: GridView.builder(
                                shrinkWrap: true,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, // Adjust to match your design
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1,
                                ),
                                padding: EdgeInsets.zero,
                                itemCount: controller.categoryList.length,
                                itemBuilder: (context, index) {
                                  CategoryModel categoryModel = controller.categoryList[index];
                                  return InkWell(
                                    onTap: () {
                                      Get.to(BusinessListScreen(), arguments: {
                                        "categoryModel": categoryModel,
                                        "latLng": null,
                                        "isZipCode": false,
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        NetworkImageWidget(
                                          imageUrl: categoryModel.icon.toString(),
                                          width: 40,
                                          height: 40,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          categoryModel.name.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
        });
  }

  void showCommentCupertinoActionSheet(themeChange, BuildContext context, ProjectController controller, PricingRequestModel pricingRequestModel) {
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
              Get.back();
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

  void unPlanedCupertinoActionSheet(themeChange, BuildContext context, ProjectController controller, CategoryPlanModel categoryPlanList) {
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
