import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart' show DateRangePickerSelectionChangedArgs, DateRangePickerSelectionMode, PickerDateRange, SfDateRangePicker;
import 'package:yelpify/app/sponsored_screens/sponsored_history.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/sponsored_controller.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';

class SponsoredScreen extends StatelessWidget {
  const SponsoredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SponsoredController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/icon_left.svg",
                      colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, BlendMode.srcIn),
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              title: Text(
                "Sponsor Your business".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {
                      Get.to(SponsoredHistory());
                    },
                    child: Icon(
                      Icons.history,
                      color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                    ),
                  ),
                )
              ],
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          DropdownButtonFormField<BusinessModel>(
                            hint: Text("Select Business"),
                            initialValue: controller.selectedBusiness.value.id == null ? null : controller.selectedBusiness.value,
                            onChanged: (BusinessModel? newValue) {
                              controller.selectedBusiness.value = newValue!;
                            },
                            items: controller.businessList.map((BusinessModel reason) {
                              return DropdownMenuItem<BusinessModel>(
                                value: reason,
                                child: Text(reason.businessName.toString()),
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
                          Container(
                            decoration: BoxDecoration(
                                color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: SfDateRangePicker(
                                backgroundColor: Colors.transparent,
                                onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                                  if (args.value is PickerDateRange) {
                                    controller.startValidityDate.value = args.value.startDate;
                                    controller.endValidityDate.value = args.value.endDate;
                                  }
                                },
                                selectionMode: DateRangePickerSelectionMode.range,
                                minDate: DateTime.now(),
                                maxDate: DateTime.now().add(Duration(days: 5 * 365)),
                                initialSelectedRange: PickerDateRange(
                                  controller.startValidityDate.value,
                                  controller.endValidityDate.value,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFieldWidget(
                            controller: controller.noteTextFieldController.value,
                            hintText: 'Note for admin',
                            maxLine: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  RoundedButtonFill(
                    title: 'Sent a Request'.tr,
                    height: 5,
                    textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                    color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02,
                    onPress: () {
                      if (controller.selectedBusiness.value.id == null || controller.selectedBusiness.value.id == '') {
                        ShowToastDialog.showToast("First, select a business, then send your request.".tr);
                      } else {
                        controller.sentSponsoredRequest();
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
