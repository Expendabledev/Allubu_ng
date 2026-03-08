import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class AddHoursController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool showWorkingHours = true.obs;
  Rx<BusinessModel> businessModel = BusinessModel().obs;

  RxMap<String, DayHours> businessWeek = {
    'monday': DayHours(isOpen: false, timeRanges: []),
    'tuesday': DayHours(isOpen: false, timeRanges: []),
    'wednesday': DayHours(isOpen: false, timeRanges: []),
    'thursday': DayHours(isOpen: false, timeRanges: []),
    'friday': DayHours(isOpen: false, timeRanges: []),
    'saturday': DayHours(isOpen: false, timeRanges: []),
    'sunday': DayHours(isOpen: false, timeRanges: []),
  }.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      businessModel.value = argumentData['businessModel'];
      showWorkingHours.value = businessModel.value.showWorkingHours ?? true;
      final existingHours = businessModel.value.businessHours;
      if (existingHours != null) {
        businessWeek.value = {
          'monday': _fromStrings(existingHours.monday),
          'tuesday': _fromStrings(existingHours.tuesday),
          'wednesday': _fromStrings(existingHours.wednesday),
          'thursday': _fromStrings(existingHours.thursday),
          'friday': _fromStrings(existingHours.friday),
          'saturday': _fromStrings(existingHours.saturday),
          'sunday': _fromStrings(existingHours.sunday),
        };
      }
    }
    isLoading.value = false;
    update();
  }

  BusinessHours getBusinessHours() {
    return BusinessHours(
      monday: _convertDay('monday'),
      tuesday: _convertDay('tuesday'),
      wednesday: _convertDay('wednesday'),
      thursday: _convertDay('thursday'),
      friday: _convertDay('friday'),
      saturday: _convertDay('saturday'),
      sunday: _convertDay('sunday'),
    );
  }

  List<String>? _convertDay(String day) {
    final dayHours = businessWeek[day];
    if (dayHours == null || !dayHours.isOpen) return [];
    return dayHours.timeRanges.map((e) => e.toRangeString()).toList();
  }

  BusinessHours generateBusinessHours() {
    return BusinessHours(
      monday: businessWeek['monday']!.isOpen ? businessWeek['monday']!.timeRanges.map((e) => e.toRangeString()).toList() : [],
      tuesday: businessWeek['tuesday']!.isOpen ? businessWeek['tuesday']!.timeRanges.map((e) => e.toRangeString()).toList() : [],
      wednesday: businessWeek['wednesday']!.isOpen ? businessWeek['wednesday']!.timeRanges.map((e) => e.toRangeString()).toList() : [],
      thursday: businessWeek['thursday']!.isOpen ? businessWeek['thursday']!.timeRanges.map((e) => e.toRangeString()).toList() : [],
      friday: businessWeek['friday']!.isOpen ? businessWeek['friday']!.timeRanges.map((e) => e.toRangeString()).toList() : [],
      saturday: businessWeek['saturday']!.isOpen ? businessWeek['saturday']!.timeRanges.map((e) => e.toRangeString()).toList() : [],
      sunday: businessWeek['sunday']!.isOpen ? businessWeek['sunday']!.timeRanges.map((e) => e.toRangeString()).toList() : [],
    );
  }

  Future<void> saveDetails() async {
    ShowToastDialog.showLoader("Please wait.");
    businessModel.value.businessHours = generateBusinessHours();
    businessModel.value.showWorkingHours = showWorkingHours.value;
    await FireStoreUtils.addBusiness(businessModel.value).then(
      (value) {
        ShowToastDialog.showToast("Business Hours save successfully");
        Get.back(result: true);
      },
    );
  }

  DayHours _fromStrings(List<dynamic>? times) {
    if (times == null || times.isEmpty) {
      return DayHours(isOpen: false, timeRanges: []);
    }
    List<TimeRange> ranges = times.map((str) {
      final parts = str.split('-');
      final openParts = parts[0].split(':');
      final closeParts = parts[1].split(':');

      return TimeRange(
        open: TimeOfDay(hour: int.parse(openParts[0]), minute: int.parse(openParts[1])),
        close: TimeOfDay(hour: int.parse(closeParts[0]), minute: int.parse(closeParts[1])),
      );
    }).toList();
    return DayHours(isOpen: true, timeRanges: ranges);
  }
}
