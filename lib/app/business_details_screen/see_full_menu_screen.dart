import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:yelpify/app/photo_screen/photo_view_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/see_full_menu_controller.dart';
import 'package:yelpify/models/item_model.dart';
import 'package:yelpify/models/photo_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/readmore.dart';

class SeeFullMenuScreen extends StatelessWidget {
  const SeeFullMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SeeFullMenuController(),
        builder: (controller) {
          return DefaultTabController(
            length: 3, // Number of tabs
            child: Scaffold(
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
                bottom: TabBar(
                  labelColor: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  unselectedLabelColor: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontFamily: AppThemeData.semiboldOpenSans,
                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14,
                    fontFamily: AppThemeData.regularOpenSans,
                    color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  // Makes the indicator full width
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4, color: AppThemeData.red02), // Full-width red indicator
                  ),
                  tabs: [
                    Tab(text: "Menu  Photos".tr),
                    Tab(text: "Items".tr),
                    Tab(text: "Website".tr),
                  ],
                ),
                title: Text(
                  "Menu Item".tr,
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
                  : TabBarView(
                      children: [
                        buildMenuPhotoGrid(
                          themeChange,
                          controller.menuPhotosList,
                          controller,
                        ),
                        buildMenuItem(
                          themeChange,
                          controller,
                        ),
                        websiteWidget(
                          themeChange,
                          controller,
                        ),
                      ],
                    ),
            ),
          );
        });
  }

  Widget buildMenuItem(themeChange, SeeFullMenuController controller) {
    return controller.itemList.isEmpty
        ? Constant.showEmptyView(message: "Items not found".tr)
        : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: controller.itemList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ItemModel itemModel = controller.itemList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: NetworkImageWidget(
                        imageUrl: itemModel.images!.first,
                        fit: BoxFit.cover,
                        width: Responsive.width(30, context),
                        height: Responsive.width(35, context),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  itemModel.name.toString().tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.boldOpenSans,
                                  ),
                                ),
                              ),
                              Text(
                                "${controller.currency.value.symbol} ${double.parse(itemModel.price.toString()).toStringAsFixed(2)}".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                  fontSize: 16,
                                  fontFamily: AppThemeData.boldOpenSans,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ReadMoreText(
                            itemModel.description.toString().tr,
                            trimLines: 3,
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more'.tr,
                            trimExpandedText: 'Show less'.tr,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.grey03 : AppThemeData.grey03,
                              fontSize: 14,
                              fontFamily: AppThemeData.regularOpenSans,
                            ),
                            moreStyle: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.red02 : AppThemeData.red02,
                              fontSize: 14,
                              fontFamily: AppThemeData.boldOpenSans,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }

  Widget buildMenuPhotoGrid(themeChange, List<PhotoModel> images, SeeFullMenuController controller) {
    return images.isEmpty
        ? Constant.showEmptyView(message: "Menu Image not found")
        : GridView.builder(
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              PhotoModel uploadMenuModel = images[index];
              return InkWell(
                onTap: () {
                  Get.to(PhotoViewScreen(), arguments: {"photoList": images, "index": index})!.then(
                    (value) {
                      controller.getMenuImage();
                    },
                  );
                },
                child: Stack(
                  children: [
                    NetworkImageWidget(
                      imageUrl: uploadMenuModel.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: InkWell(
                        onTap: () {
                          if (uploadMenuModel.likedBy!.contains(FireStoreUtils.getCurrentUid())) {
                            uploadMenuModel.likedBy!.remove(FireStoreUtils.getCurrentUid());
                          } else {
                            uploadMenuModel.likedBy!.add(FireStoreUtils.getCurrentUid());
                          }
                          FireStoreUtils.addPhotos(uploadMenuModel);
                          controller.updateMenuPhoto(index, uploadMenuModel);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: uploadMenuModel.likedBy!.contains(FireStoreUtils.getCurrentUid())
                                ? AppThemeData.red02
                                : themeChange.getThem()
                                    ? AppThemeData.greyDark10
                                    : AppThemeData.grey10,
                            shape: BoxShape.circle,
                          ),
                          child: Constant.svgPictureShow(
                            "assets/icons/icon_thumbs-up.svg",
                            uploadMenuModel.likedBy!.contains(FireStoreUtils.getCurrentUid())
                                ? AppThemeData.grey10
                                : themeChange.getThem()
                                    ? AppThemeData.greyDark02
                                    : AppThemeData.grey02,
                            20,
                            20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  Widget websiteWidget(themeChange, SeeFullMenuController controller) {
    return controller.businessModel.value.website!.isNotEmpty
        ? WebViewWidget(controller: controller.controller.value)
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NetworkImageWidget(
                imageUrl: controller.menuPhotosList.isEmpty ? '' : controller.menuPhotosList.first.imageUrl.toString(),
                fit: BoxFit.cover,
                width: Responsive.width(100, Get.context!),
                height: Responsive.width(55, Get.context!),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Location".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                        fontSize: 16,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Constant.svgPictureShow('assets/icons/icon_map-distance.svg', null, 24, 24),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${controller.businessModel.value.address!.formattedAddress}".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                            fontSize: 14,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Contact us".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                        fontSize: 16,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        ClipOval(
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Constant.svgPictureShow('assets/icons/icon_phone-call.svg', null, 24, 24),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${controller.businessModel.value.countryCode} ${controller.businessModel.value.phoneNumber}".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                            fontSize: 14,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Hours".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                              fontSize: 16,
                              fontFamily: AppThemeData.boldOpenSans,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            seeHoursFilterBottomSheet(themeChange, controller);
                          },
                          child: Text(
                            "More".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.teal02 : AppThemeData.teal02,
                              fontSize: 14,
                              fontFamily: AppThemeData.boldOpenSans,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    buildStatusText(themeChange, Constant.getBusinessStatus(controller.businessModel.value.businessHours!)),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      Constant.getTodaySingleTimeSlot(controller.businessModel.value.businessHours!).tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                        fontSize: 14,
                        fontFamily: AppThemeData.semiboldOpenSans,
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
  }

  static Widget buildStatusText(themeChange, String status) {
    TextStyle defaultStyle = TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02, fontFamily: AppThemeData.semiboldOpenSans);
    TextStyle openStyle = TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.greenDark02 : AppThemeData.green02, fontFamily: AppThemeData.boldOpenSans);
    TextStyle closedStyle = TextStyle(fontSize: 14, color: themeChange.getThem() ? AppThemeData.greenDark02 : AppThemeData.red02, fontFamily: AppThemeData.boldOpenSans);

    if (status.startsWith("Open until")) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Open", style: openStyle),
            TextSpan(text: " until ${status.replaceFirst("Open until", "").trim()}", style: defaultStyle),
          ],
        ),
      );
    } else if (status.startsWith("Closed until")) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Closed", style: closedStyle),
            TextSpan(text: " until ${status.replaceFirst("Closed until", "").trim()}", style: defaultStyle),
          ],
        ),
      );
    } else if (status == "Closed") {
      return RichText(
        text: TextSpan(
          text: "Closed",
          style: closedStyle,
        ),
      );
    } else {
      return Text(status, style: defaultStyle);
    }
  }

  void seeHoursFilterBottomSheet(themeChange, SeeFullMenuController controller) {
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
                          "Hours",
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
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: controller.days.length,
                      itemBuilder: (context, index) {
                        final day = controller.days[index];
                        final isToday = day == DateFormat('EEEE').format(DateTime.now());
                        final slots = Constant.getFormattedSlots(Constant.getDayHours(controller.businessModel.value.businessHours!, day));

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                    fontSize: 16,
                                    fontFamily: isToday ? AppThemeData.boldOpenSans : AppThemeData.mediumOpenSans,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: slots
                                    .map((slot) => Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Text(
                                            slot,
                                            style: TextStyle(
                                              color: slot == "Closed"
                                                  ? AppThemeData.red02
                                                  : themeChange.getThem()
                                                      ? AppThemeData.greyDark01
                                                      : AppThemeData.grey01,
                                              fontSize: 14,
                                              fontFamily: isToday ? AppThemeData.boldOpenSans : AppThemeData.regularOpenSans,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
