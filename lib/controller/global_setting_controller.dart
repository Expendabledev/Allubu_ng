import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/models/country_model.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/notification_service.dart';

class GlobalSettingController extends GetxController {
  @override
  void onInit() {
    notificationInit();
    getSettings();
    super.onInit();
  }

  Future<void> getSettings() async {
    await FireStoreUtils.getSettings();
    await loadCountries();
  }

  Future<void> loadCountries() async {
    // Load the JSON string from assets
    final String response =
        await rootBundle.loadString('assets/currency-codes.json');

    // Decode the JSON string
    final Map<String, dynamic> data = json.decode(response);

    // Parse the data into the model
    Constant.countryModel = CountryModel.fromJson(data);
  }

  NotificationService notificationService = NotificationService();

  void notificationInit() {
    notificationService.initInfo().then((value) async {
      bool isLogin = await FireStoreUtils.isLogin();
      if (isLogin == true) {
        String token = await NotificationService.getToken();
        UserModel? userModel =
            await FireStoreUtils.getUserProfile(FireStoreUtils.getCurrentUid());
        userModel!.fcmToken = token;
        await FireStoreUtils.updateUser(userModel);
        log(":::::::TOKEN:::::: $token");
      }
    });
  }
}
