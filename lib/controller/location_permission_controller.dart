import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:allubmarket/app/auth_screen/welcome_screen.dart';
import 'package:allubmarket/app/dashboard_screen/dashboard_screen.dart';
import 'package:allubmarket/app/location_permission_screen/pincode_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/utils.dart';

class LocationPermissionController extends GetxController {
  Future<void> requestPermission() async {
    ShowToastDialog.showLoader("Please wait");
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      ShowToastDialog.closeLoader();
      _showEnableGPSDialog();
      return;
    } else {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        bool isLogin = await FireStoreUtils.isLogin();
        Constant.currentLocation = await Utils.getCurrentLocation();
        ShowToastDialog.closeLoader();
        if (isLogin) {
          Get.offAll(const DashBoardScreen());
        } else {
          await FirebaseAuth.instance.signOut();
          Get.offAll(const WelcomeScreen());
        }
      } else {
        ShowToastDialog.closeLoader();
        _showPermissionDeniedDialog();
      }
    }
  }

  /// Show Permission Denied Dialog
  void _showPermissionDeniedDialog() {
    Get.defaultDialog(
      title: "Permission Required",
      middleText:
          "We need your location to show nearby businesses and ensure accurate results. Please allow access when prompted.",
      barrierDismissible: false,
      confirm: RoundedButtonFill(
        onPress: () async {
          Get.back(); // Close dialog
          await Geolocator.openAppSettings();
          Future.delayed(Duration(seconds: 3), () async {
            await requestPermission(); // Recheck when returning from settings
          });
        },
        title: 'Allow Location',
        width: 40,
        height: 5,
        color: AppThemeData.red02,
      ),
    );
  }

  /// Show Dialog to Enable GPS
  void _showEnableGPSDialog() {
    Get.defaultDialog(
      title: "Enable GPS",
      middleText:
          "GPS is required for this app. Please enable location services.",
      barrierDismissible: true,
      confirm: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedButtonFill(
            onPress: () async {
              Get.back(); // Close dialog
              await Geolocator.openLocationSettings();
              Future.delayed(Duration(seconds: 3), () {
                requestPermission(); // Recheck when returning from settings
              });
            },
            title: 'Enable GPS',
            width: 32,
            height: 5,
            color: AppThemeData.red02,
          ),
          SizedBox(
            width: 10,
          ),
          RoundedButtonFill(
            onPress: () async {
              Get.to(PinCodeScreen());
            },
            title: 'Enter Pin-code',
            width: 32,
            height: 5,
            color: AppThemeData.teal02,
          )
        ],
      ),
    );
  }
}
