import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/add_hours_controller.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';

class AddHoursScreen extends StatelessWidget {
  const AddHoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddHoursController(),
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
                title: Text(
                  "Add Hours".tr,
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
                      controller.saveDetails();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        "Submit".tr,
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
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Show your hours to customer?",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                    fontSize: 14,
                                    fontFamily: AppThemeData.boldOpenSans,
                                  ),
                                ),
                              ),
                              Transform.scale(
                                scale: 0.9, // Adjust the scale factor
                                child: CupertinoSwitch(
                                  value: controller.showWorkingHours.value,
                                  onChanged: (bool value) async {
                                    controller.showWorkingHours.value = value;
                                  },
                                  activeTrackColor: AppThemeData.red02, // Color when switch is ON
                                  inactiveTrackColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, // Color when switch is OFF
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        controller.showWorkingHours.value == false
                            ? SizedBox()
                            : Expanded(
                                child: ListView(
                                  padding: const EdgeInsets.all(16),
                                  children: controller.businessWeek.entries.map((entry) => _buildDayEditor(context, controller, entry.key, entry.value)).toList(),
                                ),
                              ),
                      ],
                    ));
        });
  }

  Widget _buildDayEditor(BuildContext context, AddHoursController controller, String day, DayHours hours) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                day[0].toUpperCase() + day.substring(1),
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  fontSize: 14,
                  fontFamily: AppThemeData.boldOpenSans,
                ),
              ),
            ),
            Transform.scale(
              scale: 0.9, // Adjust the scale factor
              child: CupertinoSwitch(
                value: hours.isOpen,
                onChanged: (bool value) async {
                  controller.businessWeek[day] = DayHours(isOpen: value, timeRanges: hours.timeRanges);
                },
                activeTrackColor: AppThemeData.red02, // Color when switch is ON
                inactiveTrackColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, // Color when switch is OFF
              ),
            ),
          ],
        ),
        if (hours.isOpen)
          Column(
            children: [
              for (int i = 0; i < hours.timeRanges.length; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final pickedTime = await Constant.pickTime(
                              context: context,
                              initialTime: hours.timeRanges[i].open,
                            );
                            if (pickedTime != null) {
                              hours.timeRanges[i].open = pickedTime;
                              controller.businessWeek.refresh();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                              border: Border.all(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: Text(
                                'Open - ${hours.timeRanges[i].open.format(context)}'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppThemeData.semiboldOpenSans,
                                  fontSize: 14,
                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            final pickedTime = await Constant.pickTime(
                              context: context,
                              initialTime: hours.timeRanges[i].close,
                            );
                            if (pickedTime != null) {
                              hours.timeRanges[i].close = pickedTime;
                              controller.businessWeek.refresh();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                              border: Border.all(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: Text(
                                'Close: ${hours.timeRanges[i].close.format(context)}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: AppThemeData.semiboldOpenSans,
                                  fontSize: 14,
                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          hours.timeRanges.removeAt(i);
                          controller.businessWeek.refresh();
                        },
                        child: Constant.svgPictureShow("assets/icons/icon_delete-one.svg", themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02, null, null),
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    hours.timeRanges.add(TimeRange(
                      open: const TimeOfDay(hour: 9, minute: 0),
                      close: const TimeOfDay(hour: 17, minute: 0),
                    ));
                    controller.businessWeek.refresh();
                  },
                  icon: const Icon(Icons.add),
                  label: Text("Add Hours".tr),
                ),
              )
            ],
          ),
        const Divider(),
      ],
    );
  }
}
