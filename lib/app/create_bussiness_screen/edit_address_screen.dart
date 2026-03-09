import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/edit_address_controller.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/round_button_border.dart';
import 'package:allubmarket/themes/text_field_widget.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/widgets/place_picker/location_picker_screen.dart';
import 'package:allubmarket/widgets/place_picker/selected_location_model.dart';

class EditAddressScreen extends StatelessWidget {
  const EditAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: EditAddressController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/icon_close.svg",
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.greyDark06
                              : AppThemeData.grey01,
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
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
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
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark08
                      : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              title: Text(
                "Edit Address".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark01
                      : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    if (controller.location.value.latitude == null ||
                        controller.location.value.longitude == null) {
                      ShowToastDialog.showToast(
                          "Please select a location from the map");
                      return;
                    } else {
                      controller.address.value.street =
                          controller.addressOneTextFieldController.value.text;
                      controller.address.value.locality =
                          controller.addressTwoFieldController.value.text;
                      controller.address.value.postalCode =
                          controller.addressThreeFieldController.value.text;
                      controller.address.value.formattedAddress =
                          Constant.getFullAddressModel(
                              controller.address.value);

                      Get.back(result: {
                        "address": controller.address.value,
                        "location": controller.location.value
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Save".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.tealDark02
                            : AppThemeData.teal02,
                        fontSize: 14,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                  ),
                )
              ],
            ),
            backgroundColor: themeChange.getThem()
                ? AppThemeData.surfaceDark50
                : AppThemeData.surface50,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  RoundedButtonBorder(
                    title: 'Fill From Map'.tr,
                    textColor: themeChange.getThem()
                        ? AppThemeData.greyDark01
                        : AppThemeData.grey01,
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark10
                        : AppThemeData.grey10,
                    borderColor: themeChange.getThem()
                        ? AppThemeData.greyDark06
                        : AppThemeData.grey06,
                    onPress: () {
                      Get.to(LocationPickerScreen(), arguments: {
                        'zipCode':
                            controller.addressThreeFieldController.value.text
                      })!
                          .then(
                        (value) {
                          if (value != null) {
                            SelectedLocationModel selectedLocationModel = value;

                            controller.location.value = LatLngModel(
                              latitude: selectedLocationModel.latLng!.latitude
                                  .toString(),
                              longitude: selectedLocationModel.latLng!.longitude
                                  .toString(),
                            );
                            controller.address.value = AddressModel.fromJson(
                                selectedLocationModel.address!.toJson());

                            controller
                                    .addressOneTextFieldController.value.text =
                                selectedLocationModel.address!.street ?? '';
                            controller.addressTwoFieldController.value.text =
                                '${selectedLocationModel.address!.locality}';
                            controller.addressThreeFieldController.value.text =
                                selectedLocationModel.address!.postalCode ?? '';
                          }
                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFieldWidget(
                    controller: controller.addressOneTextFieldController.value,
                    hintText: '124 main st'.tr,
                  ),
                  TextFieldWidget(
                    controller: controller.addressTwoFieldController.value,
                    hintText: 'ste 200',
                  ),
                  TextFieldWidget(
                    controller: controller.addressThreeFieldController.value,
                    hintText: 'San Francisco, CA 94103',
                  ),
                ],
              ),
            ),
          );
        });
  }
}
