import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class CategorySelectionController extends GetxController {
  final Rx<TextEditingController> searchController = TextEditingController().obs;

  RxBool isSearchShow = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  RxList<CategoryModel> categories = <CategoryModel>[].obs; // Observable category list
  RxList<CategoryModel> selectedCategories = <CategoryModel>[].obs; // Observable category list

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      selectedCategories.value = argumentData['selectedCategories'];
      if (selectedCategories.isNotEmpty) {
        isSearchShow.value = false;
      }
    }
    update();
  }

  var isLoading = false.obs; // Loading state

  // Fetch categories based on search query
  Future<void> searchCategories(String query) async {
    if (query.isEmpty) {
      categories.clear();
    } else {
      isLoading.value = true;
      await FireStoreUtils.getCategory(query.trim().replaceAll("  ", " ").toLowerCase()).then(
        (value) async {
          categories.value = value;
        },
      );

      isLoading.value = false;
    }
  }
}
