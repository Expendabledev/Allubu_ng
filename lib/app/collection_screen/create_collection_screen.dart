import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/create_collection_controller.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';

class CreateCollectionScreen extends StatelessWidget {
  const CreateCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CreateCollectionController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
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
              title: Text(
                "New collection".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldWidget(
                    controller: controller.collectionNameTextFieldController.value,
                    hintText: 'Enter new collection name'.tr,
                    title: 'Collection Name'.tr,
                  ),
                  Text(
                    "Make Collection Public".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                      fontSize: 12,
                      fontFamily: AppThemeData.boldOpenSans,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "${'A public collection can be openly featured on'.tr} ${Constant.applicationName} ${'and alerts followers when you make updates. Collections can still be visible to others if tou share a link to it.'.tr}"
                              .tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                            fontSize: 14,
                            fontFamily: AppThemeData.regularOpenSans,
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.9, // Adjust the scale factor
                        child: CupertinoSwitch(
                          value: controller.isPublic.value,
                          onChanged: (bool value) async {
                            controller.isPublic.value = value;
                          },
                          activeTrackColor: AppThemeData.red02, // Color when switch is ON
                          inactiveTrackColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, // Color when switch is OFF
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RoundedButtonFill(
                    title: 'Save'.tr,
                    height: 5.5,
                    textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                    color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02,
                    onPress: () {
                      if (controller.collectionNameTextFieldController.value.text.isEmpty) {
                        ShowToastDialog.showToast("Please enter the collection name".tr);
                      } else {
                        controller.createMyBookmark();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
