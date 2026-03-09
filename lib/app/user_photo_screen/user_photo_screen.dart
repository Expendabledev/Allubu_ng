import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/photo_screen/photo_view_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/user_photo_controller.dart';
import 'package:allubmarket/models/photo_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/network_image_widget.dart';

class UserPhotoScreen extends StatelessWidget {
  const UserPhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: UserPhotoController(),
        autoRemove: true,
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
                        "assets/icons/icon_left.svg",
                        width: 22,
                        colorFilter: ColorFilter.mode(
                            themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                            BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Back".tr,
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
                : controller.photosList.isEmpty
                    ? Constant.showEmptyView(message: "Images not found")
                    : GridView.builder(
                        padding: EdgeInsets.all(10),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: controller.photosList.length,
                        itemBuilder: (context, index) {
                          PhotoModel uploadMenuModel =
                              controller.photosList[index];
                          return InkWell(
                            onTap: () {
                              Get.to(PhotoViewScreen(), arguments: {
                                "photoList": controller.photosList,
                                "index": index
                              });
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
                                      if (uploadMenuModel.likedBy!.contains(
                                          FireStoreUtils.getCurrentUid())) {
                                        uploadMenuModel.likedBy!.remove(
                                            FireStoreUtils.getCurrentUid());
                                      } else {
                                        uploadMenuModel.likedBy!.add(
                                            FireStoreUtils.getCurrentUid());
                                      }
                                      FireStoreUtils.addPhotos(uploadMenuModel);
                                      controller.updateMenuPhoto(
                                          index, uploadMenuModel);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: uploadMenuModel.likedBy!
                                                .contains(FireStoreUtils
                                                    .getCurrentUid())
                                            ? AppThemeData.red02
                                            : themeChange.getThem()
                                                ? AppThemeData.greyDark10
                                                : AppThemeData.grey10,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Constant.svgPictureShow(
                                        "assets/icons/icon_thumbs-up.svg",
                                        uploadMenuModel.likedBy!.contains(
                                                FireStoreUtils.getCurrentUid())
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
                      ),
          );
        });
  }
}
