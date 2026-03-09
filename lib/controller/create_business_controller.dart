import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/models/ai_genrated_content_model.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/category_model.dart';
import 'package:allubmarket/service/api.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/widgets/geoflutterfire/src/geoflutterfire.dart';
import 'package:allubmarket/widgets/geoflutterfire/src/models/point.dart';

import '../constant/show_toast_dialog.dart';

class CreateBusinessController extends GetxController {
  Rx<TextEditingController> countryNameTextFieldController =
      TextEditingController(text: "United state of America").obs;
  Rx<TextEditingController> countryCodeController =
      TextEditingController(text: Constant.defaultCountryCode).obs;
  Rx<TextEditingController> countryISOCodeController =
      TextEditingController(text: Constant.defaultCountryCode).obs;
  Rx<TextEditingController> nameTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> businessUrlTextFieldController =
      TextEditingController().obs;
  RxString businessSlug = ''.obs;
  Rx<TextEditingController> descriptionTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> metaKeywordsController =
      TextEditingController().obs;
  RxList<dynamic> metaKeywordsList = <dynamic>[].obs;
  Rx<TextEditingController> addressTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> categoryTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> phoneNumberTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> websiteTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> notesOfTheYelpTeamTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> fbLinkTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> instaLinkTextFieldController =
      TextEditingController().obs;

  Rx<AddressModel> address = AddressModel().obs;
  Rx<LatLngModel> location = LatLngModel().obs;

  RxList<CategoryModel> selectedCategory = <CategoryModel>[].obs;

  RxBool asCustomerOrWorkAtBusiness = true.obs;
  RxBool isPermanentClosed = false.obs;

  RxString profileImage = "".obs;

  BusinessHours generateBusinessHours() {
    final fullDay = [
      TimeRange(
          open: TimeOfDay(hour: 0, minute: 0),
          close: TimeOfDay(hour: 23, minute: 59))
    ];
    return BusinessHours(
      monday: fullDay.map((e) => e.toRangeString()).toList(),
      tuesday: fullDay.map((e) => e.toRangeString()).toList(),
      wednesday: fullDay.map((e) => e.toRangeString()).toList(),
      thursday: fullDay.map((e) => e.toRangeString()).toList(),
      friday: fullDay.map((e) => e.toRangeString()).toList(),
      saturday: fullDay.map((e) => e.toRangeString()).toList(),
      sunday: fullDay.map((e) => e.toRangeString()).toList(),
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();

    super.onInit();
  }

  String generateSlugAndUrl({required String input}) {
    if (input.trim().isEmpty) {
      businessSlug.value = '';
      return '';
    }

    final invalidChars = RegExp(r'[^a-zA-Z0-9\- ]');
    if (invalidChars.hasMatch(input)) {
      final cleaned = input.replaceAll(invalidChars, '');
      businessSlug.value = '';
      ShowToastDialog.showToast("Invalid characters in slug.");
      return cleaned;
    }
    String slug = input.toLowerCase().replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '-');

    businessSlug.value = slug;
    businessUrlTextFieldController.value.text = businessSlug.value;
    return businessSlug.value;
  }

  Rx<BusinessModel> businessModel = BusinessModel().obs;

  void getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      if (argumentData['businessModel'] != null) {
        businessModel.value = argumentData['businessModel'];

        isPermanentClosed.value =
            businessModel.value.isPermanentClosed ?? false;
        countryNameTextFieldController.value.text =
            businessModel.value.countryName ?? '';
        countryCodeController.value.text =
            businessModel.value.countryCode ?? '';
        countryISOCodeController.value.text =
            businessModel.value.countryISOCode ?? '';
        nameTextFieldController.value.text =
            businessModel.value.businessName ?? '';
        descriptionTextFieldController.value.text =
            businessModel.value.description ?? '';
        address.value = businessModel.value.address!;
        address.value.postalCode = businessModel.value.zipCode;
        location.value = businessModel.value.location!;
        selectedCategory.value = businessModel.value.category ?? [];
        phoneNumberTextFieldController.value.text =
            businessModel.value.phoneNumber ?? '';
        websiteTextFieldController.value.text =
            businessModel.value.website ?? '';
        notesOfTheYelpTeamTextFieldController.value.text =
            businessModel.value.noteForYelpTeam ?? '';
        addressTextFieldController.value.text =
            Constant.getFullAddressModel(address.value);
        categoryTextFieldController.value.text =
            selectedCategory.map((e) => e.name).join(", ");
        profileImage.value = businessModel.value.coverPhoto ?? '';
        fbLinkTextFieldController.value.text = businessModel.value.fbLink ?? '';
        instaLinkTextFieldController.value.text =
            businessModel.value.instaLink ?? '';
        if (businessModel.value.slug != null) {
          businessUrlTextFieldController.value.text =
              businessModel.value.slug!.substring(4);
          String slug = businessModel.value.slug!.substring(4);
          businessSlug.value = generateSlugAndUrl(input: slug);
        }
        if (businessModel.value.metaKeywords != null) {
          metaKeywordsList.value = businessModel.value.metaKeywords!;
          metaKeywordsController.value.text = metaKeywordsList.join(', ');
        }
        update();
      } else {
        asCustomerOrWorkAtBusiness.value =
            argumentData['asCustomerOrWorkAtBusiness'];
      }
    }
    update();
  }

  Future<void> saveBusiness() async {
    ShowToastDialog.showLoader("Please wait");
    if (profileImage.value.isNotEmpty &&
        Constant().hasValidUrl(profileImage.value) == false) {
      profileImage.value = await Constant.uploadUserImageToFireStorage(
        File(profileImage.value),
        "${businessModel.value.id}",
        File(profileImage.value).path.split('/').last,
      );
    }

    if (businessModel.value.id == null || businessModel.value.id!.isEmpty) {
      businessModel.value.id = Constant.getUuid();
      businessModel.value.createdAt = Timestamp.now();
      businessModel.value.updatedAt = Timestamp.now();
      businessModel.value.publish = false;
      businessModel.value.isVerified = false;
      businessModel.value.businessHours = generateBusinessHours();
    }

    businessModel.value.createdBy = FireStoreUtils.getCurrentUid();
    businessModel.value.countryName = countryNameTextFieldController.value.text;
    businessModel.value.description = descriptionTextFieldController.value.text;
    businessModel.value.countryCode = countryCodeController.value.text;
    businessModel.value.countryISOCode = countryISOCodeController.value.text;
    businessModel.value.businessName = nameTextFieldController.value.text;
    businessModel.value.address = address.value;
    businessModel.value.zipCode = address.value.postalCode;
    businessModel.value.location = location.value;
    GeoFirePoint position = Geoflutterfire().point(
        latitude: double.parse(location.value.latitude.toString()),
        longitude: double.parse(location.value.longitude.toString()));
    businessModel.value.position =
        Positions(geoPoint: position.geoPoint, geoHash: position.hash);
    businessModel.value.category = selectedCategory;
    businessModel.value.phoneNumber = phoneNumberTextFieldController.value.text;
    businessModel.value.website = websiteTextFieldController.value.text;
    businessModel.value.noteForYelpTeam =
        notesOfTheYelpTeamTextFieldController.value.text;
    businessModel.value.searchKeyword =
        Constant.generateSearchKeywords(nameTextFieldController.value.text);
    businessModel.value.asCustomerOrWorkAtBusiness =
        asCustomerOrWorkAtBusiness.value;
    businessModel.value.coverPhoto = profileImage.value;
    businessModel.value.isPermanentClosed = false;
    String prefix = businessModel.value.id!.toLowerCase().substring(0, 3);
    businessModel.value.slug = "$prefix-${businessSlug.value}";
    businessModel.value.metaKeywords = metaKeywordsList;
    businessModel.value.fbLink = fbLinkTextFieldController.value.text;
    businessModel.value.instaLink = instaLinkTextFieldController.value.text;
    await FireStoreUtils.addBusiness(businessModel.value).then(
      (value) {
        ShowToastDialog.closeLoader();
        Get.back(result: true);
      },
    );
  }

  RxBool isTitleGenerated = false.obs;

  Future<void> generateTitleAndDescription() async {
    isTitleGenerated.value = true;
    Map<String, dynamic> bodyParams = {
      'name': nameTextFieldController.value.text,
    };
    await API
        .handleApiRequest(
            request: () => http.post(Uri.parse(API.generateTitleAndDescription),
                headers: API.headers, body: jsonEncode(bodyParams)),
            showLoader: false)
        .then(
      (value) {
        isTitleGenerated.value = false;

        if (value != null) {
          if (value['success'] == "Failed") {
            ShowToastDialog.showToast(value['error']);
          } else {
            AiGeneratedContentContentModel aiTitleDescriptionModel =
                AiGeneratedContentContentModel.fromJson(value);
            nameTextFieldController.value.text =
                aiTitleDescriptionModel.data!.title ?? "";
            descriptionTextFieldController.value.text =
                aiTitleDescriptionModel.data!.description ?? "";
            selectedCategory.value =
                aiTitleDescriptionModel.data!.category ?? [];
            categoryTextFieldController.value.text =
                selectedCategory.map((e) => e.name).join(", ");
            metaKeywordsList.value = aiTitleDescriptionModel.data!.keywords!
                .split(',')
                .map((e) => e.trim())
                .toList();
            metaKeywordsController.value.text = metaKeywordsList.join(', ');
            ShowToastDialog.showToast(
                "Title and Description generated successfully.");
          }
        }
      },
    );
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      profileImage.value = image.path;
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }
}
