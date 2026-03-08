import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yelpify/app/auth_screen/welcome_screen.dart';
import 'package:yelpify/app/dashboard_screen/dashboard_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class PinCodeController extends GetxController {
  Rx<TextEditingController> pinCodeTextFieldController = TextEditingController().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  LatLng? latLng; // Observable category list

  /// **📍 Get Latitude & Longitude from ZIP Code**
  Future<void> getCoordinatesFromZip(String zipCode) async {
    try {
      List<Location> locations = await locationFromAddress(zipCode);
      if (locations.isNotEmpty) {
        latLng = LatLng(locations.first.latitude, locations.first.longitude);
        Constant.currentLocationLatLng = latLng;

        bool isLogin = await FireStoreUtils.isLogin();
        ShowToastDialog.closeLoader();
        if (isLogin) {
          Get.offAll(const DashBoardScreen());
        } else {
          await FirebaseAuth.instance.signOut();
          Get.offAll(const WelcomeScreen());
        }
      } else {
        ShowToastDialog.showToast("Zip code is Invalid");
      }
    } catch (e) {
      ShowToastDialog.showToast("Zip code is Invalid");
      print("Error getting coordinates: $e");
    }
  }
}
