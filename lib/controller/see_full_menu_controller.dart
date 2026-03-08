import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/country_model.dart';
import 'package:yelpify/models/item_model.dart';
import 'package:yelpify/models/photo_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class SeeFullMenuController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  Rx<BusinessModel> businessModel = BusinessModel().obs;
  RxList<ItemModel> itemList = <ItemModel>[].obs;
  RxList<PhotoModel> menuPhotosList = <PhotoModel>[].obs;

  Rx<Currency> currency = Currency().obs;

  Rx<WebViewController> controller = WebViewController().obs;

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      businessModel.value = argumentData['businessModel'];
      currency.value = Constant.countryModel!.countries!.firstWhere((element) => element.dialCode == businessModel.value.countryCode);
      await getMenu();
      await getMenuImage();
    }

    if(businessModel.value.website!.isNotEmpty){
      controller.value = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            // onNavigationRequest: (NavigationRequest request) {
            //   if (request.url.startsWith('https://www.youtube.com/')) {
            //     return NavigationDecision.prevent;
            //   }
            //   return NavigationDecision.navigate;
            // },
          ),
        )
        ..loadRequest(Uri.parse(businessModel.value.website.toString()));
    }

    isLoading.value = false;
    update();
  }

  Future<void> getMenu() async {
    await FireStoreUtils.getItemList(businessModel.value.id.toString()).then(
      (value) {
        itemList.value = value;
      },
    );
  }

  Future<void> getMenuImage() async {
    await FireStoreUtils.getAllPhotosByType(businessModel.value.id.toString(), "menuPhoto").then(
      (value) {
        menuPhotosList.value = value;
      },
    );
  }

  void updateMenuPhoto(int index, PhotoModel reviewModel) {
    menuPhotosList.removeAt(index);
    menuPhotosList.insert(index, reviewModel);
  }

  bool hasMenuItem() {
    if (businessModel.value.category == null || businessModel.value.category!.isEmpty) {
      return false;
    }

    return businessModel.value.category!.any((category) => category.uploadItems == true);
  }
}
