import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/collection_details_screen/collection_details_screen.dart';
import 'package:yelpify/app/more_category_screen/more_category_screen.dart';
import 'package:yelpify/app/search_screen/search_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/home_controller.dart';
import 'package:yelpify/models/bookmarks_model.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/service/ad_manager.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';

import 'business_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60.0), // here the desired height
              child: AppBar(
                backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                title: DebouncedInkWell(
                  onTap: () {
                    Get.to(SearchScreen());
                  },
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    controller: controller.searchController.value,
                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, fontFamily: AppThemeData.medium),
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.red),
                      enabled: false,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Constant.svgPictureShow("assets/icons/ic_search.svg", null, null, null),
                      ),
                      prefixIconConstraints: BoxConstraints(minHeight: 20, minWidth: 20),
                      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                      fillColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                      disabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(Radius.circular(30)),
                        borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                      ),
                      hintText: "Search for nail salons".tr,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                        fontFamily: AppThemeData.regularOpenSans,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : RefreshIndicator(
                    onRefresh: () async {
                      await controller.getParentCategory();
                    },
                    child: ListView(
                      children: [
                        AdManager.bannerAdWidget(),
                        Container(
                          decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // Adjust to match your design
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.90,
                              ),
                              itemCount: controller.categoryList.length > 7 ? 8 : controller.categoryList.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 7 || index >= controller.categoryList.length) {
                                  return DebouncedInkWell(
                                    onTap: () {
                                      Get.to(MoreCategoryScreen());
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Constant.svgPictureShow('assets/icons/icon_more-one.svg', themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, 40, 40),
                                        SizedBox(height: 4),
                                        Text(
                                          "More",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                            fontFamily: AppThemeData.medium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  CategoryModel categoryModel = controller.categoryList[index];
                                  return DebouncedInkWell(
                                    onTap: () {
                                      controller.setSearchHistory(categoryModel);
                                      Get.to(BusinessListScreen(), arguments: {
                                        "categoryModel": categoryModel,
                                        "latLng": null,
                                        "isZipCode": false,
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        NetworkImageWidget(
                                          imageUrl: categoryModel.icon.toString(),
                                          width: 45,
                                          height: 45,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          categoryModel.name.toString(),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                            fontFamily: AppThemeData.medium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: controller.bookMarkList.length,
                            itemBuilder: (context, index) {
                              BookmarksModel bookmarkModel = controller.bookMarkList[index];
                              return DebouncedInkWell(
                                onTap: () {
                                  Get.to(CollectionDetailsScreen(), arguments: {"bookmarkModel": bookmarkModel});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: SizedBox(
                                    height: Responsive.height(40, context),
                                    width: Responsive.width(100, context),
                                    child: Stack(
                                      children: [
                                        bookmarkModel.businessIds!.isEmpty
                                            ? Container(
                                                height: Responsive.height(40, context),
                                                width: Responsive.width(100, context),
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: NetworkImageWidget(
                                                    imageUrl: Constant.placeHolderImage,
                                                    color: themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03,
                                                  ),
                                                ),
                                              )
                                            : FutureBuilder<BusinessModel?>(
                                                future: FireStoreUtils.getBusinessByCollection(bookmarkModel),
                                                builder: (context, snapshot) {
                                                  BusinessModel? businessModel = snapshot.data;
                                                  return businessModel == null
                                                      ? Container(
                                                          height: Responsive.height(40, context),
                                                          width: Responsive.width(100, context),
                                                          padding: EdgeInsets.all(10),
                                                          decoration: BoxDecoration(
                                                            color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey03,
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(10),
                                                            ),
                                                          ),
                                                          child: NetworkImageWidget(
                                                            imageUrl: Constant.placeHolderImage,
                                                            color: themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03,
                                                          ),
                                                        )
                                                      : ClipRRect(
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          child: Stack(
                                                            children: [
                                                              NetworkImageWidget(
                                                                imageUrl: businessModel.coverPhoto.toString(),
                                                                height: Responsive.height(40, context),
                                                                width: Responsive.width(100, context),
                                                                fit: BoxFit.cover,
                                                                errorWidget: Container(
                                                                  height: Responsive.height(40, context),
                                                                  width: Responsive.width(100, context),
                                                                  decoration: BoxDecoration(
                                                                    color: themeChange.getThem() ? AppThemeData.greyDark09 : AppThemeData.grey09,
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(10),
                                                                    ),
                                                                  ),
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(6),
                                                                    child: NetworkImageWidget(
                                                                      imageUrl: Constant.placeHolderImage,
                                                                      color: themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                height: Responsive.height(40, context),
                                                                width: Responsive.width(100, context),
                                                                color: Colors.black.withOpacity(0.30),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                },
                                              ),
                                        Positioned(
                                          bottom: 10,
                                          left: 16,
                                          right: 16,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${bookmarkModel.name}".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey10,
                                                  fontSize: 20,
                                                  fontFamily: AppThemeData.boldOpenSans,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "View collection".tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey10,
                                                      fontSize: 16,
                                                      fontFamily: AppThemeData.semiboldOpenSans,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Constant.svgPictureShow("assets/icons/icon_right-small.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey10, 20, 20)
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
