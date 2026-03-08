import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/create_bussiness_screen/category_selection_screen.dart';
import 'package:yelpify/app/create_bussiness_screen/edit_address_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/create_business_controller.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/animated_border_container.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';
import 'package:yelpify/widgets/dimensions.dart';

class CreateBusinessScreen extends StatelessWidget {
  const CreateBusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CreateBusinessController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DebouncedInkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_close.svg",
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01,
                          BlendMode.srcIn,
                        ),
                        width: 22,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Close".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                          fontSize: 14,
                          fontFamily: AppThemeData.semiboldOpenSans,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              title: Text(
                "Add Business".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
              actions: [
                DebouncedInkWell(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (controller.nameTextFieldController.value.text.isEmpty) {
                      ShowToastDialog.showToast("Please enter a business name");
                    }
                    if (controller.businessUrlTextFieldController.value.text.isEmpty) {
                      ShowToastDialog.showToast("Please enter a seo slug");
                    } else if (controller.addressTextFieldController.value.text.isEmpty) {
                      ShowToastDialog.showToast("Please select address");
                    } else if (controller.selectedCategory.isEmpty) {
                      ShowToastDialog.showToast("Please select category");
                    } else {
                      List<String> rawKeywords = controller.metaKeywordsController.value.text.split(',').map((k) => k.trim()).where((k) => k.isNotEmpty).toList();
                      bool hasInvalidKeyword = rawKeywords.any((k) => k.contains(' '));
                      if (hasInvalidKeyword) {
                        controller.metaKeywordsList.value = [];
                        ShowToastDialog.showToast("Please enter keywords in a comma-separated list without spaces.");
                        return;
                      }
                      controller.saveBusiness();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      controller.businessModel.value.id == null ? "Add".tr : "Update".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem() ? AppThemeData.tealDark02 : AppThemeData.teal02,
                        fontSize: 14,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: themeChange.getThem() ? AppThemeData.teal03 : AppThemeData.teal03,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      child: DebouncedInkWell(
                        onTap: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          buildBottomSheet(context, controller);
                        },
                        child: controller.profileImage.isEmpty
                            ? SizedBox(
                                height: Responsive.height(18, context),
                                width: Responsive.width(90, context),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Constant.svgPictureShow("assets/icons/icon_upload.svg", themeChange.getThem() ? AppThemeData.teal02 : AppThemeData.teal02, 20, 20),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Click to \nUpload Image".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02, fontFamily: AppThemeData.medium, fontSize: 14),
                                    ),
                                  ],
                                ),
                              )
                            : DebouncedInkWell(
                                onTap: () {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  buildBottomSheet(context, controller);
                                },
                                child: Constant().hasValidUrl(controller.profileImage.value) == false
                                    ? Image.file(
                                        File(controller.profileImage.value),
                                        height: Responsive.height(18, context),
                                        width: Responsive.width(90, context),
                                        fit: BoxFit.cover,
                                      )
                                    : NetworkImageWidget(
                                        imageUrl: controller.profileImage.value.toString(),
                                        height: Responsive.height(18, context),
                                        width: Responsive.width(90, context),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    controller.businessModel.value.id != null
                        ? Container(
                            decoration: BoxDecoration(
                                color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                border: Border.all(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                                borderRadius: BorderRadius.all(Radius.circular(8))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text("Permanently Closed?".tr,
                                        style: TextStyle(
                                          fontFamily: AppThemeData.boldOpenSans,
                                          fontSize: 14,
                                          color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                        )),
                                  ),
                                  Transform.scale(
                                    scale: 0.9, // Adjust the scale factor
                                    child: CupertinoSwitch(
                                      value: controller.isPermanentClosed.value,
                                      onChanged: (bool value) async {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        ShowToastDialog.showLoader("Please wait");
                                        controller.isPermanentClosed.value = value;
                                        controller.businessModel.value.isPermanentClosed = value;
                                        await FireStoreUtils.addBusiness(controller.businessModel.value);
                                        controller.update();
                                        ShowToastDialog.closeLoader();
                                        ShowToastDialog.showToast(value ? "Business closed" : "Business Reopened");
                                        Get.back();
                                      },
                                      activeTrackColor: AppThemeData.red02, // Color when switch is ON
                                      inactiveTrackColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, // Color when switch is OFF
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      title: 'Country',
                      controller: controller.countryNameTextFieldController.value,
                      hintText: 'Enter mobile number',
                      readOnly: true,
                      suffix: CountryCodePicker(
                        onInit: (value) {
                          controller.countryCodeController.value.text = value?.dialCode ?? Constant.defaultCountryCode;
                          controller.countryISOCodeController.value.text = value?.code ?? Constant.defaultCountryCode;
                        },
                        onChanged: (value) {
                          controller.countryCodeController.value.text = value.dialCode.toString();
                          controller.countryISOCodeController.value.text = value.code ?? Constant.defaultCountryCode;
                        },
                        dialogTextStyle: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, fontWeight: FontWeight.w500, fontFamily: AppThemeData.medium),
                        dialogBackgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                        initialSelection: controller.countryISOCodeController.value.text,
                        comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                        flagDecoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(2)),
                        ),
                        textStyle: TextStyle(
                          color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppThemeData.medium,
                        ),
                        searchDecoration: InputDecoration(
                          iconColor: themeChange.getThem() ? AppThemeData.grey08 : AppThemeData.grey08,
                        ),
                        searchStyle: TextStyle(
                          color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                          fontWeight: FontWeight.w500,
                          fontFamily: AppThemeData.medium,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        if (controller.nameTextFieldController.value.text.trim().isEmpty) {
                          ShowToastDialog.showToast("Please enter product title to generate".tr);
                          return;
                        }
                        controller.generateTitleAndDescription();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: AppThemeData.red02,
                          ),
                          Text(
                            "Generate".tr,
                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.red02 : AppThemeData.red02, fontFamily: AppThemeData.medium, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    AnimatedBorderContainer(
                      padding: controller.isTitleGenerated.value ? const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge) : EdgeInsets.zero,
                      isLoading: controller.isTitleGenerated.value,
                      color: themeChange.getThem() ? AppThemeData.surfaceDark50 : AppThemeData.surface50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFieldWidget(
                            title: 'Required Informations',
                            controller: controller.nameTextFieldController.value,
                            hintText: 'Name',
                            onchange: (value) {
                              controller.businessSlug.value = controller.generateSlugAndUrl(
                                input: value,
                              );
                            },
                          ),
                          TextFieldWidget(
                            controller: controller.descriptionTextFieldController.value,
                            hintText: 'description'.tr,
                            maxLine: 4,
                          ),
                          TextFieldWidget(
                            controller: controller.businessUrlTextFieldController.value,
                            hintText: 'SEO Slug'.tr,
                            textColor: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                            onchange: (value) {
                              controller.businessSlug.value = controller.generateSlugAndUrl(
                                input: value,
                              );
                            },
                          ),
                          Visibility(
                            visible: controller.businessSlug.value.isNotEmpty,
                            child: Column(
                              children: [
                                Text(
                                  "${"Note: Your URL will look like :".tr} ${Constant.deepLinkUrl}/{RandomString}-${controller.businessSlug.value}",
                                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, fontFamily: AppThemeData.regular, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          TextFieldWidget(
                              controller: controller.metaKeywordsController.value,
                              hintText: 'SEO Meta Keywords'.tr,
                              maxLine: 4,
                              onchange: (value) {
                                if (value.trim().isNotEmpty) {
                                  List<String> rawKeywords = value.split(',').map((k) => k.trim()).where((k) => k.isNotEmpty).toList();
                                  bool hasInvalidKeyword = rawKeywords.any((k) => k.contains(' '));
                                  if (hasInvalidKeyword) {
                                    controller.metaKeywordsList.value = [];
                                    ShowToastDialog.showToast("Please enter keywords in a comma-separated list without spaces.");
                                    return;
                                  }
                                  controller.metaKeywordsList.value = rawKeywords;
                                }
                              }),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Text(
                              "Note: This field applies to web based businesses.".tr,
                              style: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, fontFamily: AppThemeData.regular, fontSize: 12),
                            ),
                          ),
                          SizedBox(height: 10),
                          DebouncedInkWell(
                            onTap: () async {
                              List<CategoryModel>? selectedCategories = await Get.to(CategorySelectionScreen(), arguments: {"selectedCategories": controller.selectedCategory});

                              if (selectedCategories != null) {
                                controller.selectedCategory.clear();
                                controller.selectedCategory.addAll(selectedCategories);
                                controller.categoryTextFieldController.value.text = controller.selectedCategory.map((e) => e.name).join(", ");
                              }
                            },
                            child: TextFieldWidget(
                              controller: controller.categoryTextFieldController.value,
                              enable: false,
                              hintText: 'Category',
                              suffix: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  "assets/icons/icon_right.svg",
                                  colorFilter: ColorFilter.mode(
                                    themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    DebouncedInkWell(
                      onTap: () {
                        Get.to(EditAddressScreen(), arguments: {"address": controller.address.value, "location": controller.location.value})!.then(
                          (value) {
                            if (value != null) {
                              controller.location.value = value['location'];
                              controller.address.value = value['address'];
                              print("Address: ${controller.address.value.toJson()}");
                              controller.addressTextFieldController.value.text = Constant.getFullAddressModel(controller.address.value);
                            }
                          },
                        );
                      },
                      child: TextFieldWidget(
                        controller: controller.addressTextFieldController.value,
                        hintText: 'Address'.tr,
                        enable: false,
                        suffix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/icon_right.svg",
                            colorFilter: ColorFilter.mode(
                              themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFieldWidget(
                      title: 'Optional Details',
                      controller: controller.phoneNumberTextFieldController.value,
                      hintText: 'Phone',
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                    ),
                    TextFieldWidget(
                      controller: controller.websiteTextFieldController.value,
                      hintText: 'Website'.tr,
                    ),
                    TextFieldWidget(
                      controller: controller.fbLinkTextFieldController.value,
                      hintText: 'Facebook link'.tr,
                      suffix: IconButton(onPressed: () {}, icon: Image.asset("assets/images/fb.png", height: 20, width: 20)),
                    ),
                    TextFieldWidget(
                      controller: controller.instaLinkTextFieldController.value,
                      hintText: 'Instagram Link'.tr,
                      suffix: IconButton(onPressed: () {}, icon: Image.asset("assets/images/insta.png", height: 20, width: 20)),
                    ),
                    TextFieldWidget(
                      controller: controller.notesOfTheYelpTeamTextFieldController.value,
                      hintText: 'Provide any additional information so we can make this business’s information as accurate as possible.'.tr,
                      maxLine: 5,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future buildBottomSheet(BuildContext context, CreateBusinessController controller) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          final themeChange = Provider.of<DarkThemeProvider>(context);
          return StatefulBuilder(builder: (context, setState) {
            return SizedBox(
              height: Responsive.height(22, context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "Please Select".tr,
                      style: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, fontFamily: AppThemeData.bold, fontSize: 16),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.camera),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Camera".tr),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () => controller.pickFile(source: ImageSource.gallery),
                                icon: const Icon(
                                  Icons.photo_library_sharp,
                                  size: 32,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 3),
                              child: Text("Gallery".tr),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }
}
