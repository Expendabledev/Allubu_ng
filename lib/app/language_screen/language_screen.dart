import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/language_controller.dart';
import 'package:allubmarket/models/language_model.dart';
import 'package:allubmarket/service/localization_service.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/utils/preferences.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<LanguageController>(
        init: LanguageController(),
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
                        "assets/icons/icon_left.svg",
                        colorFilter: ColorFilter.mode(
                            themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                            BlendMode.srcIn),
                        width: 22,
                      ),
                      SizedBox(
                        width: 10,
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
              ),
              title: Text(
                "Change language".tr,
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
              child: controller.languageList.isEmpty
                  ? Constant.showEmptyView(message: "Language not found")
                  : Container(
                      width: Responsive.width(100, context),
                      decoration: BoxDecoration(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark10
                              : AppThemeData.grey10,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: ListView.builder(
                          itemCount: controller.languageList.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            LanguageModel languageModel =
                                controller.languageList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Obx(
                                () => InkWell(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () {
                                    controller.selectedLanguage.value =
                                        languageModel;
                                  },
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: NetworkImageWidget(
                                                  imageUrl: languageModel.image
                                                      .toString(),
                                                  width: 60,
                                                  fit: BoxFit.cover)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              languageModel.title.toString(),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.grey10
                                                      : AppThemeData.grey01,
                                                  fontFamily:
                                                      AppThemeData.medium),
                                            ),
                                          ),
                                          Radio(
                                            value: languageModel,
                                            groupValue: controller
                                                .selectedLanguage.value,
                                            activeColor: AppThemeData.red02,
                                            onChanged: (value) {
                                              controller.selectedLanguage
                                                  .value = value!;
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 50, right: 16, left: 16),
              child: RoundedButtonFill(
                title: 'Save Language'.tr,
                height: 5.5,
                textColor: themeChange.getThem()
                    ? AppThemeData.greyDark10
                    : AppThemeData.grey10,
                color: themeChange.getThem()
                    ? AppThemeData.redDark02
                    : AppThemeData.red02,
                onPress: () {
                  LocalizationService().changeLocale(
                      controller.selectedLanguage.value.slug.toString());
                  Preferences.setString(
                    Preferences.languageCodeKey,
                    jsonEncode(
                      controller.selectedLanguage.value,
                    ),
                  );
                  Get.back();
                },
              ),
            ),
          );
        });
  }
}
