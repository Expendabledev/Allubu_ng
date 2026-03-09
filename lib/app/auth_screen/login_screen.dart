import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/auth_screen/singup_screen.dart';
import 'package:allubmarket/app/forgot_password_screen/forgot_password_screen.dart';
import 'package:allubmarket/app/terms_and_condition/terms_and_condition_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/login_controller.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/round_button_border.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/themes/text_field_widget.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/widgets/debounced_inkwell.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: LoginController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              leading: DebouncedInkWell(
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
              title: Row(
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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppThemeData.grey07,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildButton(
                                  "Email Address".tr,
                                  controller.isEmailSelected.value,
                                  true,
                                  controller),
                              buildButton(
                                  "Phone number".tr,
                                  !controller.isEmailSelected.value,
                                  false,
                                  controller),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        controller.isEmailSelected.value
                            ? "Enter your email to log in".tr
                            : "Enter your mobile no. to log in".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark02
                              : AppThemeData.grey02,
                          fontSize: 20,
                          fontFamily: AppThemeData.bold,
                        ),
                      ),
                    ),
                    controller.isEmailSelected.value
                        ? Column(
                            children: [
                              TextFieldWidget(
                                controller:
                                    controller.emailTextFieldController.value,
                                hintText: 'Email'.tr,
                              ),
                              TextFieldWidget(
                                controller: controller
                                    .passwordTextFieldController.value,
                                hintText: 'Password'.tr,
                                obscureText: controller.passwordVisible.value,
                                suffix: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: DebouncedInkWell(
                                      onTap: () {
                                        controller.passwordVisible.value =
                                            !controller.passwordVisible.value;
                                      },
                                      child: controller.passwordVisible.value
                                          ? SvgPicture.asset(
                                              "assets/icons/ic_password_show.svg",
                                              colorFilter: ColorFilter.mode(
                                                themeChange.getThem()
                                                    ? AppThemeData.greyDark06
                                                    : AppThemeData.grey01,
                                                BlendMode.srcIn,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              "assets/icons/ic_password_close.svg",
                                              colorFilter: ColorFilter.mode(
                                                themeChange.getThem()
                                                    ? AppThemeData.greyDark06
                                                    : AppThemeData.grey01,
                                                BlendMode.srcIn,
                                              ),
                                            )),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(const ForgotPasswordScreen());
                                  },
                                  child: Text(
                                    "Forgot Password".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.tealDark02
                                          : AppThemeData.teal02,
                                      fontSize: 14,
                                      fontFamily: AppThemeData.semiboldOpenSans,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RoundedButtonFill(
                                title: 'Log in'.tr,
                                height: 5.5,
                                textColor: themeChange.getThem()
                                    ? AppThemeData.greyDark10
                                    : AppThemeData.grey10,
                                color: themeChange.getThem()
                                    ? AppThemeData.redDark02
                                    : AppThemeData.red02,
                                onPress: () {
                                  controller.signInWithEmailPassword();
                                },
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              TextFieldWidget(
                                controller: controller
                                    .phoneNumberTextFieldController.value,
                                hintText: 'Enter mobile number'.tr,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]')),
                                ],
                                prefix: CountryCodePicker(
                                  onInit: (value) {
                                    controller
                                            .countryCodeController.value.text =
                                        value?.dialCode ??
                                            Constant.defaultCountryCode;
                                    controller.countryISOCodeController.value
                                            .text =
                                        value?.code ??
                                            Constant.defaultCountryCode;
                                  },
                                  onChanged: (value) {
                                    controller.countryCodeController.value
                                        .text = value.dialCode.toString();
                                    controller.countryISOCodeController.value
                                            .text =
                                        value.code ??
                                            Constant.defaultCountryCode;
                                  },
                                  dialogTextStyle: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark01
                                          : AppThemeData.grey01,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: AppThemeData.medium),
                                  dialogBackgroundColor: themeChange.getThem()
                                      ? AppThemeData.greyDark10
                                      : AppThemeData.grey10,
                                  initialSelection: controller
                                      .countryISOCodeController.value.text,
                                  comparator: (a, b) =>
                                      b.name!.compareTo(a.name.toString()),
                                  flagDecoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(2)),
                                  ),
                                  textStyle: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark01
                                        : AppThemeData.grey01,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                  searchDecoration: InputDecoration(
                                    iconColor: themeChange.getThem()
                                        ? AppThemeData.grey08
                                        : AppThemeData.grey08,
                                  ),
                                  searchStyle: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark01
                                        : AppThemeData.grey01,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppThemeData.medium,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RoundedButtonFill(
                                title: 'Send OTP'.tr,
                                height: 5.5,
                                textColor: themeChange.getThem()
                                    ? AppThemeData.greyDark10
                                    : AppThemeData.grey10,
                                color: themeChange.getThem()
                                    ? AppThemeData.redDark02
                                    : AppThemeData.red02,
                                onPress: () {
                                  if (controller.phoneNumberTextFieldController
                                      .value.text.isEmpty) {
                                    ShowToastDialog.showToast(
                                        "Please enter a phone number");
                                  } else {
                                    controller.sendCode();
                                  }
                                },
                              ),
                            ],
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(
                        text:
                            "${'${'By continuing, you agree to'.tr} ${Constant.applicationName}'.tr} ",
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
                            text: 'Terms of Service'.tr,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.tealDark02
                                  : AppThemeData.teal02,
                              fontSize: 14,
                              fontFamily: AppThemeData.semiboldOpenSans,
                            ),
                          ),
                          TextSpan(
                            text:
                                " ${"${'and acknowledge'.tr} ${Constant.applicationName}".tr} ",
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
                            text: 'Privacy Policy.'.tr,
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
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'dont_have_account'
                          .trParams({'appName': Constant.applicationName}),
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
                              Get.to(SingUpScreen());
                            },
                          text: ' Sign up'.tr,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.tealDark02
                                : AppThemeData.teal02,
                            fontSize: 14,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget buildButton(
      String text, bool isSelected, bool isLeft, LoginController controller) {
    return GestureDetector(
      onTap: () {
        controller.isEmailSelected.value = isLeft;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppThemeData.grey01 : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
              color: isSelected ? AppThemeData.grey10 : AppThemeData.grey03,
              fontSize: 14,
              fontFamily: AppThemeData.mediumOpenSans),
        ),
      ),
    );
  }
}
