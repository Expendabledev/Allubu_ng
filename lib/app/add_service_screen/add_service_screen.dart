import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/add_service_controller.dart';
import 'package:yelpify/models/service_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';

class AddServiceScreen extends StatelessWidget {
  const AddServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddServiceController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DebouncedInkWell(
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
                "Add Service".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
              actions: [
                DebouncedInkWell(
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
                : controller.serviceList.isEmpty
                    ? Constant.showEmptyView(message: "Service Not available".tr)
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.serviceList.length,
                        itemBuilder: (context, index) {
                          ServiceModel serviceModel = controller.serviceList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${serviceModel.name}".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                        fontSize: 16,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                    ListView.builder(
                                      itemCount: serviceModel.options?.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(), // Prevent scrolling inside scrolling
                                      itemBuilder: (context, index1) {
                                        return Obx(
                                          () => CheckboxListTile(
                                            value: isSelected(controller, serviceModel, serviceModel.options![index1]),
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            onChanged: (bool? value) {
                                              controller.toggleOption(serviceModel, serviceModel.options![index1], value ?? false);
                                            },
                                            title: Text(
                                              serviceModel.options![index1].name.toString().tr,
                                              style: TextStyle(
                                                color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                fontSize: 16,
                                                fontFamily: AppThemeData.regularOpenSans,
                                              ),
                                            ),
                                            controlAffinity: ListTileControlAffinity.leading,
                                            // Checkbox on the left
                                            activeColor: AppThemeData.red02, // Change color as needed
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          );
        });
  }

  bool isSelected(AddServiceController controller, ServiceModel serviceModel, OptionModel option) {
    final index = controller.selectedServiceModel.indexWhere((e) => e.id == serviceModel.id);
    if (index == -1) return false;
    return controller.selectedServiceModel[index].options?.any((e) => e.name == option.name) ?? false;
  }
}
