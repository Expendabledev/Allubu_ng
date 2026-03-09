import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/auth_screen/singup_screen.dart';
import 'package:allubmarket/app/dashboard_screen/dashboard_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/otp_controller.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/utils/notification_service.dart';
import 'package:allubmarket/widgets/debounced_inkwell.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OtpController(),
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Verify Your Account".tr,
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
                  // OTP Input using standard TextFields
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: controller.otpController.value,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.center,
                      maxLength: 6,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark01
                            : AppThemeData.grey01,
                        fontFamily: AppThemeData.regular,
                        fontSize: 20,
                        letterSpacing: 8,
                      ),
                      decoration: InputDecoration(
                        hintText: "------",
                        hintStyle: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark04
                              : AppThemeData.grey04,
                          letterSpacing: 8,
                        ),
                        counterText: '',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: themeChange.getThem()
                                ? AppThemeData.grey05
                                : AppThemeData.grey05,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppThemeData.red02,
                          ),
                        ),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: "${'Didn\'t receive a code?'.tr} ",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: AppThemeData.regularOpenSans,
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark10
                            : AppThemeData.grey01,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              controller.reSendOTP();
                            },
                          text: 'Resend OTP'.tr,
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
                  SizedBox(
                    height: 20,
                  ),
                  RoundedButtonFill(
                    title: 'Verify & Continue'.tr,
                    height: 5.5,
                    textColor: themeChange.getThem()
                        ? AppThemeData.grey10
                        : AppThemeData.grey10,
                    color: themeChange.getThem()
                        ? AppThemeData.redDark02
                        : AppThemeData.red02,
                    onPress: () async {
                      if (controller.otpController.value.text.length == 6) {
                        ShowToastDialog.showLoader("Verify OTP.".tr);

                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: controller.verificationId.value,
                                smsCode: controller.otpController.value.text);
                        String fcmToken = await NotificationService.getToken();
                        await FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) async {
                          if (value.additionalUserInfo!.isNewUser) {
                            UserModel userModel = UserModel();
                            userModel.id = value.user!.uid;
                            userModel.countryCode =
                                controller.countryCode.value;
                            userModel.countryISOCode =
                                controller.countryISOCode.value;
                            userModel.phoneNumber =
                                controller.phoneNumber.value;
                            userModel.loginType = Constant.phoneLoginType;
                            userModel.fcmToken = fcmToken;

                            ShowToastDialog.closeLoader();
                            Get.off(const SingUpScreen(), arguments: {
                              "userModel": userModel,
                            });
                          } else {
                            await FireStoreUtils.userExistOrNot(value.user!.uid)
                                .then((userExit) async {
                              ShowToastDialog.closeLoader();
                              if (userExit == true) {
                                UserModel? userModel =
                                    await FireStoreUtils.getUserProfile(
                                        value.user!.uid);
                                if (userModel != null) {
                                  if (userModel.isActive == true) {
                                    Get.offAll(const DashBoardScreen());
                                  } else {
                                    await FirebaseAuth.instance.signOut();
                                    ShowToastDialog.showToast(
                                        "This user is disable please contact administrator"
                                            .tr);
                                  }
                                }
                              } else {
                                UserModel userModel = UserModel();
                                userModel.id = value.user!.uid;
                                userModel.countryCode =
                                    controller.countryCode.value;
                                userModel.countryISOCode =
                                    controller.countryISOCode.value;
                                userModel.phoneNumber =
                                    controller.phoneNumber.value;
                                userModel.loginType = Constant.phoneLoginType;
                                userModel.fcmToken = fcmToken;

                                Get.off(const SingUpScreen(), arguments: {
                                  "userModel": userModel,
                                });
                              }
                            });
                          }
                        }).catchError((error) {
                          ShowToastDialog.closeLoader();
                          ShowToastDialog.showToast("Invalid code".tr);
                        });
                      } else {
                        ShowToastDialog.showToast("Enter valid otp".tr);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
