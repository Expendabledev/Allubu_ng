import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:allubmarket/widgets/place_picker/selected_location_model.dart';

class LocationController extends GetxController {
  GoogleMapController? mapController;
  var selectedLocation = Rxn<LatLng>();
  var selectedPlaceAddress = Rxn<Placemark>();
  var address = "Move the map to select a location".obs;
  TextEditingController searchController = TextEditingController();

  RxString zipCode = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getArgument();
    getCurrentLocation();
  }

  void getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      zipCode.value = argumentData['zipCode'] ?? '';
      if (zipCode.value.isNotEmpty) {
        getCoordinatesFromZipCode(zipCode.value);
      }
    }
    update();
  }

  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    selectedLocation.value = LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: selectedLocation.value!, zoom: 15),
      ),
    );

    getAddressFromLatLng(selectedLocation.value!);
  }

  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        selectedPlaceAddress.value = place;
        address.value =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
    } catch (e) {
      print(e);
    }
  }

  void onMapMoved(CameraPosition position) {
    selectedLocation.value = position.target;
  }

  Future<void> getCoordinatesFromZipCode(String zipCode) async {
    try {
      List<Location> locations = await locationFromAddress(zipCode);
      if (locations.isNotEmpty) {
        selectedLocation.value =
            LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print("Error getting coordinates for ZIP code: $e");
    }
  }

  void confirmLocation() {
    if (selectedLocation.value != null) {
      SelectedLocationModel selectedLocationModel = SelectedLocationModel(
          address: selectedPlaceAddress.value, latLng: selectedLocation.value);
      Get.back(result: selectedLocationModel);
    }
  }
}
