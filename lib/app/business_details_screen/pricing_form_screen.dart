import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/pricing_form_controller.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/themes/text_field_widget.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/network_image_widget.dart';

class PricingFormScreen extends StatelessWidget {
  const PricingFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PricingFormController(),
        builder: (controller) {
          return controller.isLoading.value
              ? Constant.loader()
              : Scaffold(
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
                              width: 22,
                              colorFilter: ColorFilter.mode(
                                themeChange.getThem()
                                    ? AppThemeData.greyDark06
                                    : AppThemeData.grey01,
                                BlendMode.srcIn,
                              ),
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
                    title: Text(
                      "${controller.businessModel.value.businessName}".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark01
                            : AppThemeData.grey01,
                        fontSize: 16,
                        fontFamily: AppThemeData.semiboldOpenSans,
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFieldWidget(
                          title: 'Add details you’d like to add?'.tr,
                          controller:
                              controller.descriptionTextFieldController.value,
                          hintText: 'write your experience here....'.tr,
                          maxLine: 10,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Would you like to add photos?'.tr,
                          style: TextStyle(
                            fontFamily: AppThemeData.boldOpenSans,
                            fontSize: 14,
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: Responsive.width(100, Get.context!),
                          decoration: BoxDecoration(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark10
                                : AppThemeData.grey10,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: InkWell(
                              onTap: () {
                                buildBottomSheet(context, controller);
                              },
                              child: Column(
                                children: [
                                  ClipOval(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark09
                                              : AppThemeData.grey09),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Constant.svgPictureShow(
                                            "assets/icons/icon_upload.svg",
                                            themeChange.getThem()
                                                ? AppThemeData.greyDark03
                                                : AppThemeData.grey03,
                                            22,
                                            22),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Upload Image".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark01
                                          : AppThemeData.grey01,
                                      fontSize: 16,
                                      fontFamily: AppThemeData.semiboldOpenSans,
                                    ),
                                  ),
                                  Text(
                                    "Only Image".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark04
                                          : AppThemeData.grey04,
                                      fontSize: 12,
                                      fontFamily: AppThemeData.semiboldOpenSans,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        controller.images.isEmpty
                            ? const SizedBox()
                            : SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  itemCount: controller.images.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            child: controller.images[index]
                                                        .runtimeType ==
                                                    XFile
                                                ? Image.file(
                                                    File(controller
                                                        .images[index].path),
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  )
                                                : NetworkImageWidget(
                                                    imageUrl: controller
                                                        .images[index],
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: InkWell(
                                              onTap: () async {
                                                controller.images
                                                    .removeAt(index);
                                              },
                                              child: ClipOval(
                                                child: Container(
                                                  height: 30,
                                                  width: 30,
                                                  color: AppThemeData.red03,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Constant.svgPictureShow(
                                                        "assets/icons/delete-one.svg",
                                                        AppThemeData.red02,
                                                        20,
                                                        20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: Container(
                    width: Responsive.width(100, Get.context!),
                    decoration: BoxDecoration(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark10
                          : AppThemeData.grey10,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 30),
                      child: RoundedButtonFill(
                        title: 'Send Request'.tr,
                        height: 5.5,
                        textColor: themeChange.getThem()
                            ? AppThemeData.greyDark10
                            : AppThemeData.grey10,
                        color: themeChange.getThem()
                            ? AppThemeData.redDark02
                            : AppThemeData.red02,
                        onPress: () {
                          if (controller.descriptionTextFieldController.value
                              .text.isEmpty) {
                            ShowToastDialog.showToast("Please enter details");
                          } else {
                            controller.submitRequest();
                          }
                        },
                      ),
                    ),
                  ),
                );
        });
  }

  Future buildBottomSheet(
      BuildContext context, PricingFormController controller) {
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
                      style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          fontFamily: AppThemeData.bold,
                          fontSize: 16),
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
                                onPressed: () => controller.pickFile(
                                    source: ImageSource.camera),
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
                                onPressed: () => controller.pickFile(
                                    source: ImageSource.gallery),
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
