import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/business_details_screen/business_details_screen.dart';
import 'package:allubmarket/app/search_screen/search_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/business_list_controller.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/category_model.dart';
import 'package:allubmarket/models/service_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/widgets/custom_star_rating/custom_star_rating_list_screen.dart';
import 'package:allubmarket/widgets/flutter_sticky_headers/sticky_headers/widget.dart';
import 'package:allubmarket/widgets/debounced_inkwell.dart';

class BusinessListScreen extends StatelessWidget {
  const BusinessListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: BusinessListController(),
      builder: (controller) {
        return Scaffold(
          body: controller.isLoading.value
              ? Constant.loader()
              : Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: controller.onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: controller.currentPosition.value,
                        zoom: 14,
                      ),
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      myLocationButtonEnabled: false,
                      markers:
                          controller.markers.toSet(), // reactive marker set
                    ),
                    Positioned(
                      top: 120, // change this to move button
                      right: 16,
                      child: FloatingActionButton(
                        backgroundColor: AppThemeData.greyDark01,
                        mini: true,
                        onPressed: () async {
                          final GoogleMapController mapController =
                              controller.mapController;
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: controller.currentPosition.value,
                                zoom: 14,
                              ),
                            ),
                          );
                        },
                        child:
                            Icon(Icons.my_location, color: AppThemeData.grey01),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).viewPadding.top + 10,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark10
                              : AppThemeData.grey10,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark06
                                : AppThemeData.grey06,
                          ),
                        ),
                        child: Row(
                          children: [
                            DebouncedInkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(
                                  "assets/icons/icon_left.svg",
                                  colorFilter: ColorFilter.mode(
                                      themeChange.getThem()
                                          ? AppThemeData.greyDark01
                                          : AppThemeData.grey01,
                                      BlendMode.srcIn),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: DebouncedInkWell(
                                onTap: () {
                                  Get.to(SearchScreen(), arguments: {
                                    "categoryModel":
                                        controller.selectedCategory.value,
                                    "latLng": controller.currentPosition.value,
                                    "isZipCode": controller.isZipCode.value,
                                  })!
                                      .then(
                                    (value) {
                                      controller.getArgument();
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "${controller.selectedCategory.value.name}"
                                          .tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01,
                                        fontSize: 14,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text(
                                        controller.address.value.tr,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: themeChange.getThem()
                                              ? AppThemeData.greyDark03
                                              : AppThemeData.grey03,
                                          fontSize: 14,
                                          fontFamily:
                                              AppThemeData.regularOpenSans,
                                        ),
                                      ),
                                    ),
                                    Constant.svgPictureShow(
                                        "assets/icons/list-two.svg",
                                        null,
                                        null,
                                        null)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // ✅ Draggable Bottom Sheet
                    Positioned.fill(
                      child: DraggableScrollableSheet(
                        initialChildSize: 0.3,
                        // Start height
                        minChildSize: 0.30,
                        // Minimum height
                        maxChildSize: 0.8,
                        // Maximum height
                        expand: false,
                        // ✅ Prevents full-screen takeover
                        builder: (context, scrollController) {
                          return Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.surfaceDark50
                                  : AppThemeData.surface50,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16)),
                            ),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              controller: scrollController,
                              shrinkWrap: true,
                              children: [
                                StickyHeader(
                                  header: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 20),
                                    color: themeChange.getThem()
                                        ? AppThemeData.surfaceDark50
                                        : AppThemeData.surface50,
                                    child: SizedBox(
                                      height: 40,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          DebouncedInkWell(
                                            onTap: () {
                                              moreFilterBottomSheet(
                                                  themeChange, controller);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                  border: Border.all(
                                                      color:
                                                          themeChange.getThem()
                                                              ? AppThemeData
                                                                  .greyDark05
                                                              : AppThemeData
                                                                  .grey05)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Constant.svgPictureShow(
                                                    "assets/icons/ic_filter.svg",
                                                    themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    null,
                                                    null),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          DebouncedInkWell(
                                            onTap: () {
                                              sortFilterBottomSheet(
                                                  themeChange, controller);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: controller
                                                          .selectedSortOption
                                                          .value
                                                          .isEmpty
                                                      ? Colors.transparent
                                                      : AppThemeData.green02,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                  border: Border.all(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark05
                                                          : AppThemeData
                                                              .grey05)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      controller
                                                              .selectedSortOption
                                                              .value
                                                              .isEmpty
                                                          ? "Sort"
                                                          : 'sort_by'.trParams({
                                                              'sort': Constant
                                                                  .capitalizeFirst(
                                                                      controller
                                                                          .selectedSortOption
                                                                          .value),
                                                            }).tr,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: controller
                                                                .selectedSortOption
                                                                .value
                                                                .isNotEmpty
                                                            ? AppThemeData
                                                                .grey10
                                                            : themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .greyDark01
                                                                : AppThemeData
                                                                    .grey01,
                                                        fontSize: 12,
                                                        fontFamily: AppThemeData
                                                            .mediumOpenSans,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Constant.svgPictureShow(
                                                        "assets/icons/icon_down.svg",
                                                        controller
                                                                .selectedSortOption
                                                                .value
                                                                .isNotEmpty
                                                            ? AppThemeData
                                                                .grey10
                                                            : themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .greyDark01
                                                                : AppThemeData
                                                                    .grey01,
                                                        null,
                                                        null),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          DebouncedInkWell(
                                            onTap: () {
                                              if (controller
                                                  .isOpenBusiness.value) {
                                                controller.isOpenBusiness
                                                    .value = false;
                                              } else {
                                                controller.isOpenBusiness
                                                    .value = true;
                                              }
                                              controller.getAllFilteredLists();
                                            },
                                            child: Obx(
                                              () => Container(
                                                decoration: BoxDecoration(
                                                    color: controller
                                                            .isOpenBusiness
                                                            .value
                                                        ? AppThemeData.green02
                                                        : Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius
                                                                .circular(30)),
                                                    border: Border.all(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .greyDark05
                                                            : AppThemeData
                                                                .grey05)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 10),
                                                  child: Text(
                                                    "Open Now".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: controller
                                                              .isOpenBusiness
                                                              .value
                                                          ? AppThemeData.grey10
                                                          : themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .greyDark01
                                                              : AppThemeData
                                                                  .grey01,
                                                      fontSize: 12,
                                                      fontFamily: AppThemeData
                                                          .mediumOpenSans,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          DebouncedInkWell(
                                            onTap: () {
                                              moreFilterBottomSheet(
                                                  themeChange, controller);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                  border: Border.all(
                                                      color:
                                                          themeChange.getThem()
                                                              ? AppThemeData
                                                                  .greyDark05
                                                              : AppThemeData
                                                                  .grey05)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 10),
                                                child: Text(
                                                  "More Filter".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData
                                                            .greyDark01
                                                        : AppThemeData.grey01,
                                                    fontSize: 12,
                                                    fontFamily: AppThemeData
                                                        .mediumOpenSans,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  content: Obx(
                                    () => Column(
                                      children: [
                                        controller.subCategoryList.isEmpty
                                            ? SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 10),
                                                child: SizedBox(
                                                  height: 100,
                                                  child: ListView.builder(
                                                    itemCount: controller
                                                        .subCategoryList.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    padding: EdgeInsets.zero,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      CategoryModel category =
                                                          controller
                                                                  .subCategoryList[
                                                              index];
                                                      return DebouncedInkWell(
                                                        onTap: () {
                                                          if (controller
                                                                  .selectedCategory
                                                                  .value
                                                                  .slug ==
                                                              category.slug) {
                                                            controller
                                                                    .selectedCategory
                                                                    .value =
                                                                controller
                                                                    .categoryModel
                                                                    .value;
                                                          } else {
                                                            controller
                                                                .selectedCategory
                                                                .value = category;
                                                          }

                                                          controller
                                                              .getBusiness();
                                                        },
                                                        child: SizedBox(
                                                          width: 100,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    color: controller.selectedCategory.value.slug == category.slug ? AppThemeData.teal03 : Colors.transparent,
                                                                    borderRadius: BorderRadius.all(Radius.circular(40)),
                                                                    border: Border.all(
                                                                        color: controller.selectedCategory.value.slug == category.slug
                                                                            ? AppThemeData.teal02
                                                                            : themeChange.getThem()
                                                                                ? AppThemeData.greyDark01
                                                                                : AppThemeData.grey01)),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8),
                                                                  child:
                                                                      NetworkImageWidget(
                                                                    imageUrl:
                                                                        category
                                                                            .icon
                                                                            .toString(),
                                                                    width: 30,
                                                                    height: 30,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 4),
                                                              Text(
                                                                category.name
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                maxLines: 2,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 12,
                                                                  color: controller
                                                                              .selectedCategory
                                                                              .value
                                                                              .slug ==
                                                                          category
                                                                              .slug
                                                                      ? AppThemeData
                                                                          .teal02
                                                                      : themeChange
                                                                              .getThem()
                                                                          ? AppThemeData
                                                                              .greyDark01
                                                                          : AppThemeData
                                                                              .grey01,
                                                                  fontFamily:
                                                                      AppThemeData
                                                                          .medium,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                        Obx(
                                          () =>
                                              controller.sponsoredBusinessList
                                                          .isEmpty &&
                                                      controller
                                                          .filteredBusinessList
                                                          .isEmpty
                                                  ? emptyView(
                                                      themeChange,
                                                      scrollController,
                                                      controller)
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        controller
                                                                .sponsoredBusinessList
                                                                .isEmpty
                                                            ? SizedBox()
                                                            : Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    child: Text(
                                                                      "Sponsored Result"
                                                                          .tr,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: themeChange.getThem()
                                                                            ? AppThemeData.greyDark01
                                                                            : AppThemeData.grey01,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            AppThemeData.boldOpenSans,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            10),
                                                                    child:
                                                                        Divider(),
                                                                  ),
                                                                  ListView
                                                                      .builder(
                                                                    itemCount: controller
                                                                        .sponsoredBusinessList
                                                                        .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      BusinessModel
                                                                          businessModel =
                                                                          controller
                                                                              .sponsoredBusinessList[index];
                                                                      return DebouncedInkWell(
                                                                        onTap:
                                                                            () {
                                                                          Constant.setRecentBusiness(
                                                                              businessModel);
                                                                          Get.to(
                                                                              BusinessDetailsScreen(),
                                                                              arguments: {
                                                                                "businessModel": businessModel,
                                                                                "categoryModel": controller.selectedCategory.value
                                                                              });
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 10),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                    child: NetworkImageWidget(
                                                                                      imageUrl: businessModel.coverPhoto.toString(),
                                                                                      width: Responsive.width(32, context),
                                                                                      height: Responsive.height(14, context),
                                                                                      fit: BoxFit.cover,
                                                                                      errorWidget: Constant.svgPictureShow("assets/icons/ic_placeholder_bussiness.svg", null, 50, 50),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "${businessModel.businessName}".tr,
                                                                                          textAlign: TextAlign.start,
                                                                                          style: TextStyle(
                                                                                            color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                                                                                            fontSize: 16,
                                                                                            fontFamily: AppThemeData.boldOpenSans,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        CustomStarRatingList(
                                                                                          initialRating: Constant.calculateReview(reviewCount: businessModel.reviewCount, reviewSum: businessModel.reviewSum),
                                                                                          size: 20,
                                                                                          enable: false,
                                                                                          bgColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                                                                                          emptyColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              Constant.calculateReview(reviewCount: businessModel.reviewCount, reviewSum: businessModel.reviewSum).tr,
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                                                                                                fontSize: 14,
                                                                                                fontFamily: AppThemeData.semiboldOpenSans,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Text(
                                                                                              "(${double.parse(businessModel.reviewCount.toString()).toStringAsFixed(0)} reviews)",
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                                                                                                fontSize: 14,
                                                                                                fontFamily: AppThemeData.semiboldOpenSans,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Constant.svgPictureShow(
                                                                                              "assets/icons/icon_local-two.svg",
                                                                                              themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                                                              16,
                                                                                              16,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                businessModel.address!.formattedAddress.toString(),
                                                                                                textAlign: TextAlign.start,
                                                                                                style: TextStyle(
                                                                                                  color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                                                                                                  fontSize: 12,
                                                                                                  fontFamily: AppThemeData.semiboldOpenSans,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        businessModel.businessHours == null || businessModel.showWorkingHours == false
                                                                                            ? SizedBox()
                                                                                            : Padding(
                                                                                                padding: const EdgeInsets.only(top: 5),
                                                                                                child: Constant.buildStatusText(themeChange, Constant.getBusinessStatus(businessModel.businessHours!), true),
                                                                                              ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Wrap(
                                                                                spacing: 8,
                                                                                runSpacing: 8,
                                                                                children: businessModel.category!.map((category) => categoryChip(themeChange, category)).toList(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                        controller
                                                                .filteredBusinessList
                                                                .isEmpty
                                                            ? SizedBox()
                                                            : Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    child: Text(
                                                                      "All Result"
                                                                          .tr,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style:
                                                                          TextStyle(
                                                                        color: themeChange.getThem()
                                                                            ? AppThemeData.greyDark01
                                                                            : AppThemeData.grey01,
                                                                        fontSize:
                                                                            16,
                                                                        fontFamily:
                                                                            AppThemeData.boldOpenSans,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            10),
                                                                    child:
                                                                        Divider(),
                                                                  ),
                                                                  ListView
                                                                      .builder(
                                                                    itemCount: controller
                                                                        .filteredBusinessList
                                                                        .length,
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            16),
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      BusinessModel
                                                                          businessModel =
                                                                          controller
                                                                              .filteredBusinessList[index];
                                                                      return DebouncedInkWell(
                                                                        onTap:
                                                                            () {
                                                                          Constant.setRecentBusiness(
                                                                              businessModel);
                                                                          Get.to(
                                                                              BusinessDetailsScreen(),
                                                                              arguments: {
                                                                                "businessModel": businessModel,
                                                                                "categoryModel": controller.selectedCategory.value
                                                                              });
                                                                        },
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 10),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  ClipRRect(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                                                    child: NetworkImageWidget(
                                                                                      imageUrl: businessModel.coverPhoto.toString(),
                                                                                      width: Responsive.width(32, context),
                                                                                      height: Responsive.height(14, context),
                                                                                      fit: BoxFit.cover,
                                                                                      errorWidget: Constant.svgPictureShow("assets/icons/ic_placeholder_bussiness.svg", null, 50, 50),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 10,
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "${index + 1}. ${businessModel.businessName}".tr,
                                                                                          textAlign: TextAlign.start,
                                                                                          style: TextStyle(
                                                                                            color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                                                                                            fontSize: 16,
                                                                                            fontFamily: AppThemeData.boldOpenSans,
                                                                                          ),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        CustomStarRatingList(
                                                                                          initialRating: Constant.calculateReview(reviewCount: businessModel.reviewCount, reviewSum: businessModel.reviewSum),
                                                                                          size: 20,
                                                                                          enable: false,
                                                                                          bgColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                                                                                          emptyColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              Constant.calculateReview(reviewCount: businessModel.reviewCount, reviewSum: businessModel.reviewSum).tr,
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                                                                                                fontSize: 14,
                                                                                                fontFamily: AppThemeData.semiboldOpenSans,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 10,
                                                                                            ),
                                                                                            Text(
                                                                                              "(${double.parse(businessModel.reviewCount.toString()).toStringAsFixed(0)} reviews)",
                                                                                              textAlign: TextAlign.start,
                                                                                              style: TextStyle(
                                                                                                color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                                                                                                fontSize: 14,
                                                                                                fontFamily: AppThemeData.semiboldOpenSans,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 5,
                                                                                        ),
                                                                                        Row(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Constant.svgPictureShow(
                                                                                              "assets/icons/icon_local-two.svg",
                                                                                              themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                                                              16,
                                                                                              16,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: Text(
                                                                                                businessModel.address!.formattedAddress.toString(),
                                                                                                textAlign: TextAlign.start,
                                                                                                style: TextStyle(
                                                                                                  color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                                                                                                  fontSize: 12,
                                                                                                  fontFamily: AppThemeData.semiboldOpenSans,
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        businessModel.businessHours == null || businessModel.showWorkingHours == false
                                                                                            ? SizedBox()
                                                                                            : Padding(
                                                                                                padding: const EdgeInsets.only(top: 5),
                                                                                                child: Constant.buildStatusText(themeChange, Constant.getBusinessStatus(businessModel.businessHours!), true),
                                                                                              ),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              Wrap(
                                                                                spacing: 8,
                                                                                runSpacing: 8,
                                                                                children: businessModel.category!.map((category) => categoryChip(themeChange, category)).toList(),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                      ],
                                                    ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void sortFilterBottomSheet(themeChange, BusinessListController controller) {
    Get.bottomSheet(
      Container(
        height: Responsive.height(32, Get.context!),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: themeChange.getThem()
              ? AppThemeData.surfaceDark50
              : AppThemeData.surface50,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Sort".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark01
                            : AppThemeData.grey01,
                        fontSize: 18,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                  ),
                  DebouncedInkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset(
                      "assets/icons/icon_close.svg",
                      colorFilter: ColorFilter.mode(
                        themeChange.getThem()
                            ? AppThemeData.greyDark06
                            : AppThemeData.grey01,
                        BlendMode.srcIn,
                      ),
                      width: 22,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              RadioListTile<String>(
                title: Text(
                  'Recommended'.tr,
                  style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark01
                        : AppThemeData.grey01,
                    fontSize: 16,
                    fontFamily: AppThemeData.mediumOpenSans,
                  ),
                ),
                value: 'recommended',
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
                dense: true,
                groupValue: controller.selectedSortOption.value,
                onChanged: (value) {
                  controller.selectedSortOption.value = value ?? '';
                  Get.back();
                  controller.getAllFilteredLists();
                },
              ),
              RadioListTile<String>(
                title: Text(
                  'Distance'.tr,
                  style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark01
                        : AppThemeData.grey01,
                    fontSize: 16,
                    fontFamily: AppThemeData.mediumOpenSans,
                  ),
                ),
                value: 'distance',
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
                dense: true,
                groupValue: controller.selectedSortOption.value,
                onChanged: (value) {
                  controller.selectedSortOption.value = value ?? '';
                  Get.back();
                  controller.getAllFilteredLists();
                },
              ),
              RadioListTile<String>(
                title: Text(
                  'Rating'.tr,
                  style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark01
                        : AppThemeData.grey01,
                    fontSize: 16,
                    fontFamily: AppThemeData.mediumOpenSans,
                  ),
                ),
                value: 'rating',
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
                dense: true,
                groupValue: controller.selectedSortOption.value,
                onChanged: (value) {
                  controller.selectedSortOption.value = value ?? '';
                  Get.back();
                  controller.getAllFilteredLists();
                },
              ),
              RadioListTile<String>(
                title: Text(
                  'Reviewed'.tr,
                  style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark01
                        : AppThemeData.grey01,
                    fontSize: 16,
                    fontFamily: AppThemeData.mediumOpenSans,
                  ),
                ),
                value: 'reviewed',
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
                dense: true,
                groupValue: controller.selectedSortOption.value,
                onChanged: (value) {
                  controller.selectedSortOption.value = value ?? '';
                  Get.back();
                  controller.getAllFilteredLists();
                },
              )
            ],
          ),
        ),
      ),
      isScrollControlled: true, // Allows BottomSheet to take full height
    );
  }

  void moreFilterBottomSheet(themeChange, BusinessListController controller) {
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
              color: themeChange.getThem()
                  ? AppThemeData.surfaceDark50
                  : AppThemeData.surface50,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Obx(
              () => Column(
                children: [
                  Row(
                    children: [
                      DebouncedInkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/icon_close.svg",
                              width: 22,
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
                      Expanded(
                        child: Text(
                          "Filters".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                            fontSize: 18,
                            fontFamily: AppThemeData.boldOpenSans,
                          ),
                        ),
                      ),
                      DebouncedInkWell(
                        onTap: () {
                          controller.isOpenBusiness.value = false;
                          controller.selectedSortOption.value = '';
                          controller.selectedOptionsByServiceId.clear();
                        },
                        child: Text(
                          "Reset".tr,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.teal02
                                : AppThemeData.teal02,
                            fontSize: 16,
                            fontFamily: AppThemeData.boldOpenSans,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sort".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: themeChange.getThem()
                                  ? AppThemeData.greyDark01
                                  : AppThemeData.grey01,
                              fontSize: 18,
                              fontFamily: AppThemeData.boldOpenSans,
                            ),
                          ),
                          Column(
                            children: [
                              RadioListTile<String>(
                                title: Text(
                                  'Recommended',
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark01
                                        : AppThemeData.grey01,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.mediumOpenSans,
                                  ),
                                ),
                                value: 'recommended',
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                groupValue: controller.selectedSortOption.value,
                                visualDensity: VisualDensity.compact,
                                // Reduces vertical & horizontal space

                                onChanged: (value) {
                                  controller.selectedSortOption.value =
                                      value ?? '';
                                  controller.getAllFilteredLists();
                                },
                              ),
                              RadioListTile<String>(
                                title: Text(
                                  'Distance',
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark01
                                        : AppThemeData.grey01,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.mediumOpenSans,
                                  ),
                                ),
                                value: 'distance',
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                groupValue: controller.selectedSortOption.value,
                                visualDensity: VisualDensity.compact,
                                // Reduces vertical & horizontal space

                                onChanged: (value) {
                                  controller.selectedSortOption.value =
                                      value ?? '';
                                  controller.getAllFilteredLists();
                                },
                              ),
                              RadioListTile<String>(
                                title: Text(
                                  'Rating',
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark01
                                        : AppThemeData.grey01,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.mediumOpenSans,
                                  ),
                                ),
                                value: 'rating',
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                groupValue: controller.selectedSortOption.value,
                                visualDensity: VisualDensity.compact,
                                // Reduces vertical & horizontal space

                                onChanged: (value) {
                                  controller.selectedSortOption.value =
                                      value ?? '';
                                  controller.getAllFilteredLists();
                                },
                              ),
                              RadioListTile<String>(
                                title: Text(
                                  'Reviewed',
                                  style: TextStyle(
                                    color: themeChange.getThem()
                                        ? AppThemeData.greyDark01
                                        : AppThemeData.grey01,
                                    fontSize: 16,
                                    fontFamily: AppThemeData.mediumOpenSans,
                                  ),
                                ),
                                value: 'reviewed',
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                groupValue: controller.selectedSortOption.value,
                                visualDensity: VisualDensity.compact,
                                // Reduces vertical & horizontal space
                                onChanged: (value) {
                                  controller.selectedSortOption.value =
                                      value ?? '';
                                  controller.getAllFilteredLists();
                                },
                              )
                            ],
                          ),
                          Divider(),
                          Obx(
                            () => ListView.separated(
                              shrinkWrap: true,
                              controller: scrollController,
                              itemCount: controller.categoryService.length,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                ServiceModel serviceModel =
                                    controller.categoryService[index];
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      serviceModel.name.toString().tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01,
                                        fontSize: 18,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: serviceModel.options!.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index0) {
                                        return Obx(
                                          () => CheckboxListTile(
                                            title: Text(
                                              serviceModel.options![index0].name
                                                  .toString(),
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.greyDark01
                                                    : AppThemeData.grey01,
                                                fontSize: 16,
                                                fontFamily:
                                                    AppThemeData.mediumOpenSans,
                                              ),
                                            ),
                                            value: controller
                                                    .selectedOptionsByServiceId[
                                                        serviceModel.id]
                                                    ?.contains(serviceModel
                                                        .options![index0]) ??
                                                false,
                                            controlAffinity:
                                                ListTileControlAffinity
                                                    .trailing,
                                            contentPadding: EdgeInsets.zero,
                                            dense: true,
                                            visualDensity:
                                                VisualDensity.compact,
                                            // Reduces vertical & horizontal space
                                            onChanged: (value) {
                                              final id = serviceModel.id!;
                                              OptionModel option =
                                                  serviceModel.options![index0];
                                              if (value == true) {
                                                List<OptionModel> updatedList =
                                                    controller.selectedOptionsByServiceId[
                                                            id] ??
                                                        [];
                                                updatedList.add(option);
                                                controller
                                                        .selectedOptionsByServiceId[
                                                    id] = updatedList;
                                              } else {
                                                final updatedList = controller
                                                            .selectedOptionsByServiceId[
                                                        id] ??
                                                    [];
                                                updatedList.remove(option);
                                                if (updatedList.isEmpty) {
                                                  controller
                                                      .selectedOptionsByServiceId
                                                      .remove(id);
                                                } else {
                                                  controller
                                                          .selectedOptionsByServiceId[
                                                      id] = updatedList;
                                                }
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  RoundedButtonFill(
                    title: 'Apply'.tr,
                    height: 5,
                    textColor: themeChange.getThem()
                        ? AppThemeData.greyDark10
                        : AppThemeData.grey10,
                    color: themeChange.getThem()
                        ? AppThemeData.redDark02
                        : AppThemeData.red02,
                    onPress: () {
                      Get.back();
                      controller.getAllFilteredLists();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true, // Allows BottomSheet to take full height
    );
  }

  Widget emptyView(themeChange, ScrollController scrollController,
      BusinessListController controller) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'no_results_near'.trParams({
                  'category': controller.selectedCategory.value.name.toString(),
                }).tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark01
                      : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.boldOpenSans,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Try using different or fewer keywords, or move the map and redo your search."
                    .tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark01
                      : AppThemeData.grey01,
                  fontSize: 14,
                  fontFamily: AppThemeData.regularOpenSans,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Divider(
            thickness: 10,
            color: themeChange.getThem()
                ? AppThemeData.greyDark07
                : AppThemeData.grey07,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Notice something missing here?".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark01
                            : AppThemeData.grey01,
                        fontSize: 16,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RoundedButtonFill(
                      title: 'Add business'.tr,
                      height: 5.5,
                      textColor: themeChange.getThem()
                          ? AppThemeData.greyDark03
                          : AppThemeData.grey03,
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark07
                          : AppThemeData.grey07,
                      onPress: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 40,
              ),
              Image.asset(
                "assets/images/business_image.png",
                height: 140,
                width: 140,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget categoryChip(themeChange, CategoryModel label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeChange.getThem()
              ? AppThemeData.greyDark05
              : AppThemeData.grey05,
        ),
      ),
      child: Text(
        label.name.toString(),
        style: TextStyle(
          color: themeChange.getThem()
              ? AppThemeData.greyDark01
              : AppThemeData.grey01,
          fontSize: 14,
          fontFamily: AppThemeData.semiboldOpenSans,
        ),
      ),
    );
  }

  double getContentHeight() {
    return 200; // Calculate based on the actual content dynamically
  }
}
