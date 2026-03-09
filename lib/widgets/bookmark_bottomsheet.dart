import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/collection_screen/create_collection_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/bookmark_bottomsheet_controller.dart';
import 'package:allubmarket/models/bookmarks_model.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/round_button_border.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class BookMarkBottomSheet extends StatelessWidget {
  final BusinessModel businessModel;

  const BookMarkBottomSheet({super.key, required this.businessModel});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      // 60% of screen height
      minChildSize: 0.4,
      // Minimum height
      maxChildSize: 0.9,
      // Maximum height
      expand: false,
      builder: (context, scrollController) {
        return GetX(
            init: BookmarkBottomSheetController(),
            builder: (controller) {
              return Container(
                color: themeChange.getThem()
                    ? AppThemeData.grey02
                    : AppThemeData.greyDark02,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: controller.isLoading.value
                      ? Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Constant.loader(),
                        )
                      : SizedBox(
                          width: Responsive.width(100, context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Save to Collection".tr,
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark02
                                        : AppThemeData.grey02,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.boldOpenSans,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RoundedButtonBorder(
                                  icon: SvgPicture.asset(
                                      "assets/icons/icon_plus.svg"),
                                  title: 'New Collection'.tr,
                                  isRight: false,
                                  isCenter: true,
                                  textColor: themeChange.getThem()
                                      ? AppThemeData.red02
                                      : AppThemeData.red02,
                                  color: themeChange.getThem()
                                      ? AppThemeData.greyDark10
                                      : AppThemeData.grey10,
                                  borderColor: themeChange.getThem()
                                      ? AppThemeData.greyDark06
                                      : AppThemeData.grey06,
                                  onPress: () {
                                    Get.to(CreateCollectionScreen())!.then(
                                      (value) {
                                        if (value == true) {
                                          controller.getMyCollection();
                                        }
                                      },
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ListView.separated(
                                  itemCount: controller.bookmarksList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    BookmarksModel bookmarkModel =
                                        controller.bookmarksList[index];
                                    return InkWell(
                                      onTap: () async {
                                        ShowToastDialog.showLoader(
                                            "Please wait");
                                        if (bookmarkModel.businessIds!.contains(
                                            businessModel.id.toString())) {
                                          bookmarkModel.businessIds!.remove(
                                              businessModel.id.toString());
                                          ShowToastDialog.showToast(
                                              "${'Removed From'.tr} ${bookmarkModel.name}");
                                          await FireStoreUtils.createBookmarks(
                                              bookmarkModel);
                                        } else {
                                          bookmarkModel.businessIds!
                                              .add(businessModel.id.toString());
                                          ShowToastDialog.showToast(
                                              "${'Saved to'.tr} ${bookmarkModel.name}");
                                          await FireStoreUtils.createBookmarks(
                                              bookmarkModel);
                                        }

                                        if (businessModel.bookmarkUserId!
                                            .contains(FireStoreUtils
                                                .getCurrentUid())) {
                                          if (controller.bookmarksList
                                              .where((p0) => p0.businessIds!
                                                  .contains(businessModel.id
                                                      .toString()))
                                              .isEmpty) {
                                            businessModel.bookmarkUserId!
                                                .remove(FireStoreUtils
                                                    .getCurrentUid());
                                          }
                                        } else {
                                          businessModel.bookmarkUserId!.add(
                                              FireStoreUtils.getCurrentUid());
                                        }
                                        await FireStoreUtils.addBusiness(
                                            businessModel);

                                        Get.back(result: true);
                                      },
                                      child: Row(
                                        children: [
                                          Container(
                                            width:
                                                Responsive.height(6, context),
                                            height:
                                                Responsive.height(6, context),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.greyDark08
                                                  : AppThemeData.grey08,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: SvgPicture.asset(
                                                  "assets/icons/noun-map-markers.svg"),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  bookmarkModel.name
                                                      .toString()
                                                      .tr,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      bookmarkModel.isPrivate ==
                                                              true
                                                          ? "Privet"
                                                          : "Public".tr,
                                                      style: TextStyle(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .greyDark01
                                                            : AppThemeData
                                                                .grey01,
                                                        fontSize: 12,
                                                        fontFamily: AppThemeData
                                                            .regularOpenSans,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      child: Icon(
                                                        Icons.circle,
                                                        size: 5,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${bookmarkModel.businessIds!.length} Places"
                                                          .tr,
                                                      style: TextStyle(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .greyDark01
                                                            : AppThemeData
                                                                .grey01,
                                                        fontSize: 12,
                                                        fontFamily: AppThemeData
                                                            .regularOpenSans,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          bookmarkModel.businessIds!.contains(
                                                  businessModel.id.toString())
                                              ? Text(
                                                  "Remove".tr,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.red02
                                                        : AppThemeData.red02,
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData
                                                        .semiboldOpenSans,
                                                  ),
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Divider(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark07
                                            : AppThemeData.grey07,
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              );
            });
      },
    );
  }
}
