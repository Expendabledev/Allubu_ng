import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:allubmarket/app/business_details_screen/business_details_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/category_model.dart';
import 'package:allubmarket/models/service_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/utils.dart';

class BusinessListController extends GetxController {
  late GoogleMapController mapController;

  RxBool isLoading = true.obs;
  RxBool isZipCode = true.obs;
  RxString address = "".obs;
  RxSet<Marker> markers = <Marker>{}.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Rx<CategoryModel> categoryModel = CategoryModel().obs;
  Rx<CategoryModel> selectedCategory = CategoryModel().obs;
  RxList<CategoryModel> subCategoryList = <CategoryModel>[].obs;

  Rx<LatLng> currentPosition = LatLng(37.7749, -122.4194).obs;

  RxList<ServiceModel> categoryService = <ServiceModel>[].obs;

  RxList<BusinessModel> allBusinessList = <BusinessModel>[].obs;
  RxList<BusinessModel> sponsoredBusinessList = <BusinessModel>[].obs;
  RxList<BusinessModel> filteredBusinessList = <BusinessModel>[].obs;

  RxString selectedSortOption = ''.obs; // Default selected

  Future<void> getArgument() async {
    categoryService.clear();
    subCategoryList.clear();
    final argumentData = Get.arguments;

    if (argumentData != null) {
      categoryModel.value = argumentData['categoryModel'];
      selectedCategory.value = argumentData['categoryModel'];
      isZipCode.value = argumentData['isZipCode'];

      await FireStoreUtils.getCategoryById(categoryModel.value.slug.toString())
          .then(
        (value) {
          if (value != null) {
            categoryModel.value = value;
          }
        },
      );
      if (argumentData['latLng'] != null) {
        currentPosition.value = argumentData['latLng'];
      } else {
        if (Constant.currentLocation == null) {
          currentPosition.value = Constant.currentLocationLatLng!;
        } else {
          currentPosition.value = LatLng(Constant.currentLocation!.latitude,
              Constant.currentLocation!.longitude);
        }
      }

      await getBusiness();

      final resolvedAddress = await getAddressFromLatLng(
        currentPosition.value.latitude,
        currentPosition.value.longitude,
      );

      if (resolvedAddress != null) {
        address.value = resolvedAddress;
      }
    }

    isLoading.value = false;
    update();

    // Load subcategories
    if (selectedCategory.value.children != null &&
        selectedCategory.value.children!.isNotEmpty) {
      for (final id in selectedCategory.value.children!) {
        final subCategory = await FireStoreUtils.getCategoryById(id);
        if (subCategory != null) {
          subCategoryList.add(subCategory);
        }
      }
    }

    // Load services
    if (selectedCategory.value.services != null) {
      for (final serviceId in selectedCategory.value.services!) {
        final service = await FireStoreUtils.getServiceById(serviceId);
        if (service != null) {
          categoryService.add(service);
        }
      }
    }

    // Filter services with 'filter == true'
    categoryService.value =
        categoryService.where((s) => s.filter == true).toList();
    update();
  }

  Future getBusiness() async {
    FireStoreUtils.getAllNearestRestaurantByCategoryId(
            currentPosition.value, selectedCategory.value)
        .listen((event) async {
      allBusinessList.clear();
      filteredBusinessList.clear();
      sponsoredBusinessList.clear();
      allBusinessList.addAll(event);
      getAllFilteredLists();
      setMarkers();
    });

    update();
  }

  Future<void> setMarkers() async {
    final Set<Marker> newMarkers = {};
    Set<String> sponsoredIds =
        sponsoredBusinessList.map((b) => b.id.toString()).toSet();

    int index = 1;

    for (var business in [...filteredBusinessList, ...sponsoredBusinessList]) {
      final isSponsored = sponsoredIds.contains(business.id.toString());
      BitmapDescriptor icon;

      if (isSponsored) {
        final imageBytes = await Utils.getBytesFromUrl(
            Constant.sponsoredMarker); // Replace with actual image URL
        icon = BitmapDescriptor.fromBytes(imageBytes);
      } else {
        Uint8List markerBytes = await createMarkerWithTextOnImage(
          assetPath: 'assets/images/map_marker_1.png',
          text: index.toString(),
        );
        icon = BitmapDescriptor.fromBytes(markerBytes);
        index++;
      }

      newMarkers.add(
        Marker(
          markerId: MarkerId(business.id.toString()),
          position: LatLng(
            double.parse(business.location?.latitude ?? "0.0"),
            double.parse(business.location?.longitude ?? "0.0"),
          ),
          icon: icon,
          infoWindow: InfoWindow(
              title: business.businessName,
              onTap: () async {
                final value =
                    await FireStoreUtils.getBusinessById(business.id ?? '');
                if (value != null) {
                  Get.to(BusinessDetailsScreen(),
                      arguments: {"businessModel": value});
                }
              }),
        ),
      );
    }

    // ignore: invalid_use_of_protected_member
    markers.value = newMarkers;
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  RxBool isOpenBusiness = false.obs;
  RxMap<String, List<OptionModel>> selectedOptionsByServiceId =
      <String, List<OptionModel>>{}.obs;

  List<BusinessModel> filterAndSort(List<BusinessModel> inputList) {
    List<BusinessModel> filtered = List.from(inputList);

    if (selectedOptionsByServiceId.isNotEmpty) {
      filtered = filtered.where((business) {
        if (business.services == null) return false;

        for (String serviceId in selectedOptionsByServiceId.keys) {
          List<OptionModel> selectedOptions =
              selectedOptionsByServiceId[serviceId] ?? [];
          Map<String, dynamic>? matchedService;

          for (var item in business.services!) {
            if (item.containsKey(serviceId)) {
              matchedService = item;
              break;
            }
          }

          if (matchedService == null) return false;

          List<dynamic> businessOptionsRaw = matchedService[serviceId];
          List<OptionModel> businessOptions = businessOptionsRaw
              .map((e) => e is OptionModel ? e : OptionModel.fromJson(e))
              .toList();

          bool hasAnyMatch = selectedOptions.any((selected) =>
              businessOptions.any((bOpt) => bOpt.name == selected.name));

          if (!hasAnyMatch) return false;
        }

        return true;
      }).toList();
    }

    // Apply "Open Now" filter
    if (isOpenBusiness.value) {
      filtered =
          filtered.where((b) => isBusinessOpenNow(b.businessHours)).toList();
    }

    // Apply sorting
    switch (selectedSortOption.value) {
      case 'recommended':
        filtered.sort((a, b) => (double.parse(b.recommendYesCount.toString()))
            .compareTo(double.parse(a.recommendYesCount.toString())));
        break;

      case 'distance':
        filtered.sort((a, b) {
          final aDist = getDistance(currentPosition.value, a.location);
          final bDist = getDistance(currentPosition.value, b.location);
          return aDist.compareTo(bDist);
        });
        break;

      case 'rating':
        double getAverageRating(BusinessModel b) {
          final sum = double.tryParse(b.reviewSum ?? "0") ?? 0.0;
          final count = double.tryParse(b.reviewCount ?? "0") ?? 0.0;
          if (count == 0) return 0;
          return sum / count;
        }

        filtered
            .sort((a, b) => getAverageRating(b).compareTo(getAverageRating(a)));
        break;

      case 'reviewed':
        filtered.sort((a, b) => (double.tryParse(b.reviewCount ?? "0") ?? 0)
            .compareTo(double.tryParse(a.reviewCount ?? "0") ?? 0));
        break;
    }

    return filtered;
  }

  void getAllFilteredLists() {
    sponsoredBusinessList.value = allBusinessList
        .where(
            (p0) => p0.sponsored != null && p0.sponsored!.status == "Running")
        .toList();

    // Get all filtered businesses
    List<BusinessModel> allFiltered = filterAndSort(allBusinessList);
    List<BusinessModel> sponsoredFiltered =
        filterAndSort(sponsoredBusinessList);

    // Remove sponsored businesses from the filtered list
    Set<String> sponsoredIds =
        sponsoredFiltered.map((b) => b.id.toString()).toSet();
    filteredBusinessList.value =
        allFiltered.where((b) => !sponsoredIds.contains(b.id)).toList();

    // Assign sponsored businesses separately
    sponsoredBusinessList.value = sponsoredFiltered;

    setMarkers();
    update();
  }

  Future<String?> getAddressFromLatLng(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        if (isZipCode.value) {
          return "${place.postalCode}";
        } else {
          return "${place.locality}, ${place.administrativeArea}, ${place.country}";
        }
      }
    } catch (e) {
      print("Error getting address: $e");
    }
    return null;
  }

  bool isBusinessOpenNow(BusinessHours? hours) {
    if (hours == null) return false;

    final now = DateTime.now();
    final today = DateFormat('EEEE').format(now).toLowerCase();
    final currentTime = DateFormat('HH:mm').format(now);

    List<dynamic>? todayHours;
    switch (today) {
      case 'monday':
        todayHours = hours.monday;
        break;
      case 'tuesday':
        todayHours = hours.tuesday;
        break;
      case 'wednesday':
        todayHours = hours.wednesday;
        break;
      case 'thursday':
        todayHours = hours.thursday;
        break;
      case 'friday':
        todayHours = hours.friday;
        break;
      case 'saturday':
        todayHours = hours.saturday;
        break;
      case 'sunday':
        todayHours = hours.sunday;
        break;
    }

    if (todayHours == null || todayHours.isEmpty) return false;

    for (var range in todayHours) {
      final times = range.split('-');
      if (times.length != 2) continue;
      final start = times[0];
      final end = times[1];

      // Normal time range
      if (currentTime.compareTo(start) >= 0 &&
          currentTime.compareTo(end) <= 0) {
        return true;
      }

      // Overnight shift
      if (end.compareTo(start) < 0 && currentTime.compareTo(start) >= 0) {
        return true;
      }
    }

    return false;
  }

  double getDistance(LatLng user, LatLngModel? business) {
    if (business == null) return double.infinity;

    final lat1 = double.tryParse(user.latitude.toString()) ?? 0.0;
    final lon1 = double.tryParse(user.longitude.toString()) ?? 0.0;
    final lat2 = double.tryParse(business.latitude ?? '') ?? 0.0;
    final lon2 = double.tryParse(business.longitude ?? '') ?? 0.0;

    const earthRadius = 6371; // km
    final dLat = _degToRad(lat2 - lat1);
    final dLon = _degToRad(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) *
            cos(_degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  Future<Uint8List> createMarkerWithTextOnImage({
    required String assetPath,
    required String text,
    double fontSize = 45,
  }) async {
    // Load the base image
    final ByteData data = await rootBundle.load(assetPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(bytes);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image baseImage = frame.image;

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    final Paint paint = Paint();
    final double width = baseImage.width.toDouble();
    final double height = baseImage.height.toDouble();

    // Draw the base image
    canvas.drawImage(baseImage, Offset.zero, paint);

    // Prepare text painter
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(blurRadius: 4, color: Colors.black)],
        ),
      ),
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    textPainter.layout();

    // Center the text on the image
    final Offset offset = Offset(
      (width - textPainter.width) / 2,
      (height - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);

    // Convert canvas to image
    final ui.Image markerImage = await recorder.endRecording().toImage(
          baseImage.width,
          baseImage.height,
        );
    final ByteData? markerData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);

    return markerData!.buffer.asUint8List();
  }
}
