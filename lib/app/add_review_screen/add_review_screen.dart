import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/add_review_controller.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/animated_border_container.dart';
import 'package:yelpify/widgets/custom_star_rating/custom_star_rating_screen.dart';
import 'package:yelpify/widgets/dimensions.dart';

import '../../themes/app_them_data.dart';
import '../../utils/dark_theme_provider.dart';

class AddReviewScreen extends StatelessWidget {
  const AddReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddReviewController(),
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
                "Add Review".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${controller.businessModel.value.businessName}".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                              fontSize: 16,
                              fontFamily: AppThemeData.bold,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            Constant.getFullAddressModel(controller.businessModel.value.address!).tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03,
                              fontSize: 14,
                              fontFamily: AppThemeData.mediumOpenSans,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(
                              color: themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03,
                            ),
                          ),
                          Text(
                            "How would you rate your experience?".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                              fontSize: 16,
                              fontFamily: AppThemeData.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          CustomStarRating(
                            initialRating: "0",
                            size: 30,
                            bgColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                            emptyColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                            onRatingUpdate: (value) {
                              controller.rating.value = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.generateComment(
                                  businessName: controller.businessModel.value.businessName, categoryName: controller.businessModel.value.category?[0].name, rating: controller.rating.value);
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
                                  Text(
                                    "Tell us about your experience?".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                                      fontSize: 16,
                                      fontFamily: AppThemeData.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "A few things to consider in your review".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03,
                                      fontSize: 14,
                                      fontFamily: AppThemeData.mediumOpenSans,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFieldWidget(
                                    controller: controller.reviewDescriptionController.value,
                                    hintText: 'write your experience here....'.tr,
                                    maxLine: 6,
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 14,
                          ),
                          SizedBox(
                            height: 130,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            buildBottomSheet(context, controller);
                                          },
                                          child: SizedBox(
                                              height: 120,
                                              width: 120,
                                              child: Center(
                                                  child: Constant.svgPictureShow("assets/icons/icon_picture.svg", themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03, 40, 40))),
                                        ),
                                      ),
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
                                                            width: 120,
                                                            height: 120,
                                                          )
                                                        : NetworkImageWidget(
                                                            imageUrl: controller.images[index],
                                                            fit: BoxFit.cover,
                                                            width: 120,
                                                            height: 120,
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
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: Container(
              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RoundedButtonFill(
                      title: 'Post review'.tr,
                      height: 5,
                      textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                      color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02,
                      onPress: () {
                        controller.uploadReview();
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future buildBottomSheet(BuildContext context, AddReviewController controller) {
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
