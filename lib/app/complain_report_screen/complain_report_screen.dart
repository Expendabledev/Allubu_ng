import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/complain_report_controller.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';

class ComplainReportScreen extends StatelessWidget {
  const ComplainReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ComplainReportController(),
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
                        "assets/icons/icon_left.svg",
                        width: 22,
                        colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Back".tr,
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
                "Complain & Report".tr,
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
                    if (controller.selectedReason.value.isEmpty) {
                      ShowToastDialog.showToast("Please select reason".tr);
                    } else if (controller.reportTextFieldController.value.text.isEmpty) {
                      ShowToastDialog.showToast("Please share your experience".tr);
                    } else {
                      controller.submitReport();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Send".tr,
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
                      children: [
                        DropdownButtonFormField<String>(
                          hint: Text("Select a reason".tr),
                          initialValue: controller.selectedReason.value.isEmpty ? null : controller.selectedReason.value,
                          onChanged: (String? newValue) {
                            controller.selectedReason.value = newValue!;
                          },
                          items: controller.reportCategories.map((String reason) {
                            return DropdownMenuItem<String>(
                              value: reason,
                              child: Text(reason),
                            );
                          }).toList(),
                          style: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, fontFamily: AppThemeData.medium),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFieldWidget(
                          controller: controller.reportTextFieldController.value,
                          hintText: 'What went wrong? Share your experience.'.tr,
                          maxLine: 6,
                        ),
                      ],
                    ),
                  ),
          );
        });
  }
}
