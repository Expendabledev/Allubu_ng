import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/collection_details_screen/collection_details_screen.dart';
import 'package:allubmarket/app/collection_screen/collection_view_screen.dart';
import 'package:allubmarket/app/collection_screen/create_collection_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/collection_controller.dart';
import 'package:allubmarket/models/bookmarks_model.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/service/ad_manager.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/network_image_widget.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CollectionController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark08
                      : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Get.to(CreateCollectionScreen())!.then(
                      (value) {
                        print("=====>$value");
                        if (value == true) {
                          controller.getMyCollection();
                        }
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Create".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.tealDark02
                            : AppThemeData.teal02,
                        fontSize: 14,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                  ),
                )
              ],
              title: Text(
                "Collection".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark01
                      : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AdManager.bannerAdWidget(),
                        ),
                        Text(
                          "My Collections".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark02
                                : AppThemeData.grey02,
                            fontSize: 16,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: Responsive.height(24, context),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.bookmarksList.length + 1,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (controller.bookmarksList.length == index) {
                                return InkWell(
                                  onTap: () {
                                    Get.to(CreateCollectionScreen())!.then(
                                      (value) {
                                        print("=====>$value");
                                        if (value == true) {
                                          controller.getMyCollection();
                                        }
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: Responsive.height(18, context),
                                          height:
                                              Responsive.height(18, context),
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
                                            padding: const EdgeInsets.all(30),
                                            child: SvgPicture.asset(
                                                "assets/icons/noun-add-bookmark.svg"),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: Responsive.height(18, context),
                                          child: Text(
                                            "Create New".tr,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: themeChange.getThem()
                                                  ? AppThemeData.greyDark02
                                                  : AppThemeData.grey02,
                                              fontSize: 16,
                                              fontFamily:
                                                  AppThemeData.boldOpenSans,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              } else {
                                BookmarksModel bookmarkModel =
                                    controller.bookmarksList[index];
                                return InkWell(
                                  onTap: () {
                                    Get.to(CollectionViewScreen(), arguments: {
                                      "bookmarkModel": bookmarkModel
                                    })!
                                        .then(
                                      (value) {
                                        controller.getMyCollection();
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        bookmarkModel.businessIds!.isEmpty
                                            ? Container(
                                                width: Responsive.height(
                                                    18, context),
                                                height: Responsive.height(
                                                    18, context),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark08
                                                      : AppThemeData.grey08,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: SvgPicture.asset(
                                                      "assets/icons/noun-map-markers.svg"),
                                                ),
                                              )
                                            : FutureBuilder<BusinessModel?>(
                                                future: FireStoreUtils
                                                    .getBusinessByCollection(
                                                        bookmarkModel),
                                                builder: (context, snapshot) {
                                                  BusinessModel? businessModel =
                                                      snapshot.data;
                                                  return businessModel == null
                                                      ? Container(
                                                          width:
                                                              Responsive.height(
                                                                  18, context),
                                                          height:
                                                              Responsive.height(
                                                                  18, context),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .greyDark08
                                                                : AppThemeData
                                                                    .grey08,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  10),
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(20),
                                                            child: SvgPicture.asset(
                                                                "assets/icons/noun-map-markers.svg"),
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          child:
                                                              NetworkImageWidget(
                                                            imageUrl:
                                                                businessModel
                                                                    .coverPhoto
                                                                    .toString(),
                                                            width: Responsive
                                                                .height(18,
                                                                    context),
                                                            height: Responsive
                                                                .height(18,
                                                                    context),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        );
                                                },
                                              ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: Responsive.height(18, context),
                                          child: Text(
                                            "${bookmarkModel.name}".tr,
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              color: themeChange.getThem()
                                                  ? AppThemeData.greyDark02
                                                  : AppThemeData.grey02,
                                              fontSize: 16,
                                              fontFamily:
                                                  AppThemeData.boldOpenSans,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          (bookmarkModel.isPrivate == true
                                                  ? "Not Public"
                                                  : "Public")
                                              .tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.greyDark02
                                                : AppThemeData.grey02,
                                            fontSize: 12,
                                            fontFamily:
                                                AppThemeData.regularOpenSans,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Following Collection".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark02
                                : AppThemeData.grey02,
                            fontSize: 16,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: Responsive.height(24, context),
                          child: controller.followingBookmarksList.isEmpty
                              ? Constant.showEmptyView(
                                  message:
                                      "You aren’t following any collection yet. Discover some great collection above!"
                                          .tr)
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      controller.followingBookmarksList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    BookmarksModel bookmarkModel = controller
                                        .followingBookmarksList[index];
                                    return InkWell(
                                      onTap: () {
                                        Get.to(CollectionDetailsScreen(),
                                                arguments: {
                                              "bookmarkModel": bookmarkModel
                                            })!
                                            .then(
                                          (value) {
                                            controller.getMyCollection();
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            bookmarkModel.businessIds!.isEmpty
                                                ? Container(
                                                    width: Responsive.height(
                                                        18, context),
                                                    height: Responsive.height(
                                                        18, context),
                                                    padding: EdgeInsets.all(10),
                                                    decoration: BoxDecoration(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark08
                                                          : AppThemeData.grey08,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              20),
                                                      child: SvgPicture.asset(
                                                          "assets/icons/noun-map-markers.svg"),
                                                    ),
                                                  )
                                                : FutureBuilder<BusinessModel?>(
                                                    future: FireStoreUtils
                                                        .getBusinessByCollection(
                                                            bookmarkModel),
                                                    builder:
                                                        (context, snapshot) {
                                                      BusinessModel?
                                                          businessModel =
                                                          snapshot.data;
                                                      return businessModel ==
                                                              null
                                                          ? Container(
                                                              width: Responsive
                                                                  .height(18,
                                                                      context),
                                                              height: Responsive
                                                                  .height(18,
                                                                      context),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: themeChange.getThem()
                                                                    ? AppThemeData
                                                                        .greyDark08
                                                                    : AppThemeData
                                                                        .grey08,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          10),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        20),
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/icons/noun-map-markers.svg"),
                                                              ),
                                                            )
                                                          : ClipRRect(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                              child:
                                                                  NetworkImageWidget(
                                                                imageUrl: businessModel
                                                                    .coverPhoto
                                                                    .toString(),
                                                                width: Responsive
                                                                    .height(18,
                                                                        context),
                                                                height: Responsive
                                                                    .height(18,
                                                                        context),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            );
                                                    },
                                                  ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              width: Responsive.height(
                                                  19, context),
                                              child: Text(
                                                "${bookmarkModel.name}".tr,
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.greyDark02
                                                      : AppThemeData.grey02,
                                                  fontSize: 16,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontFamily:
                                                      AppThemeData.boldOpenSans,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              (bookmarkModel.isPrivate == true
                                                      ? "Not Public"
                                                      : "Public")
                                                  .tr,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.greyDark02
                                                    : AppThemeData.grey02,
                                                fontSize: 12,
                                                fontFamily: AppThemeData
                                                    .regularOpenSans,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        )
                      ],
                    ),
                  ),
          );
        });
  }
}
