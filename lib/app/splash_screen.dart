import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/splash_controller.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import '../themes/responsive.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (controller) {
        return Scaffold(
          body: Container(
            width: Responsive.width(100, context),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, 1.00),
                end: Alignment(0, -1),
                colors: [Color(0xFFFF0000), Color(0xFFFF005D)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  NetworkImageWidget(
                    imageUrl: Constant.appLogo,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    color: AppThemeData.grey10,
                    errorWidget: Constant.svgPictureShow(
                      "assets/images/ic_logo.svg",
                      AppThemeData.grey10,
                      40,
                      40,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    Constant.applicationName.tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppThemeData.grey10,
                      fontSize: 24,
                      fontFamily: AppThemeData.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
