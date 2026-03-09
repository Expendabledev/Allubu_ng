// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:allubmarket/constant/constant.dart';
// import 'package:allubmarket/constant/show_toast_dialog.dart';
// import 'package:allubmarket/models/business_model.dart';
// import 'package:allubmarket/models/country_model.dart';
// import 'package:allubmarket/models/highlight_model.dart';
// import 'package:allubmarket/models/item_model.dart';
// import 'package:allubmarket/models/photo_model.dart';
// import 'package:allubmarket/models/recommend_model.dart';
// import 'package:allubmarket/models/review_model.dart';
// import 'package:allubmarket/models/service_model.dart';
// import 'package:allubmarket/utils/fire_store_utils.dart';

// class MyBusinessProfileController extends GetxController with GetSingleTickerProviderStateMixin {
//   RxBool isLoading = true.obs;
//   RxInt currentIndex = 0.obs;
//   late TabController tabController;
//   final ScrollController scrollController = ScrollController();

//   final getTouch = GlobalKey();
//   final menuKey = GlobalKey();
//   final infoKey = GlobalKey();
//   final reviewKey = GlobalKey();

//   final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
//   RxList<PhotoModel> allPhotos = <PhotoModel>[].obs;
//   RxList<HighlightModel> highLightList = <HighlightModel>[].obs;

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     getArgument();
//     super.onInit();
//   }

//   void scrollToSection(GlobalKey key) {
//     final ctx = key.currentContext;
//     if (ctx != null) {
//       Scrollable.ensureVisible(
//         ctx,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   Rx<BusinessModel> businessModel = BusinessModel().obs;
//   RxList<ReviewModel> reviewList = <ReviewModel>[].obs;
//   Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
//   RxSet<Marker> markers = <Marker>{}.obs;
//   var serviceList = <Map<String, dynamic>>[].obs;

//   Rx<Currency> currency = Currency().obs;

//   Future<void> getArgument() async {
//     dynamic argumentData = Get.arguments;
//     if (argumentData != null) {
//       businessModel.value = argumentData['businessModel'];
//       await getBusiness();
//       loadCustomMarker();

//       tabController = TabController(
//           length: hasPricing() && hasMenuItem()
//               ? 4
//               : hasPricing() || hasMenuItem()
//                   ? 3
//                   : 2,
//           vsync: this);
//     }
//     isLoading.value = false;
//     update();
//   }

//   Future<void> getBusiness() async {
//     await FireStoreUtils.getBusinessById(businessModel.value.id.toString()).then(
//       (value) async {
//         if (value != null) {
//           businessModel.value = value;
//           currency.value = Constant.countryModel!.countries!.firstWhere((element) => element.dialCode == businessModel.value.countryCode);
//           await fetchBusinessServices();
//           await fetchBusinessHighLight();
//           await getReview();
//         }
//       },
//     );
//     FireStoreUtils.getAllPhotos(businessModel.value.id.toString(), "menuPhoto").then(
//       (value) {
//         allPhotos.value = value;
//         update();
//       },
//     );
//     getMenu();
//     update();
//   }

//   Future<void> fetchBusinessHighLight() async {
//     try {
//       await FireStoreUtils.getBusinessHighLightById(businessModel.value.highLights ?? []).then(
//         (value) {
//           highLightList.value = value;
//         },
//       );
//     } catch (e) {
//       print("Error fetching services: $e");
//     }
//   }

//   Future<void> fetchBusinessServices() async {
//     try {
//       List<dynamic> services = businessModel.value.services ?? [];

//       List<Map<String, dynamic>> result = [];

//       for (var service in services) {
//         final docId = service.keys.first;
//         final List<dynamic> rawOptions = service[docId];

//         final List<OptionModel> options = rawOptions.map((e) => OptionModel.fromJson(Map<String, dynamic>.from(e))).toList();

//         await FireStoreUtils.getServiceById(docId).then((value) {
//           if (value != null) {
//             final name = value.name;

//             result.add({
//               'name': name,
//               'options': options,
//             });
//           }
//         });
//       }

//       serviceList.assignAll(result);
//     } catch (e) {
//       print("Error fetching services: $e");
//     }
//   }

//   RxList<ItemModel> itemList = <ItemModel>[].obs;

//   Future<void> getMenu() async {
//     await FireStoreUtils.getItemList(businessModel.value.id.toString()).then(
//       (value) {
//         itemList.value = value;
//       },
//     );
//   }

//   Future<void> getReview() async {
//     await FireStoreUtils.getReviews(businessModel.value.id.toString()).then(
//       (value) {
//         reviewList.value = value;
//       },
//     );
//   }

//   Future<void> updateRecommended(String vote) async {
//     ShowToastDialog.showLoader("Please wait");
//     RecommendModel model = RecommendModel();
//     model.id = Constant.getUuid();
//     model.businessId = businessModel.value.id;
//     model.userId = FireStoreUtils.getCurrentUid();
//     model.vote = vote;

//     businessModel.value.recommendUserId!.add(FireStoreUtils.getCurrentUid());
//     await FireStoreUtils.addRecommended(model);
//     await FireStoreUtils.addBusiness(businessModel.value);
//     await getBusiness();
//     update();
//     ShowToastDialog.closeLoader();
//   }

//   void updateReviewList(int index, ReviewModel reviewModel) {
//     reviewList.removeAt(index);
//     reviewList.insert(index, reviewModel);
//   }

//   Future<void> loadCustomMarker() async {
//     final Uint8List departure = await Constant.getBytesFromAsset('assets/images/map_marker.png', 100);
//     BitmapDescriptor customIcon = BitmapDescriptor.fromBytes(departure);

//     markers.add(
//       Marker(
//         markerId: const MarkerId('customMarker'),
//         position: LatLng(double.parse(businessModel.value.location!.latitude ?? "0.0"), double.parse(businessModel.value.location!.longitude ?? "0.0")), // Example: San Francisco
//         icon: customIcon,
//         infoWindow: const InfoWindow(title: 'Custom Marker'),
//       ),
//     );
//     update();
//   }

//   void onMapCreated(GoogleMapController controller) {
//     mapController.value = controller;
//   }

//   bool hasMenuPhotos() {
//     if (businessModel.value.category == null || businessModel.value.category!.isEmpty) {
//       return false;
//     }
//     return businessModel.value.category!.any((category) => category.menuPhotos == true || category.uploadItems == true);
//   }

//   bool hasMenuItem() {
//     if (businessModel.value.category == null || businessModel.value.category!.isEmpty) {
//       return false;
//     }
//     return businessModel.value.category!.any((category) => category.uploadItems == true);
//   }

//   bool hasPricing() {
//     if (businessModel.value.category == null || businessModel.value.category!.isEmpty) {
//       return false;
//     }
//     return businessModel.value.category!.any((category) => category.getPricingForm == true);
//   }
// }
