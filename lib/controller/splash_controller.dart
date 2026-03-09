import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:allubmarket/app/auth_screen/welcome_screen.dart';
import 'package:allubmarket/app/dashboard_screen/dashboard_screen.dart';
import 'package:allubmarket/app/location_permission_screen/location_permission_screen.dart';
import 'package:allubmarket/app/maintenance_mode_screen/maintenance_mode_screen.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Timer(const Duration(seconds: 1), () => redirectScreen());
    super.onInit();
  }

  Future<void> redirectScreen() async {
    if (await FireStoreUtils.isMaintenanceMode() == true) {
      Get.offAll(() => MaintenanceModeScreen());
      return;
    } else {
      bool isLocationPermission = await _checkLocationPermission();

      if (isLocationPermission) {
        bool isLogin = await FireStoreUtils.isLogin();
        if (isLogin) {
          Get.offAll(const DashBoardScreen());
        } else {
          await FirebaseAuth.instance.signOut();
          Get.offAll(const WelcomeScreen());
        }
      } else {
        Get.offAll(const LocationPermissionScreen());
      }
    }
  }

  Future<bool> _checkLocationPermission() async {
    bool isLocationEnable;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (isLocationServiceEnabled == false) {
      isLocationEnable = false;
    } else {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        isLocationEnable = true;
      } else {
        isLocationEnable = false;
      }
    }
    return isLocationEnable;
  }
}
