import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/category_selection_controller.dart';
import 'package:allubmarket/models/category_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/themes/text_field_widget.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class CategorySelectionScreen extends StatelessWidget {
  const CategorySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: CategorySelectionController(),
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
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.greyDark06
                              : AppThemeData.grey01,
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
                "Edit Categories".tr,
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
                    List<CategoryModel> categoryModel = [];
                    categoryModel.addAll(controller.selectedCategories);
                    Get.back(result: categoryModel);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      "Add".tr,
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
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: controller.isSearchShow.value
                  ? Column(
                      children: [
                        TextFieldWidget(
                          controller: controller.searchController.value,
                          hintText: 'Search a category...',
                          onchange: (value) =>
                              controller.searchCategories(value),
                          prefix: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                                "assets/icons/icon_search.svg"),
                          ),
                          suffix: InkWell(
                            onTap: () {
                              controller.searchController.value.clear();
                              controller.categories.clear();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                "assets/icons/close-one.svg",
                                colorFilter: ColorFilter.mode(
                                    themeChange.getThem()
                                        ? AppThemeData.greyDark03
                                        : AppThemeData.grey03,
                                    BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.categories.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (context, index) {
                              CategoryModel category =
                                  controller.categories[index];
                              return FutureBuilder<List<CategoryModel>?>(
                                future: FireStoreUtils.getCategoryHierarchy(
                                    category),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return SizedBox();
                                  List<CategoryModel> parentCategory =
                                      snapshot.data!;
                                  return Container(
                                    width: Responsive.width(100, context),
                                    decoration: BoxDecoration(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark10
                                          : AppThemeData.grey10,
                                      border: Border.all(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark06
                                            : AppThemeData.grey06,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.search),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Wrap(
                                              spacing: 1, // Space between items
                                              runSpacing:
                                                  3, // Space between lines
                                              children: parentCategory
                                                  .map((subcategory) {
                                                return InkWell(
                                                  onTap: () {
                                                    controller
                                                        .selectedCategories
                                                        .add(category);
                                                    controller
                                                        .searchController.value
                                                        .clear();
                                                    controller.isSearchShow
                                                        .value = false;
                                                  },
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize
                                                        .min, // Prevent unnecessary stretching
                                                    children: [
                                                      Text(
                                                        subcategory.name
                                                            .toString(),
                                                        style: TextStyle(
                                                          color: parentCategory
                                                                      .indexOf(
                                                                          subcategory) ==
                                                                  0
                                                              ? (themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .greyDark03
                                                                  : AppThemeData
                                                                      .grey03)
                                                              : (themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .greyDark01
                                                                  : AppThemeData
                                                                      .grey01),
                                                          fontSize: 14,
                                                          fontFamily: parentCategory
                                                                      .indexOf(
                                                                          subcategory) ==
                                                                  0
                                                              ? AppThemeData
                                                                  .regularOpenSans
                                                              : AppThemeData
                                                                  .boldOpenSans,
                                                        ),
                                                      ),
                                                      if (parentCategory.indexOf(
                                                              subcategory) !=
                                                          parentCategory
                                                                  .length -
                                                              1)
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      5),
                                                          child:
                                                              SvgPicture.asset(
                                                            "assets/icons/icon_right.svg",
                                                            width: 20,
                                                            colorFilter:
                                                                ColorFilter
                                                                    .mode(
                                                              themeChange
                                                                      .getThem()
                                                                  ? AppThemeData
                                                                      .greyDark03
                                                                  : AppThemeData
                                                                      .grey03,
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: controller.selectedCategories.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              CategoryModel category =
                                  controller.selectedCategories[index];
                              return FutureBuilder<List<CategoryModel>?>(
                                future: FireStoreUtils.getCategoryHierarchy(
                                    category),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) return SizedBox();
                                  List<CategoryModel> parentCategory =
                                      snapshot.data!;
                                  return Container(
                                    width: Responsive.width(100, context),
                                    height: Responsive.width(12, context),
                                    decoration: BoxDecoration(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark10
                                          : AppThemeData.grey10,
                                      border: Border.all(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark06
                                            : AppThemeData.grey06,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: parentCategory.length,
                                              padding: EdgeInsets.zero,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                CategoryModel subcategory =
                                                    parentCategory[index];
                                                return Center(
                                                  child: Text(
                                                    subcategory.name.toString(),
                                                    textAlign: TextAlign.start,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                      color: index == 0
                                                          ? themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .greyDark03
                                                              : AppThemeData
                                                                  .grey03
                                                          : themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .greyDark01
                                                              : AppThemeData
                                                                  .grey01,
                                                      fontSize: 14,
                                                      fontFamily: index == 0
                                                          ? AppThemeData
                                                              .regularOpenSans
                                                          : AppThemeData
                                                              .boldOpenSans,
                                                    ),
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return SvgPicture.asset(
                                                  "assets/icons/icon_right.svg",
                                                  width: 20,
                                                  colorFilter: ColorFilter.mode(
                                                      themeChange.getThem()
                                                          ? AppThemeData
                                                              .greyDark03
                                                          : AppThemeData.grey03,
                                                      BlendMode.srcIn),
                                                );
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          InkWell(
                                              onTap: () {
                                                controller.selectedCategories
                                                    .removeAt(index);
                                              },
                                              child: Constant.svgPictureShow(
                                                  "assets/icons/delete.svg",
                                                  themeChange.getThem()
                                                      ? AppThemeData.red02
                                                      : AppThemeData.red02,
                                                  18,
                                                  18))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        RoundedButtonFill(
                          title: 'Add Another Category'.tr,
                          height: 5.5,
                          textColor: themeChange.getThem()
                              ? AppThemeData.greyDark10
                              : AppThemeData.grey10,
                          color: themeChange.getThem()
                              ? AppThemeData.redDark02
                              : AppThemeData.red02,
                          onPress: () {
                            if (controller.selectedCategories.length <
                                int.parse(Constant.maxBusinessCategory)) {
                              controller.searchController.value.clear();
                              controller.isSearchShow.value = true;
                            } else {
                              ShowToastDialog.showToast(
                                  'max_categories_limit'.trParams({
                                'count':
                                    Constant.maxBusinessCategory.toString(),
                              }).tr);
                            }
                          },
                        ),
                      ],
                    ),
            ),
          );
        });
  }
}
