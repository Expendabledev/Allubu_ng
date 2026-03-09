import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/add_menu_photos/item_list_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/add_menu_photo_controller.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';

import 'upload_menu_screen.dart';

class AddMenuPhotos extends StatelessWidget {
  const AddMenuPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddMenuPhotoController(),
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
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_close.svg",
                        width: 22,
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.greyDark06
                              : AppThemeData.grey01,
                          BlendMode.srcIn,
                        ),
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
                "Add Menu".tr,
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
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose How to Add Menu Items".tr,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: Column(
                              children: [
                                controller.hasMenuItem()
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(ItemListScreen());
                                        },
                                        child: Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark09
                                                        : AppThemeData.grey09),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Constant.svgPictureShow(
                                                      "assets/icons/icon_write.svg",
                                                      themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark03
                                                          : AppThemeData.grey03,
                                                      22,
                                                      22),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Add Item".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData
                                                      .semiboldOpenSans,
                                                ),
                                              ),
                                            ),
                                            Constant.svgPictureShow(
                                                "assets/icons/icon_right.svg",
                                                themeChange.getThem()
                                                    ? AppThemeData.greyDark03
                                                    : AppThemeData.grey03,
                                                20,
                                                20)
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                                SizedBox(
                                  height: 20,
                                ),
                                controller.hasMenuPhotos()
                                    ? InkWell(
                                        onTap: () {
                                          Get.to(UploadMenuScreen());
                                        },
                                        child: Row(
                                          children: [
                                            ClipOval(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark09
                                                        : AppThemeData.grey09),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Constant.svgPictureShow(
                                                      "assets/icons/icon_upload.svg",
                                                      themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark03
                                                          : AppThemeData.grey03,
                                                      22,
                                                      22),
                                                ),
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
                                                  Text(
                                                    "Upload Menu".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark01
                                                          : AppThemeData.grey01,
                                                      fontSize: 16,
                                                      fontFamily: AppThemeData
                                                          .semiboldOpenSans,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Only Image".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark04
                                                          : AppThemeData.grey04,
                                                      fontSize: 12,
                                                      fontFamily: AppThemeData
                                                          .semiboldOpenSans,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Constant.svgPictureShow(
                                                "assets/icons/icon_right.svg",
                                                themeChange.getThem()
                                                    ? AppThemeData.greyDark03
                                                    : AppThemeData.grey03,
                                                20,
                                                20)
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          );
        });
  }
}
