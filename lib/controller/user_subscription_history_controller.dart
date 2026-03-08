import 'package:get/get.dart';
import 'package:yelpify/models/subscription_ads_history.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class UserSubscriptionHistoryController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getHistory();
    super.onInit();
  }

  RxList<SubscriptionAdsHistory> historyList = <SubscriptionAdsHistory>[].obs;

  Future<void> getHistory() async {
    await FireStoreUtils.getSubscriptionAdsHistory().then(
      (value) {
        historyList.value = value;
      },
    );
    isLoading.value = false;
  }
}
