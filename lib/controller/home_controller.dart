import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/models/bookmarks_model.dart';
import 'package:yelpify/models/category_history_model.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/utils/category_history_storage.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/utils.dart';

class HomeController extends GetxController {
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<BookmarksModel> bookMarkList = <BookmarksModel>[].obs;

  RxBool isLoading = true.obs;
  Rx<LatLng> latLng = LatLng(20.5937, 78.9629).obs; // Observable category list

  @override
  void onInit() {
    // TODO: implement onInit
    getParentCategory();
    super.onInit();
  }

  Future<void> getParentCategory() async {
    await FireStoreUtils.categoryParentListHome().then(
      (value) {
        categoryList.value = value;
      },
    );

    await getCurrentLocation();

    isLoading.value = false;
    FireStoreUtils.getAllNearestBookMark(latLng.value).listen(
      (value) {
        bookMarkList.clear();
        bookMarkList.value = value;
      },
    );
  }

  Future<void> getCurrentLocation() async {
    if (FireStoreUtils.getCurrentUid() != '') await FireStoreUtils.getCurrentUserModel();
    Constant.currentLocation = await Utils.getCurrentLocation();
    if (Constant.currentLocation == null) {
      latLng.value = Constant.currentLocationLatLng!;
    } else {
      latLng.value = LatLng(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude);
    }
  }

  void setSearchHistory(CategoryModel category) {
    CategoryHistoryModel model = CategoryHistoryModel();
    model.id = Constant.getUuid();
    model.category = category;
    model.createdAt = Timestamp.now();

    CategoryHistoryStorage.addCategoryHistoryItem(model);
  }
}
