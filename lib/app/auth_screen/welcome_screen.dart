import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/auth_screen/login_screen.dart';
import 'package:allubmarket/app/auth_screen/singup_screen.dart';
import 'package:allubmarket/app/dashboard_screen/dashboard_screen.dart';
import 'package:allubmarket/app/terms_and_condition/terms_and_condition_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/welcome_controller.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/round_button_border.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/network_image_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
      init: WelcomeController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: themeChange.getThem()
              ? AppThemeData.greyDark10
              : AppThemeData.grey10,
          appBar: AppBar(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.greyDark10
                : AppThemeData.grey10,
            leadingWidth: 400,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  NetworkImageWidget(
                    imageUrl: Constant.appLogo,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorWidget: Constant.svgPictureShow(
                      "assets/images/ic_logo.svg",
                      null,
                      40,
                      40,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    Constant.applicationName.tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppThemeData.red02,
                      fontSize: 24,
                      fontFamily: AppThemeData.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'welcome_to_app'.trParams({
                            'appName': Constant.applicationName,
                          }).tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                            fontSize: 28,
                            fontFamily: AppThemeData.bold,
                          ),
                        ),
                        Text(
                          "Discover & Share Local Favorites Let’s get Started."
                              .tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark03
                                : AppThemeData.grey03,
                            fontSize: 14,
                            fontFamily: AppThemeData.regular,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Image.asset("assets/images/welcome_illustrator.png"),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        text: 'agree_to_app'.trParams({
                          'appName': Constant.applicationName,
                        }).tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppThemeData.regularOpenSans,
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark04
                              : AppThemeData.grey04,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const TermsAndConditionScreen(
                                    type: "terms"));
                              },
                            text: ' Terms of Service '.tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.tealDark02
                                  : AppThemeData.teal02,
                              fontSize: 14,
                              fontFamily: AppThemeData.semiboldOpenSans,
                            ),
                          ),
                          TextSpan(
                            text: 'acknowledge_app'.trParams({
                              'appName': Constant.applicationName,
                            }).tr,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: AppThemeData.regularOpenSans,
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark04
                                  : AppThemeData.grey04,
                            ),
                          ),
                          TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.to(const TermsAndConditionScreen(
                                    type: "privacy"));
                              },
                            text: ' Privacy Policy.'.tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.tealDark02
                                  : AppThemeData.teal02,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              fontFamily: AppThemeData.semiboldOpenSans,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RoundedButtonBorder(
                      title: 'Go to Home Page'.tr,
                      isRight: false,
                      textColor: themeChange.getThem()
                          ? AppThemeData.greyDark01
                          : AppThemeData.grey01,
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark10
                          : AppThemeData.grey10,
                      borderColor: themeChange.getThem()
                          ? AppThemeData.greyDark06
                          : AppThemeData.grey06,
                      onPress: () {
                        Get.offAll(DashBoardScreen());
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RoundedButtonBorder(
                      icon: SvgPicture.asset("assets/icons/ic_google.svg.svg"),
                      title: 'Continue with Google'.tr,
                      isRight: false,
                      textColor: themeChange.getThem()
                          ? AppThemeData.greyDark01
                          : AppThemeData.grey01,
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark10
                          : AppThemeData.grey10,
                      borderColor: themeChange.getThem()
                          ? AppThemeData.greyDark06
                          : AppThemeData.grey06,
                      onPress: () {
                        controller.loginWithGoogle();
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Platform.isIOS
                        ? RoundedButtonFill(
                            icon: SvgPicture.asset(
                              "assets/icons/apple.svg",
                              colorFilter: ColorFilter.mode(
                                  themeChange.getThem()
                                      ? AppThemeData.greyDark10
                                      : AppThemeData.grey10,
                                  BlendMode.srcIn),
                            ),
                            title: 'Continue with Apple'.tr,
                            isRight: false,
                            textColor: themeChange.getThem()
                                ? AppThemeData.greyDark10
                                : AppThemeData.grey10,
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                            onPress: () {
                              controller.loginWithApple();
                            },
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RoundedButtonFill(
                            title: 'Log in'.tr,
                            textColor: themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark07
                                : AppThemeData.grey07,
                            onPress: () {
                              Get.to(LoginScreen());
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: RoundedButtonFill(
                            title: 'Signup'.tr,
                            textColor: themeChange.getThem()
                                ? AppThemeData.greyDark10
                                : AppThemeData.grey10,
                            color: themeChange.getThem()
                                ? AppThemeData.redDark02
                                : AppThemeData.red02,
                            onPress: () {
                              Get.to(SingUpScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
