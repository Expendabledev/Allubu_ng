import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/add_menu_photo_controller.dart';
import 'package:yelpify/models/photo_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';

class UploadMenuScreen extends StatelessWidget {
  const UploadMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddMenuPhotoController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
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
                          themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01,
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
                "Upload Menu".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    controller.uploadMenuImage();
                  },
                  child: Text(
                    "Submit".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeChange.getThem() ? AppThemeData.tealDark02 : AppThemeData.teal02,
                      fontSize: 14,
                      fontFamily: AppThemeData.semiboldOpenSans,
                    ),
                  ),
                )
              ],
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Menu".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                            fontSize: 16,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // 3 columns
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: 1, // Adjust based on image size
                            ),
                            itemCount: controller.menuPhotosList.length + 1, // First item is the upload button
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                // First item: Static Upload Button
                                return GestureDetector(
                                  onTap: () {
                                    buildBottomSheet(context, controller);
                                  },
                                  child: Container(
                                    width: Responsive.width(100, context),
                                    height: Responsive.height(100, context),
                                    decoration: BoxDecoration(
                                      color: AppThemeData.teal03,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Constant.svgPictureShow("assets/icons/icon_upload.svg", themeChange.getThem() ? AppThemeData.teal02 : AppThemeData.teal02, 20, 20),
                                        SizedBox(height: 10),
                                        Text(
                                          "Click to \nUpload Image".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                                            fontSize: 10,
                                            fontFamily: AppThemeData.semiboldOpenSans,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                PhotoModel menuModel = controller.menuPhotosList[index - 1];
                                return Stack(
                                  children: [
                                    menuModel.imageUrl.runtimeType == XFile
                                        ? Image.file(
                                            File(menuModel.imageUrl.path),
                                            fit: BoxFit.cover,
                                            height: Responsive.height(100, context),
                                            width: Responsive.width(100, context),
                                          )
                                        : NetworkImageWidget(
                                            imageUrl: menuModel.imageUrl,
                                            fit: BoxFit.cover,
                                            height: Responsive.height(100, context),
                                            width: Responsive.width(100, context),
                                          ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: InkWell(
                                        onTap: () async {
                                          ShowToastDialog.showLoader("Please wait".tr);
                                          await FireStoreUtils.removePhoto(menuModel).then(
                                            (value) {
                                              ShowToastDialog.closeLoader();
                                              controller.menuPhotosList.removeAt(index - 1);
                                            },
                                          );
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            height: 30,
                                            width: 30,
                                            color: AppThemeData.red03,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Constant.svgPictureShow("assets/icons/delete-one.svg", AppThemeData.red02, 30, 30),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  Future buildBottomSheet(BuildContext context, AddMenuPhotoController controller) {
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
