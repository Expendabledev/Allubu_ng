import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/add_check_in_controller.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/network_image_widget.dart';

class AddCheckInScreen extends StatelessWidget {
  const AddCheckInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddCheckInController(),
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
                "${controller.businessModel.value.businessName}".tr,
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
                    controller.checkIn();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Check In".tr,
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
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                              border: Border.all(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Share with friends on".tr,
                                    style: TextStyle(
                                      fontFamily: AppThemeData.boldOpenSans,
                                      fontSize: 14,
                                      color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                    ),
                                  ),
                                ),
                                Transform.scale(
                                  scale: 0.9, // Adjust the scale factor
                                  child: CupertinoSwitch(
                                    value: controller.shareWithFriends.value,
                                    onChanged: (bool value) async {
                                      controller.shareWithFriends.value = value;
                                    },
                                    activeTrackColor: AppThemeData.red02, // Color when switch is ON
                                    inactiveTrackColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, // Color when switch is OFF
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          controller: controller.commentTextFieldController.value,
                          hintText: 'add_comment_hint'.trParams({
                            'example': 'Hanging out with friends',
                          }).tr,
                          maxLine: 5,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: themeChange.getThem() ? AppThemeData.teal03 : AppThemeData.teal03,
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
                                )),
                          ),
                        ),
                        controller.images.isEmpty
                            ? const SizedBox()
                            : Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SizedBox(
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
                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                    child: controller.images[index].runtimeType == XFile
                                                        ? Image.file(
                                                            File(controller.images[index].path),
                                                            fit: BoxFit.cover,
                                                            width: 100,
                                                            height: 100,
                                                          )
                                                        : NetworkImageWidget(
                                                            imageUrl: controller.images[index],
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
                                                        controller.images.removeAt(index);
                                                      },
                                                      child: ClipOval(
                                                        child: Container(
                                                          height: 30,
                                                          width: 30,
                                                          color: AppThemeData.red03,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Constant.svgPictureShow("assets/icons/delete-one.svg", AppThemeData.red02, 20, 20),
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
                              ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
          );
        });
  }

  Future buildBottomSheet(BuildContext context, AddCheckInController controller) {
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
