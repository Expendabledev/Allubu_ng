import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/add_item_manully_controller.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/text_field_widget.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/network_image_widget.dart';

class AddItemManuallyScreen extends StatelessWidget {
  const AddItemManuallyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddItemManuallyController(),
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
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () {
                      if (controller
                          .nameTextFieldController.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter name");
                      } else if (controller
                          .descriptionTextFieldController.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter description");
                      } else if (controller
                          .priceTextFieldController.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter a price");
                      } else {
                        controller.saveItem();
                      }
                    },
                    child: Text(
                      "Submit".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.tealDark02
                            : AppThemeData.teal02,
                        fontSize: 14,
                        fontFamily: AppThemeData.semiboldOpenSans,
                      ),
                    ),
                  ),
                )
              ],
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
                "Add Item".tr,
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add Image (Max 4 images)".tr,
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
                    decoration: BoxDecoration(
                      color: themeChange.getThem()
                          ? AppThemeData.teal03
                          : AppThemeData.teal03,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        buildBottomSheet(context, controller);
                      },
                      child: SizedBox(
                          height: Responsive.height(18, context),
                          width: Responsive.width(90, context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Constant.svgPictureShow(
                                  "assets/icons/icon_upload.svg",
                                  themeChange.getThem()
                                      ? AppThemeData.teal02
                                      : AppThemeData.teal02,
                                  20,
                                  20),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Click to \nUpload Image".tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark02
                                        : AppThemeData.grey02,
                                    fontFamily: AppThemeData.medium,
                                    fontSize: 14),
                              ),
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  controller.images.isEmpty
                      ? const SizedBox()
                      : SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: controller.images.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  // physics: const NeverScrollableScrollPhysics(),
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
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                  TextFieldWidget(
                    title: 'Menu Item Details'.tr,
                    controller: controller.nameTextFieldController.value,
                    hintText: 'Name'.tr,
                  ),
                  TextFieldWidget(
                    controller: controller.descriptionTextFieldController.value,
                    hintText: 'Descriptions'.tr,
                    maxLine: 5,
                  ),
                  TextFieldWidget(
                    controller: controller.priceTextFieldController.value,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    hintText: 'Price: ex\$5'.tr,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future buildBottomSheet(
      BuildContext context, AddItemManuallyController controller) {
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
