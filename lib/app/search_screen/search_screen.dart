import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/business_details_screen/business_details_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/search_controller.dart';
import 'package:yelpify/models/business_history_model.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/custom_star_rating/custom_star_rating_screen.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: SearchControllers(),
      builder: (controller) {
        return Scaffold(
            body: InkWell(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldWidget(
                    controller: controller.categoryTextFieldController.value,
                    hintText: 'Cleaner, movers, sushi, delivery, etc.',
                    focusNode: controller.focusNode1,
                    onchange: (value) => controller.searchCategories(value),
                    prefix: DebouncedInkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 5),
                        child: SvgPicture.asset(
                          "assets/icons/icon_left.svg",
                          colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02, BlendMode.srcIn),
                        ),
                      ),
                    ),
                    suffix: controller.categoryTextFieldController.value.text.isNotEmpty
                        ? DebouncedInkWell(
                            onTap: () {
                              controller.categoryTextFieldController.value.clear();
                              controller.categories.clear();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5, right: 10),
                              child: SvgPicture.asset(
                                "assets/icons/close-one.svg",
                                colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02, BlendMode.srcIn),
                              ),
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              controller.voiceSearch();
                            },
                            icon: Icon(Icons.mic)),
                  ),
                  TextFieldWidget(
                    controller: controller.locationTextFieldController.value,
                    hintText: 'Neighbourhood, city, state or postal code',
                    focusNode: controller.focusNode2,
                    prefix: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 5),
                      child: SvgPicture.asset(
                        "assets/icons/map-pin-line.svg",
                        colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.teal02 : AppThemeData.teal02, BlendMode.srcIn),
                      ),
                    ),
                    suffix: DebouncedInkWell(
                      onTap: () {
                        controller.searchPlaces(controller.locationTextFieldController.value.text);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 10),
                        child: SvgPicture.asset(
                          "assets/icons/ic_search.svg",
                        ),
                      ),
                    ),
                  ),
                  controller.isLocationSearch.value
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: controller.predictions.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              var prediction = controller.predictions[index];
                              return ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text(prediction['description']),
                                onTap: () {
                                  controller.getPlaceDetails(prediction['place_id']);
                                  controller.isLocationSearch.value = false;
                                },
                              );
                            },
                          ),
                        )
                      : Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              controller.categoryHistory.isEmpty
                                  ? SizedBox()
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 10, bottom: 5),
                                          child: Text(
                                            "Recently searched".tr,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                              fontSize: 14,
                                              fontFamily: AppThemeData.boldOpenSans,
                                            ),
                                          ),
                                        ),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: controller.categoryHistory.map((item) {
                                            return DebouncedInkWell(
                                              onTap: () {
                                                controller.categoryTextFieldController.value.text = item.category!.name.toString();
                                                controller.selectedCategory.value = item.category!;
                                                controller.navigateBusinessScree();
                                              },
                                              child: Chip(
                                                label: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    NetworkImageWidget(
                                                      imageUrl: item.category!.icon.toString(),
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(item.category?.name ?? 'Unnamed'),
                                                  ],
                                                ),
                                                backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06),
                                                  borderRadius: BorderRadius.circular(20), // adjust radius
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                              controller.isCategoryLoading.value
                                  ? Constant.loader()
                                  : controller.categories.isEmpty
                                      ? controller.recentSearchHistory.isEmpty
                                          ? SizedBox()
                                          : Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 20),
                                                child: ListView(
                                                  padding: EdgeInsets.zero,
                                                  children: [
                                                    Text(
                                                      "Recently viewed businesses".tr,
                                                      textAlign: TextAlign.start,
                                                      style: TextStyle(
                                                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                        fontSize: 16,
                                                        fontFamily: AppThemeData.boldOpenSans,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                                      child: Divider(),
                                                    ),
                                                    ListView.builder(
                                                      itemCount: controller.recentSearchHistory.length,
                                                      shrinkWrap: true,
                                                      padding: EdgeInsets.zero,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemBuilder: (context, index) {
                                                        BusinessHistoryModel businessHistoryModel = controller.recentSearchHistory[index];
                                                        BusinessModel businessModel = businessHistoryModel.business!;
                                                        return DebouncedInkWell(
                                                          onTap: () {
                                                            Constant.setRecentBusiness(businessModel);
                                                            Get.to(BusinessDetailsScreen(), arguments: {"businessModel": businessModel});
                                                          },
                                                          child: Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                          CustomStarRating(
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
                                                                          businessModel.businessHours == null
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
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListView.builder(
                                              itemCount: controller.categories.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index) {
                                                CategoryModel category = controller.categories[index];
                                                return FutureBuilder<List<CategoryModel>?>(
                                                  future: FireStoreUtils.getCategoryHierarchy(category),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) return SizedBox();
                                                    List<CategoryModel> parentCategory = snapshot.data!;
                                                    return SizedBox(
                                                      width: Responsive.width(100, context),
                                                      height: Responsive.width(14, context),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.search),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Wrap(
                                                              spacing: 1, // Space between items
                                                              runSpacing: 3, // Space between lines
                                                              children: parentCategory.map((subcategory) {
                                                                return DebouncedInkWell(
                                                                  onTap: () {
                                                                    controller.categoryTextFieldController.value.text = category.name.toString();
                                                                    controller.selectedCategory.value = category;
                                                                    controller.navigateBusinessScree();
                                                                  },
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min, // Prevent unnecessary stretching
                                                                    children: [
                                                                      Text(
                                                                        subcategory.name.toString(),
                                                                        style: TextStyle(
                                                                          color: parentCategory.indexOf(subcategory) == 0
                                                                              ? (themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03)
                                                                              : (themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01),
                                                                          fontSize: 14,
                                                                          fontFamily: parentCategory.indexOf(subcategory) == 0 ? AppThemeData.regularOpenSans : AppThemeData.boldOpenSans,
                                                                        ),
                                                                      ),
                                                                      if (parentCategory.indexOf(subcategory) != parentCategory.length - 1)
                                                                        Padding(
                                                                          padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                          child: SvgPicture.asset(
                                                                            "assets/icons/icon_right.svg",
                                                                            width: 20,
                                                                            colorFilter: ColorFilter.mode(
                                                                              themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03,
                                                                              BlendMode.srcIn,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ),
        ));
      },
    );
  }
}
