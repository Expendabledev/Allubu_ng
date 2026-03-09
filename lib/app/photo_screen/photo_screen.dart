import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/auth_screen/welcome_screen.dart';
import 'package:allubmarket/app/photo_screen/photo_view_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/photo_controller.dart';
import 'package:allubmarket/models/photo_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/widgets/debounced_inkwell.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/network_image_widget.dart';
import 'package:allubmarket/widgets/grid_video_thumbnail.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: PhotoController(),
        builder: (controller) {
          return DefaultTabController(
            length: 2, // Number of tabs
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: themeChange.getThem()
                    ? AppThemeData.greyDark10
                    : AppThemeData.grey10,
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
                bottom: controller.hasMenuPhoto()
                    ? TabBar(
                        labelColor: themeChange.getThem()
                            ? AppThemeData.greyDark01
                            : AppThemeData.grey01,
                        unselectedLabelColor: themeChange.getThem()
                            ? AppThemeData.greyDark04
                            : AppThemeData.grey04,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: AppThemeData.semiboldOpenSans,
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: AppThemeData.regularOpenSans,
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark04
                              : AppThemeData.grey04,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        // Makes the indicator full width
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                              width: 4,
                              color: AppThemeData
                                  .red02), // Full-width red indicator
                        ),
                        tabs: [
                          Tab(
                              text: 'all_photos_count'.trParams({
                            'count': controller.allPhotos.length.toString(),
                          }).tr),
                          Tab(
                              text: 'menu_photos_count'.trParams({
                            'count':
                                controller.menuPhotosList.length.toString(),
                          })),
                        ],
                      )
                    : null,
                title: Text(
                  "Photos".tr,
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
                  : TabBarView(
                      children: [
                        buildPhotoGrid(
                          themeChange,
                          controller.allPhotos,
                          controller,
                        ),
                        buildMenuPhotoGrid(
                          themeChange,
                          controller.menuPhotosList,
                          controller,
                        )
                      ],
                    ),
            ),
          );
        });
  }

  Widget buildPhotoGrid(
      themeChange, List<PhotoModel> images, PhotoController controller) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: images.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return DebouncedInkWell(
            onTap: () {
              if (FireStoreUtils.getCurrentUid() == '' ||
                  FireStoreUtils.getCurrentUid().isEmpty) {
                Get.offAll(WelcomeScreen());
              } else {
                controller.pickMultipleMediaFiles(true, themeChange);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: themeChange.getThem()
                    ? AppThemeData.greyDark08
                    : AppThemeData.grey08,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 32, color: AppThemeData.teal02),
                  Text(
                    "Add Photo".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark02
                          : AppThemeData.grey02,
                      fontSize: 16,
                      fontFamily: AppThemeData.semiboldOpenSans,
                    ),
                  )
                ],
              ),
            ),
          );
        }
        PhotoModel photoModel = images[index - 1];
        return DebouncedInkWell(
          onTap: () {
            if (FireStoreUtils.getCurrentUid() == '') {
              Get.offAll(WelcomeScreen());
            } else {
              Get.to(PhotoViewScreen(), arguments: {
                "photoList": images,
                "index": images.indexOf(photoModel)
              })!
                  .then(
                (value) {
                  controller.getAllPhotos();
                  controller.getMenuImage();
                },
              );
            }
          },
          child: Stack(
            children: [
              photoModel.fileType == "video"
                  ? GridVideoThumbnail(
                      key: ValueKey(photoModel.imageUrl.toString()),
                      filePath: photoModel.imageUrl.toString(),
                    )
                  : NetworkImageWidget(
                      imageUrl: photoModel.imageUrl.toString(),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
              if (FireStoreUtils.getCurrentUid() != '')
                Positioned(
                  top: 5,
                  right: 5,
                  child: DebouncedInkWell(
                    onTap: () {
                      if (photoModel.likedBy!
                          .contains(FireStoreUtils.getCurrentUid())) {
                        photoModel.likedBy!
                            .remove(FireStoreUtils.getCurrentUid());
                      } else {
                        photoModel.likedBy!.add(FireStoreUtils.getCurrentUid());
                      }
                      FireStoreUtils.addPhotos(photoModel);
                      controller.updatePhoto(index, photoModel);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: photoModel.likedBy!
                                .contains(FireStoreUtils.getCurrentUid())
                            ? AppThemeData.red02
                            : themeChange.getThem()
                                ? AppThemeData.greyDark10
                                : AppThemeData.grey10,
                        shape: BoxShape.circle,
                      ),
                      child: Constant.svgPictureShow(
                        "assets/icons/icon_thumbs-up.svg",
                        photoModel.likedBy!
                                .contains(FireStoreUtils.getCurrentUid())
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

  Widget buildMenuPhotoGrid(
      themeChange, List<PhotoModel> images, PhotoController controller) {
    return images.isEmpty
        ? Constant.showEmptyView(message: "Photos not found")
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
              return DebouncedInkWell(
                onTap: () {
                  Get.to(PhotoViewScreen(),
                          arguments: {"photoList": images, "index": index})!
                      .then(
                    (value) {
                      controller.getAllPhotos();
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
                      child: DebouncedInkWell(
                        onTap: () {
                          if (uploadMenuModel.likedBy!
                              .contains(FireStoreUtils.getCurrentUid())) {
                            uploadMenuModel.likedBy!
                                .remove(FireStoreUtils.getCurrentUid());
                          } else {
                            uploadMenuModel.likedBy!
                                .add(FireStoreUtils.getCurrentUid());
                          }
                          FireStoreUtils.addPhotos(uploadMenuModel);
                          controller.updateMenuPhoto(index, uploadMenuModel);
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: uploadMenuModel.likedBy!
                                    .contains(FireStoreUtils.getCurrentUid())
                                ? AppThemeData.red02
                                : themeChange.getThem()
                                    ? AppThemeData.greyDark10
                                    : AppThemeData.grey10,
                            shape: BoxShape.circle,
                          ),
                          child: Constant.svgPictureShow(
                            "assets/icons/icon_thumbs-up.svg",
                            uploadMenuModel.likedBy!
                                    .contains(FireStoreUtils.getCurrentUid())
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
}
