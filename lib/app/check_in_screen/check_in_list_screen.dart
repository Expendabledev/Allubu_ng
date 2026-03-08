import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/check_in_list_controller.dart';
import 'package:yelpify/models/check_in_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/network_image_widget.dart';

class CheckInListScreen extends StatelessWidget {
  const CheckInListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CheckInListController(),
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
                "Check In".tr,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: controller.checkInList.isEmpty
                        ? Constant.showEmptyView(message: "No check-ins available for any place.".tr)
                        : ListView.builder(
                            itemCount: controller.checkInList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              CheckInModel checkInModel = controller.checkInList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      seeCheckInDetailsFilterBottomSheet(themeChange, controller, checkInModel);
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "My Check-In".tr,
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData.semiboldOpenSans,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                Constant.timeAgo(checkInModel.createdAt!),
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03,
                                                  fontSize: 14,
                                                  fontFamily: AppThemeData.semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Constant.svgPictureShow("assets/icons/icon_right.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, 30, 30)
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          );
        });
  }

  void seeCheckInDetailsFilterBottomSheet(themeChange, CheckInListController controller, CheckInModel chekInModel) {
    Get.bottomSheet(
      DraggableScrollableSheet(
          initialChildSize: 0.4,
          // Starts at 30% of screen height
          minChildSize: 0.4,
          // Minimum height (30% of screen)
          maxChildSize: 0.9,
          // Can expand up to
          shouldCloseOnMinExtent: false,
          builder: (context, scrollController) {
            return Container(
              height: Responsive.height(32, Get.context!),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: themeChange.getThem() ? AppThemeData.surfaceDark50 : AppThemeData.surface50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Check-In".tr,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                            fontSize: 22,
                            fontFamily: AppThemeData.boldOpenSans,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SvgPicture.asset(
                            "assets/icons/icon_close.svg",
                            width: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  Column(
                    children: [
                      chekInModel.description == null || chekInModel.description!.isEmpty
                          ? SizedBox()
                          : Text(
                              chekInModel.description.toString(),
                              style: TextStyle(
                                color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                fontSize: 16,
                                fontFamily: AppThemeData.semiboldOpenSans,
                              ),
                            ),
                      chekInModel.images!.isEmpty
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                height: 120,
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: chekInModel.images!.length,
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
                                                  child: NetworkImageWidget(
                                                    imageUrl: chekInModel.images![index],
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
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
                    ],
                  )
                ],
              ),
            );
          }),
      isScrollControlled: true, // Allows BottomSheet to take full height
      isDismissible: false,
    );
  }
}
