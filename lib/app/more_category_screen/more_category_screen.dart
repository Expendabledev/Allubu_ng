import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/more_categoy_controller.dart';
import 'package:allubmarket/models/category_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/network_image_widget.dart';

import '../home_screen/business_list_screen.dart';

class MoreCategoryScreen extends StatelessWidget {
  const MoreCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: MoreCategoryController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/icon_left.svg",
                      colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          BlendMode.srcIn),
                    ),
                    Text(
                      "Back".tr,
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
                "More Categories".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark01
                      : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "All Category".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark01
                          : AppThemeData.grey01,
                      fontSize: 14,
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark06
                            : AppThemeData.grey06,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.categoryList.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          CategoryModel categoryModel =
                              controller.categoryList[index];
                          return InkWell(
                            onTap: () async {
                              if (categoryModel.children!.isEmpty) {
                                Get.off(BusinessListScreen(), arguments: {
                                  "categoryModel": categoryModel,
                                  "latLng": null,
                                  "isZipCode": false,
                                });
                              } else {
                                ShowToastDialog.showLoader("Please wait");
                                await controller
                                    .getSubCategory(categoryModel)
                                    .then(
                                  (value) {
                                    ShowToastDialog.closeLoader();
                                    showCategoryBottomSheet(
                                        themeChange, controller, categoryModel);
                                  },
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: NetworkImageWidget(
                                      imageUrl: categoryModel.icon.toString(),
                                      width: 44,
                                      height: 44,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${categoryModel.name}".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark02
                                            : AppThemeData.grey02,
                                        fontSize: 14,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                  ),
                                  categoryModel.children != null &&
                                          categoryModel.children!.isNotEmpty
                                      ? Constant.svgPictureShow(
                                          "assets/icons/content.svg",
                                          themeChange.getThem()
                                              ? AppThemeData.greyDark03
                                              : AppThemeData.grey03,
                                          20,
                                          20,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showCategoryBottomSheet(themeChange, MoreCategoryController controller,
      CategoryModel parentCategoryModel) {
    Get.bottomSheet(
      Container(
        height: Responsive.height(80, Get.context!),
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
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark10
                          : AppThemeData.grey10,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark06
                            : AppThemeData.grey06,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.off(BusinessListScreen(), arguments: {
                          "categoryModel": parentCategoryModel,
                          "latLng": null,
                          "isZipCode": false,
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          children: [
                            ClipOval(
                              child: NetworkImageWidget(
                                imageUrl: parentCategoryModel.icon.toString(),
                                width: 44,
                                height: 44,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                "${parentCategoryModel.name}".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem()
                                      ? AppThemeData.greyDark02
                                      : AppThemeData.grey02,
                                  fontSize: 14,
                                  fontFamily: AppThemeData.boldOpenSans,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "or something more specific...".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark01
                          : AppThemeData.grey01,
                      fontSize: 14,
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark06
                            : AppThemeData.grey06,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: controller.subCategoryList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          CategoryModel categoryModel =
                              controller.subCategoryList[index];
                          return InkWell(
                            onTap: () async {
                              if (categoryModel.children != null &&
                                  categoryModel.children!.isNotEmpty) {
                                ShowToastDialog.showLoader("Please wait");
                                await controller
                                    .getSubCategory(categoryModel)
                                    .then(
                                  (value) {
                                    ShowToastDialog.closeLoader();
                                    showCategoryBottomSheet(
                                        themeChange, controller, categoryModel);
                                  },
                                );
                              } else {
                                Get.off(BusinessListScreen(), arguments: {
                                  "categoryModel": categoryModel,
                                  "latLng": null,
                                  "isZipCode": false,
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: NetworkImageWidget(
                                      imageUrl: categoryModel.icon.toString(),
                                      width: 44,
                                      height: 44,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${categoryModel.name}".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark02
                                            : AppThemeData.grey02,
                                        fontSize: 14,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                  ),
                                  categoryModel.children != null &&
                                          categoryModel.children!.isNotEmpty
                                      ? Constant.svgPictureShow(
                                          "assets/icons/content.svg",
                                          themeChange.getThem()
                                              ? AppThemeData.greyDark03
                                              : AppThemeData.grey03,
                                          20,
                                          20,
                                        )
                                      : SizedBox()
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true, // Allows BottomSheet to take full height
    );
  }
}
