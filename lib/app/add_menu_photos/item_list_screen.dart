import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/add_menu_photos/add_item_manually_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/add_menu_photo_controller.dart';
import 'package:allubmarket/models/item_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/widgets/readmore.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: AddMenuPhotoController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
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
                          themeChange.getThem()
                              ? AppThemeData.greyDark06
                              : AppThemeData.grey01,
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
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
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
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark08
                      : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              title: Text(
                "Items".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark01
                      : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Get.to(AddItemManuallyScreen(), arguments: {
                      "businessModel": controller.businessModel.value
                    })?.then(
                      (value) {
                        if (value == true) {
                          controller.getItemList();
                        }
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Add Another".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.tealDark02
                            : AppThemeData.teal02,
                        fontSize: 14,
                        fontFamily: AppThemeData.semiboldOpenSans,
                      ),
                    ),
                  ),
                )
              ],
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : controller.itemList.isEmpty
                    ? Constant.showEmptyView(message: "Item is empty".tr)
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: ListView.separated(
                          itemCount: controller.itemList.length,
                          itemBuilder: (context, index) {
                            ItemModel itemModel = controller.itemList[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: NetworkImageWidget(
                                    imageUrl: itemModel.images!.isEmpty
                                        ? ''
                                        : itemModel.images!.first.toString(),
                                    height: Responsive.height(12, context),
                                    width: Responsive.width(24, context),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        itemModel.name.toString().tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark01
                                              : AppThemeData.grey01,
                                          fontSize: 16,
                                          fontFamily: AppThemeData.boldOpenSans,
                                        ),
                                      ),
                                      Text(
                                        "${controller.currency.value.symbol} ${double.parse(itemModel.price.toString()).toStringAsFixed(2)}"
                                            .tr,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark02
                                              : AppThemeData.grey02,
                                          fontSize: 16,
                                          fontFamily:
                                              AppThemeData.semiboldOpenSans,
                                        ),
                                      ),
                                      ReadMoreText(
                                        itemModel.description.toString().tr,
                                        trimLines: 3,
                                        colorClickableText: Colors.pink,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: 'Show more'.tr,
                                        trimExpandedText: 'Show less'.tr,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey03
                                              : AppThemeData.grey03,
                                          fontSize: 14,
                                          fontFamily:
                                              AppThemeData.regularOpenSans,
                                        ),
                                        moreStyle: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.red02
                                              : AppThemeData.red02,
                                          fontSize: 14,
                                          fontFamily: AppThemeData.boldOpenSans,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                    onTap: () {
                                      Get.to(AddItemManuallyScreen(),
                                          arguments: {
                                            "businessModel":
                                                controller.businessModel.value,
                                            "itemModel": itemModel,
                                          })?.then(
                                        (value) {
                                          if (value == true) {
                                            controller.getItemList();
                                          }
                                        },
                                      );
                                    },
                                    child: Constant.svgPictureShow(
                                        'assets/icons/edit.svg',
                                        themeChange.getThem()
                                            ? AppThemeData.teal02
                                            : AppThemeData.teal02,
                                        20,
                                        20)),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                    onTap: () async {
                                      ShowToastDialog.showLoader(
                                          "Please wait".tr);
                                      await FireStoreUtils.deleteItem(
                                          controller.businessModel.value.id
                                              .toString(),
                                          itemModel);
                                      controller.getItemList();
                                      ShowToastDialog.closeLoader();
                                      ShowToastDialog.showToast(
                                          "Item Deleted".tr);
                                    },
                                    child: Constant.svgPictureShow(
                                        'assets/icons/delete.svg',
                                        themeChange.getThem()
                                            ? AppThemeData.red02
                                            : AppThemeData.red02,
                                        20,
                                        20)),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Divider(),
                            );
                          },
                        ),
                      ),
          );
        });
  }
}
