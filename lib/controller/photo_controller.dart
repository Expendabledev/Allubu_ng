import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:allubmarket/widgets/debounced_inkwell.dart';
import 'package:mime/mime.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/photo_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/widgets/grid_video_thumbnail.dart';

class PhotoController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<BusinessModel> businessModel = BusinessModel().obs;

  RxList<PhotoModel> menuPhotosList = <PhotoModel>[].obs;
  RxList<PhotoModel> allPhotos = <PhotoModel>[].obs;
  RxList<Map<String, String>> selectedPhoto = <Map<String, String>>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      businessModel.value = argumentData['businessModel'];
      getMenuImage();
      getAllPhotos();
    }
    isLoading.value = false;
    update();
  }

  bool hasMenuPhoto() {
    if (businessModel.value.category == null ||
        businessModel.value.category!.isEmpty) {
      return false;
    }
    return businessModel.value.category!
        .any((category) => category.menuPhotos == true);
  }

  Future<void> getMenuImage() async {
    await FireStoreUtils.getAllPhotosByType(
            businessModel.value.id.toString(), "menuPhoto")
        .then(
      (value) {
        menuPhotosList.value = value;
      },
    );
  }

  Future<void> getAllPhotos() async {
    await FireStoreUtils.getAllPhotos(
            businessModel.value.id.toString(), "menuPhoto")
        .then(
      (value) {
        allPhotos.value = value;
      },
    );
  }

  void updatePhoto(int index, PhotoModel reviewModel) {
    allPhotos.removeAt(index - 1);
    allPhotos.insert(index - 1, reviewModel);
  }

  void updateMenuPhoto(int index, PhotoModel reviewModel) {
    menuPhotosList.removeAt(index);
    menuPhotosList.insert(index, reviewModel);
  }

  Future pickMultipleMediaFiles(bool isShowing, themeChange) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'png', 'mp4', 'mov', 'mkv'],
      allowMultiple: true,
    );

    List<Map<String, String>> filesData = [];

    if (result != null) {
      for (var file in result.files) {
        final path = file.path;
        if (path != null) {
          final mimeType = lookupMimeType(path);
          if (mimeType != null &&
              (mimeType.startsWith("image/") ||
                  mimeType.startsWith("video/"))) {
            selectedPhoto.add({
              "path": path,
              "type": mimeType.startsWith("video/") ? "video" : "image",
            });
          }
        }
      }
    }

    if (isShowing) {
      showImageBottomSheet(themeChange);
    }
    selectedPhoto.addAll(filesData);
  }

  void showImageBottomSheet(themeChange) {
    Get.bottomSheet(
      Container(
        height: Responsive.height(80, Get.context!),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: selectedPhoto.length + 1,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return DebouncedInkWell(
                        onTap: () {
                          pickMultipleMediaFiles(false, themeChange);
                        },
                        child: Container(
                          width: Responsive.width(100, context),
                          height: Responsive.height(100, context),
                          decoration: BoxDecoration(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark08
                                : AppThemeData.grey08,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add,
                                  size: 32, color: AppThemeData.teal02),
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
                    String filePath =
                        selectedPhoto[index - 1]['path'].toString();
                    String type = selectedPhoto[index - 1]['type'].toString();
                    return Stack(
                      children: [
                        type == 'image'
                            ? Image.file(
                                File(filePath),
                                fit: BoxFit.cover,
                                width: Responsive.width(100, context),
                                height: Responsive.height(100, context),
                              )
                            : GridVideoThumbnail(
                                key: ValueKey(filePath),
                                filePath: filePath,
                              ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: DebouncedInkWell(
                            onTap: () {
                              selectedPhoto.removeAt(index - 1);
                            },
                            child: ClipOval(
                              child: Container(
                                height: 30,
                                width: 30,
                                color: AppThemeData.red03,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Constant.svgPictureShow(
                                      "assets/icons/delete-one.svg",
                                      AppThemeData.red02,
                                      30,
                                      30),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            RoundedButtonFill(
              title: 'Upload Photo'.tr,
              height: 5.5,
              textColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              color: themeChange.getThem()
                  ? AppThemeData.redDark02
                  : AppThemeData.red02,
              onPress: () {
                uploadPhotos();
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      isScrollControlled: true, // Allows BottomSheet to take full height
    );
  }

  Future<void> uploadPhotos() async {
    ShowToastDialog.showLoader("Please wait");
    PhotoModel photoModel = PhotoModel();
    for (int i = 0; i < selectedPhoto.length; i++) {
      String url = await Constant.uploadUserImageToFireStorage(
        File(selectedPhoto[i]['path'].toString()),
        "${businessModel.value.id}/${Constant.businessPhotos}",
        File(selectedPhoto[i]['path'].toString()).path.split('/').last,
      );

      photoModel.id = Constant.getUuid();
      photoModel.businessId = businessModel.value.id;
      photoModel.userId = FireStoreUtils.getCurrentUid();
      photoModel.imageUrl = url;
      photoModel.createdAt = Timestamp.now();
      photoModel.type = "photo";
      photoModel.fileType = selectedPhoto[i]['type'];
      await FireStoreUtils.addPhotos(photoModel);
    }
    selectedPhoto.clear();
    ShowToastDialog.closeLoader();
    ShowToastDialog.showToast("Photo Upload Successfully");
    getAllPhotos();
    Get.back();
  }
}
