import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/singup_controller.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/round_button_border.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';

class SingUpScreen extends StatelessWidget {
  const SingUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SignupController(),
        builder: (controller) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
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
                        colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, BlendMode.srcIn),
                      ),
                      Text(
                        "Back".tr,
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
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(4.0),
                  child: Container(
                    color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
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
                        child: Text(
                          controller.isAddAbusinessBtn.value == true ? 'Create an account to add your business'.tr : "Sign up with email".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                            fontSize: 20,
                            fontFamily: AppThemeData.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              controller: controller.firstNameTextFieldController.value,
                              hintText: 'First Name'.tr,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextFieldWidget(
                              controller: controller.lastNameTextFieldController.value,
                              hintText: 'Last Name'.tr,
                            ),
                          ),
                        ],
                      ),
                      TextFieldWidget(
                        controller: controller.emailTextFieldController.value,
                        hintText: 'Email address'.tr,
                      ),
                      controller.loginType.value == Constant.emailLoginType
                          ? TextFieldWidget(
                              controller: controller.passwordTextFieldController.value,
                              hintText: 'Password'.tr,
                              obscureText: controller.passwordVisible.value,
                              suffix: Padding(
                                padding: const EdgeInsets.all(12),
                                child: DebouncedInkWell(
                                    onTap: () {
                                      controller.passwordVisible.value = !controller.passwordVisible.value;
                                    },
                                    child: controller.passwordVisible.value
                                        ? SvgPicture.asset(
                                            "assets/icons/ic_password_show.svg",
                                            colorFilter: ColorFilter.mode(
                                              themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01,
                                              BlendMode.srcIn,
                                            ),
                                          )
                                        : SvgPicture.asset(
                                            "assets/icons/ic_password_close.svg",
                                            colorFilter: ColorFilter.mode(
                                              themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01,
                                              BlendMode.srcIn,
                                            ),
                                          )),
                              ),
                            )
                          : SizedBox(),
                      TextFieldWidget(
                        controller: controller.phoneNumberTextFieldController.value,
                        hintText: 'Enter mobile number'.tr,
                        readOnly: controller.loginType.value == Constant.phoneLoginType ? true : false,
                        enable: controller.loginType.value == Constant.phoneLoginType ? false : true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        prefix: CountryCodePicker(
                          onInit: (value) {
                            controller.countryCodeController.value.text = value?.dialCode ?? Constant.defaultCountryCode;
                            controller.countryISOCodeController.value.text = value?.code ?? Constant.defaultCountryCode;
                          },
                          onChanged: (value) {
                            controller.countryCodeController.value.text = value.dialCode.toString();
                            controller.countryISOCodeController.value.text = value.code ?? Constant.defaultCountryCode;
                          },
                          dialogTextStyle: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                          dialogBackgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                          initialSelection: controller.countryISOCodeController.value.text,
                          comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                          flagDecoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          textStyle: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppThemeData.medium,
                          ),
                          searchDecoration: InputDecoration(
                            iconColor: themeChange.getThem() ? AppThemeData.grey08 : AppThemeData.grey08,
                          ),
                          searchStyle: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppThemeData.medium,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedButtonFill(
                        title: 'Sign up'.tr,
                        height: 5.5,
                        textColor: themeChange.getThem() ? AppThemeData.grey10 : AppThemeData.grey10,
                        color: themeChange.getThem() ? AppThemeData.red02 : AppThemeData.red02,
                        onPress: () {
                          if (controller.loginType.value == Constant.emailLoginType) {
                            if (controller.firstNameTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Enter first name".tr);
                            } else if (controller.lastNameTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Enter last name".tr);
                            } else if (controller.emailTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Enter email address".tr);
                            } else if (controller.passwordTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Enter Password".tr);
                            } else if (controller.phoneNumberTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Enter mobile number".tr);
                            } else {
                              controller.signUpWithEmailPassword();
                            }
                          } else {
                            if (controller.firstNameTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Enter first name".tr);
                            } else if (controller.lastNameTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Enter last name".tr);
                            } else if (controller.emailTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Enter email address".tr);
                            } else if (controller.phoneNumberTextFieldController.value.text.isEmpty) {
                              ShowToastDialog.showToast("Enter mobile number".tr);
                            } else {
                              controller.createAccount();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    if (controller.isAddAbusinessBtn.value == true)
                      RoundedButtonBorder(
                        icon: SvgPicture.asset("assets/icons/ic_google.svg.svg"),
                        title: 'Continue with Google'.tr,
                        isRight: false,
                        textColor: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                        color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                        borderColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                        onPress: () {
                          controller.loginWithGoogle();
                        },
                      ),
                    if (Platform.isIOS && controller.isAddAbusinessBtn.value == true)
                      SizedBox(
                        height: 10,
                      ),
                    Platform.isIOS && controller.isAddAbusinessBtn.value == true
                        ? RoundedButtonFill(
                            icon: SvgPicture.asset(
                              "assets/icons/apple.svg",
                              colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10, BlendMode.srcIn),
                            ),
                            title: 'Continue with Apple'.tr,
                            isRight: false,
                            textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                            onPress: () {
                              controller.loginWithApple();
                            },
                          )
                        : SizedBox(),
                    if (controller.isAddAbusinessBtn.value == true)
                      SizedBox(
                        height: 10,
                      ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: controller.isAddAbusinessBtn.value == true ? 20 : 10),
                      child: Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: 'already_have_account'.trParams({'appName': Constant.applicationName}).tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppThemeData.regularOpenSans,
                            color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.back();
                                },
                              text: ' Sign In'.tr,
                              style: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.tealDark02 : AppThemeData.teal02,
                                fontSize: 14,
                                fontFamily: AppThemeData.semiboldOpenSans,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])));
        });
  }
}
