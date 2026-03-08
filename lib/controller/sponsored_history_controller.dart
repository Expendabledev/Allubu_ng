import 'package:get/get.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/sponsored_request_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class SponsoredHistoryController extends GetxController {
  RxBool isLoading = true.obs;

  RxList<BusinessModel> businessList = <BusinessModel>[].obs;
  Rx<BusinessModel> selectedBusiness = BusinessModel().obs;
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    super.onInit();
  }

  RxList<SponsoredRequestModel> sponsoredHistoryList = <SponsoredRequestModel>[].obs;
  RxList<SponsoredRequestModel> runningHistoryList = <SponsoredRequestModel>[].obs;
  RxList<SponsoredRequestModel> acceptedHistoryList = <SponsoredRequestModel>[].obs;
  RxList<SponsoredRequestModel> pendingHistoryList = <SponsoredRequestModel>[].obs;
  RxList<SponsoredRequestModel> canceledHistoryList = <SponsoredRequestModel>[].obs;
  RxList<SponsoredRequestModel> expiredHistoryList = <SponsoredRequestModel>[].obs;

  Future<void> getData() async {
    await FireStoreUtils.getCurrentUserModel().then(
      (value) {
        if (value != null) {
          userModel.value = value;
        }
      },
    );

    await FireStoreUtils.getOwnerBusinessListById(userModel.value.id.toString()).then(
      (value) async {
        businessList.value = value;
        if (businessList.isNotEmpty) {
          selectedBusiness.value = businessList.first;
          await getSponsoredHistory();
        }
      },
    );
    isLoading.value = false;
  }

  Future<void> getSponsoredHistory() async {
    await FireStoreUtils.getSponsoredRequest(selectedBusiness.value.id.toString()).then(
      (value) {
        sponsoredHistoryList.value = value;

        runningHistoryList.value = sponsoredHistoryList.where((item) => item.status == 'Running').toList();
        acceptedHistoryList.value = sponsoredHistoryList.where((item) => item.status == 'Accepted').toList();
        pendingHistoryList.value = sponsoredHistoryList.where((item) => item.status == 'Pending').toList();
        canceledHistoryList.value = sponsoredHistoryList.where((item) => item.status == 'Canceled').toList();
        expiredHistoryList.value = sponsoredHistoryList.where((item) => item.status == 'Expired').toList();
      },
    );
  }
}
