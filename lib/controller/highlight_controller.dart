import 'package:get/get.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/highlight_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class HighLightController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    // TODO: implement onInit
    super.onInit();
  }

  Rx<BusinessModel> businessModel = BusinessModel().obs;

  RxList<HighlightModel> highLightList = <HighlightModel>[].obs;
  RxList<HighlightModel> selectedHighLightList = <HighlightModel>[].obs;

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      businessModel.value = argumentData['businessModel'];
      await getSpecification();
    }
    isLoading.value = false;
    update();
  }

  Future<void> getSpecification() async {
    await FireStoreUtils.getBusinessHighLight().then(
      (value) {
        highLightList.value = value;
        selectedHighLightList.value = highLightList.where((element) => businessModel.value.highLights!.contains(element.id)).toList();
      },
    );

    update();
  }

  Future<void> saveDetails() async {
    if (selectedHighLightList.isEmpty) {
      ShowToastDialog.showToast("Please select highlight");
    } else {
      ShowToastDialog.showLoader("Please wait");
      businessModel.value.highLights = selectedHighLightList.map((e) => e.id).toList();
      await FireStoreUtils.addBusiness(businessModel.value);
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("Business highlight save successfully ");
      Get.back(result: true);
    }
  }
}
