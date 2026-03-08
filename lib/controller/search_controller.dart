import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yelpify/app/home_screen/business_list_screen.dart';
import 'package:yelpify/app/search_screen/voice_search_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/voice_search_controller.dart';
import 'package:yelpify/models/business_history_model.dart';
import 'package:yelpify/models/category_history_model.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/utils/business_history_storage.dart';
import 'package:yelpify/utils/category_history_storage.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:http/http.dart' as http;

class SearchControllers extends GetxController {
  Rx<TextEditingController> categoryTextFieldController = TextEditingController().obs;
  Rx<TextEditingController> locationTextFieldController = TextEditingController().obs;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();

  RxBool isLocationSearch = false.obs;
  RxBool isSearchClose = true.obs;

  RxList<CategoryModel> categories = <CategoryModel>[].obs; // Observable category list
  LatLng? latLng; // Observable category list
  Rx<CategoryModel> selectedCategory = CategoryModel().obs;
  RxBool isLoading = true.obs;
  RxBool isCategoryLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    focusNode1.addListener(
      () {
        if (focusNode1.hasFocus) {
          isLocationSearch.value = false;
          isSearchClose.value = false;
        }
        if (!focusNode1.hasFocus && !focusNode2.hasFocus) {
          isSearchClose.value = true;
        }
      },
    );
    focusNode2.addListener(
      () {
        if (focusNode2.hasFocus) {
          isLocationSearch.value = true;
          isSearchClose.value = false;
        }
        if (!focusNode1.hasFocus && !focusNode2.hasFocus) {
          isSearchClose.value = true;
        }
      },
    );
    getArgument();
    getSearchHistory();
    searchLocation();
    isLoading.value = false;
  }

  void searchLocation() {
    locationTextFieldController.value.addListener(() {
      searchPlaces(locationTextFieldController.value.text);
    });
  }

  RxBool isZipCode = true.obs;

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      if (argumentData['categoryModel'] != null) {
        selectedCategory.value = argumentData['categoryModel'];
      }
      isZipCode.value = argumentData['isZipCode'];
      if (argumentData['latLng'] != null) {
        latLng = argumentData['latLng'];
      } else {
        if (Constant.currentLocation == null) {
          latLng = LatLng(Constant.currentLocationLatLng!.latitude, Constant.currentLocationLatLng!.longitude);
        } else {
          latLng = LatLng(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude);
        }
      }
      categoryTextFieldController.value.text = selectedCategory.value.name.toString();
    }
    isLoading.value = false;
    update();
  }

  // Fetch categories based on search query
  Future<void> searchCategories(String query) async {
    if (query.isEmpty) {
      categories.clear();
      categories.assignAll([]); // Clear the list and update UI
    } else {
      isCategoryLoading.value = true;
      await FireStoreUtils.getCategory(query.trim().replaceAll("  ", " ").toLowerCase()).then(
        (value) async {
          categories.value = value;
        },
      );
      isCategoryLoading.value = false;
    }
    update();
  }

  RxList<dynamic> predictions = <dynamic>[].obs;

  Future<void> searchPlaces(String query) async {
    if (query.isEmpty) {
      predictions.clear();
      return;
    }

    if (Constant.isNumeric(query.trim())) {
      predictions.clear();
      await getCoordinatesFromZip(query.trim());
    } else {
      final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${Constant.mapAPIKey}",
      );

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        predictions.value = data['predictions'];
      }
    }
  }

  Future<void> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${Constant.mapAPIKey}",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']['geometry']['location'];
      locationTextFieldController.value.text = data['result']['formatted_address'];
      latLng = LatLng(location['lat'], location['lng']);
      navigateBusinessScree();
    }
  }

  void navigateBusinessScree() {
    if (selectedCategory.value.slug != null && latLng != null) {
      setSearchHistory();
      Get.off(BusinessListScreen(), arguments: {
        "categoryModel": selectedCategory.value,
        "latLng": latLng,
        "isZipCode": Constant.isNumeric(locationTextFieldController.value.text.trim()),
      });
    }
  }

  /// **📍 Get Latitude & Longitude from ZIP Code**
  Future<void> getCoordinatesFromZip(String zipCode) async {
    try {
      List<Location> locations = await locationFromAddress(zipCode);
      if (locations.isNotEmpty) {
        latLng = LatLng(locations.first.latitude, locations.first.longitude);
        navigateBusinessScree();
      } else {
        ShowToastDialog.showToast("Zip code is Invalid");
      }
    } catch (e) {
      ShowToastDialog.showToast("Zip code is Invalid");
      print("Error getting coordinates: $e");
    }
  }

  RxList<CategoryHistoryModel> categoryHistory = <CategoryHistoryModel>[].obs;
  RxList<BusinessHistoryModel> recentSearchHistory = <BusinessHistoryModel>[].obs;

  Future<void> getSearchHistory() async {
    await CategoryHistoryStorage.getCategoryHistoryList().then(
      (value) {
        if (value.isNotEmpty) {
          categoryHistory.value = value;
        }
      },
    );

    await BusinessHistoryStorage.getCategoryHistoryList().then(
      (value) {
        if (value.isNotEmpty) {
          recentSearchHistory.value = value;
        }
      },
    );
  }

  void setSearchHistory() {
    CategoryHistoryModel model = CategoryHistoryModel();
    model.id = Constant.getUuid();
    model.category = selectedCategory.value;
    model.createdAt = Timestamp.now();

    CategoryHistoryStorage.addCategoryHistoryItem(model);
  }

  Future<void> voiceSearch() async {
    final result = await Get.to(() => const VoiceSearchScreen());
    Get.delete<VoiceSearchController>();
    if (result != null) {
      log("voiceSearch :::: $result");
      categoryTextFieldController.value.text = result ?? '';
      searchCategories(result);
    }
  }
}
