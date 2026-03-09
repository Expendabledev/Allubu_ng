import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/location_permission_controller.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: LocationPermissionController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.greyDark10
                : AppThemeData.grey10,
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              leading: SvgPicture.asset("assets/icons/navigation.svg"),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enable Location".tr,
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
                          'location_hint'.trParams({
                            'appName': Constant.applicationName,
                          }).tr,
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
                        Image.asset(
                            "assets/images/location_permission_image.png"),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          text: 'location_info'.trParams({
                            'appName': Constant.applicationName,
                          }),
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppThemeData.regularOpenSans,
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark04
                                : AppThemeData.grey04,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = () {},
                              text: 'Learn more'.tr,
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
                        height: 30,
                      ),
                      RoundedButtonFill(
                        title: 'OK, I understand'.tr,
                        isRight: false,
                        textColor: themeChange.getThem()
                            ? AppThemeData.grey10
                            : AppThemeData.grey10,
                        color: themeChange.getThem()
                            ? AppThemeData.redDark02
                            : AppThemeData.red02,
                        onPress: () {
                          controller.requestPermission();
                        },
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
        });
  }
}
