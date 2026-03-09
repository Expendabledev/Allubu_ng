import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/auth_screen/login_screen.dart';
import 'package:allubmarket/app/auth_screen/welcome_screen.dart';
import 'package:allubmarket/app/language_screen/language_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/setting_controller.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/custom_dialog_box.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/preferences.dart';

class SettingScreens extends StatelessWidget {
  const SettingScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SettingsController(),
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
                "Settings".tr,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                width: Responsive.width(100, context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark10
                      : AppThemeData.grey10,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(LanguageScreen());
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: ShapeDecoration(
                                color: themeChange.getThem()
                                    ? AppThemeData.greyDark09
                                    : AppThemeData.grey09,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(72),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Constant.svgPictureShow(
                                    "assets/icons/global-line.svg",
                                    themeChange.getThem()
                                        ? AppThemeData.greyDark01
                                        : AppThemeData.grey01,
                                    20,
                                    20),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                "Change Language".tr,
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
                            Icon(Icons.chevron_right)
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: ShapeDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark09
                                  : AppThemeData.grey09,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(72),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Constant.svgPictureShow(
                                  "assets/icons/dark-mode.svg",
                                  themeChange.getThem()
                                      ? AppThemeData.greyDark01
                                      : AppThemeData.grey01,
                                  20,
                                  20),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              "Light Dark Mode".tr,
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
                          Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: controller.isDarkModeSwitch.value,
                              activeTrackColor: AppThemeData.red02,
                              onChanged: (value) {
                                controller.isDarkModeSwitch.value = value;
                                if (controller.isDarkModeSwitch.value == true) {
                                  Preferences.setString(
                                      Preferences.themKey, "Dark");
                                  themeChange.darkTheme = 0;
                                } else if (controller.isDarkMode.value ==
                                    "Light") {
                                  Preferences.setString(
                                      Preferences.themKey, "Light");
                                  themeChange.darkTheme = 1;
                                } else {
                                  Preferences.setString(
                                      Preferences.themKey, "");
                                  themeChange.darkTheme = 2;
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FireStoreUtils.getCurrentUid() != ''
                          ? InkWell(
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogBox(
                                        title: "Delete Account".tr,
                                        descriptions:
                                            "This will permanently delete your account and all associated data. Are you sure?"
                                                .tr,
                                        positiveString: "OK".tr,
                                        negativeString: "Cancel".tr,
                                        positiveClick: () async {
                                          ShowToastDialog.showLoader(
                                              "Please wait".tr);
                                          await FireStoreUtils.deleteUser()
                                              .then((value) {
                                            ShowToastDialog.closeLoader();
                                            if (value == true) {
                                              ShowToastDialog.showToast(
                                                  "Account deleted successfully"
                                                      .tr);
                                              Get.offAll(const WelcomeScreen());
                                            } else {
                                              ShowToastDialog.showToast(
                                                  "Contact Administrator".tr);
                                            }
                                          });
                                        },
                                        negativeClick: () {
                                          Get.back();
                                        },
                                        img: Image.asset(
                                          'assets/images/ic_delete.png',
                                          height: 40,
                                          width: 40,
                                        ),
                                      );
                                    });
                              },
                              child: Row(
                                children: [
                                  Container(
                                    decoration: ShapeDecoration(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark09
                                          : AppThemeData.grey09,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(72),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Constant.svgPictureShow(
                                          "assets/icons/icon_delete.svg",
                                          themeChange.getThem()
                                              ? AppThemeData.red02
                                              : AppThemeData.red02,
                                          20,
                                          20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Delete Account".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.red02
                                          : AppThemeData.red02,
                                      fontSize: 16,
                                      fontFamily: AppThemeData.semiboldOpenSans,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          if (FireStoreUtils.getCurrentUid() != '') {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomDialogBox(
                                    title: "Log out".tr,
                                    descriptions:
                                        "You will be signed out of the app. Tap Log Out to confirm."
                                            .tr,
                                    positiveString: "Log out".tr,
                                    negativeString: "Cancel".tr,
                                    positiveClick: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Preferences.clearKeyData(
                                          Preferences.isLogin);
                                      Get.offAll(WelcomeScreen());
                                    },
                                    negativeClick: () {
                                      Get.back();
                                    },
                                    img: Image.asset(
                                      'assets/images/ic_logout_dialog.png',
                                      height: 40,
                                      width: 40,
                                    ),
                                  );
                                });
                          } else {
                            Get.to(const LoginScreen());
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: ShapeDecoration(
                                color: themeChange.getThem()
                                    ? AppThemeData.greyDark09
                                    : AppThemeData.grey09,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(72),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Constant.svgPictureShow(
                                    "assets/icons/icon_logout.svg",
                                    themeChange.getThem()
                                        ? AppThemeData.red02
                                        : AppThemeData.red02,
                                    20,
                                    20),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              FireStoreUtils.getCurrentUid() != ''
                                  ? 'Logout'.tr
                                  : 'Login'.tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: themeChange.getThem()
                                    ? AppThemeData.red02
                                    : AppThemeData.red02,
                                fontSize: 16,
                                fontFamily: AppThemeData.semiboldOpenSans,
                              ),
                            ),
                          ],
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
