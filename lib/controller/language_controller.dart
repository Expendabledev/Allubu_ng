import 'package:get/get.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/models/language_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/preferences.dart';

class LanguageController extends GetxController {
  RxList<LanguageModel> languageList = <LanguageModel>[].obs;
  Rx<LanguageModel> selectedLanguage = LanguageModel().obs;

  RxBool isLoading = true.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    selectedLanguage.value = Constant.getLanguage();
    getLanguage();
    super.onInit();
  }

  Future<void> getLanguage() async {
    await FireStoreUtils.getLanguage().then((value) {
      if (value != null) {
        languageList.value = value;
        if (Preferences.getString(Preferences.languageCodeKey)
            .toString()
            .isNotEmpty) {
          LanguageModel pref = Constant.getLanguage();

          for (var element in languageList) {
            if (element.id == pref.id) {
              selectedLanguage.value = element;
            }
          }
        }
      }
    });
    isLoading.value = false;
  }
}
