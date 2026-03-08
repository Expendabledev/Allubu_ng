import 'package:get/get.dart';
import 'package:yelpify/utils/preferences.dart';

class SettingsController extends GetxController{

  RxBool isDarkModeSwitch = false.obs;
  RxString isDarkMode = "Light".obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getThem();
    super.onInit();
  }


  void getThem() {
    isDarkMode.value = Preferences.getString(Preferences.themKey);
    if (isDarkMode.value == "Dark") {
      isDarkModeSwitch.value = true;
    } else if (isDarkMode.value == "Light") {
      isDarkModeSwitch.value = false;
    } else {
      isDarkModeSwitch.value = false;
    }
    isLoading.value = false;
  }

}