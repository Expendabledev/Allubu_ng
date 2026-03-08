import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/highlight_controller.dart';
import 'package:yelpify/models/highlight_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';

class HighlightScreen extends StatelessWidget {
  const HighlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: HighLightController(),
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
                "Add Business Highlight".tr,
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
                : controller.highLightList.isEmpty
                    ? Constant.showEmptyView(message: "Service Not available".tr)
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.highLightList.length,
                        itemBuilder: (context, index) {
                          HighlightModel serviceModel = controller.highLightList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Obx(
                              () => Container(
                                color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  child: CheckboxListTile(
                                    value: isSelected(controller, serviceModel),
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    onChanged: (bool? value) {
                                      if (isSelected(controller, serviceModel)) {
                                        controller.selectedHighLightList.remove(serviceModel);
                                      } else {
                                        controller.selectedHighLightList.add(serviceModel);
                                      }
                                    },
                                    title: Row(
                                      children: [
                                        NetworkImageWidget(
                                          width: Responsive.width(8, context),
                                          height: Responsive.width(8, context),
                                          imageUrl: serviceModel.photo.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          serviceModel.title.toString().tr,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                            fontSize: 16,
                                            fontFamily: AppThemeData.regularOpenSans,
                                          ),
                                        ),
                                      ],
                                    ),
                                    controlAffinity: ListTileControlAffinity.trailing,
                                    // Checkbox on the left
                                    activeColor: AppThemeData.red02, // Change color as needed
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          );
        });
  }

  bool isSelected(
    HighLightController controller,
    HighlightModel model,
  ) {
    final index = controller.selectedHighLightList.indexWhere((e) => e.id == model.id);
    if (index == -1) return false;
    return controller.selectedHighLightList[index].id == model.id;
  }
}
