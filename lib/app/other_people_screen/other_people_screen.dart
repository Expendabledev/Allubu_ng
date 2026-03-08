import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/auth_screen/welcome_screen.dart';
import 'package:yelpify/app/chat_screen/user_chat_screen.dart';
import 'package:yelpify/app/complain_report_screen/complain_report_screen.dart';
import 'package:yelpify/app/other_people_screen/compliments_list_screen.dart';
import 'package:yelpify/app/other_people_screen/followers_list.dart';
import 'package:yelpify/app/other_people_screen/following_list.dart';
import 'package:yelpify/app/user_photo_screen/user_photo_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/other_people_controller.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';

class OtherPeopleScreen extends StatelessWidget {
  const OtherPeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: OtherPeopleController(),
        dispose: (state) {
          Get.delete<OtherPeopleController>();
        },
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
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
                        colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, BlendMode.srcIn),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Back".tr,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                          fontSize: 14,
                          fontFamily: AppThemeData.semiboldOpenSans,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: Responsive.width(100, context),
                          decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Column(
                              children: [
                                ClipOval(
                                  child: NetworkImageWidget(
                                    imageUrl: controller.userModel.value.profilePic.toString(),
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  controller.userModel.value.fullName(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 20, fontFamily: AppThemeData.boldOpenSans),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Constant.svgPictureShow("assets/icons/icon_user-business.svg", themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05, 20, 20),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${controller.userModel.value.followers!.length}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.boldOpenSans,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Row(
                                      children: [
                                        Constant.svgPictureShow("assets/icons/review_show.svg", null, 20, 20),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${controller.reviewList.length}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.boldOpenSans,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Row(
                                      children: [
                                        Constant.svgPictureShow("assets/icons/icon_picture.svg", themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05, 20, 20),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${controller.photoList.length}",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.greyDark05 : AppThemeData.grey05,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.boldOpenSans,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            complimentBottomSheet(themeChange, controller);
                                          },
                                          child: imageWidget(themeChange, "assets/icons/icon_hot-air-balloon.svg", "Compliment")),
                                      Obx(
                                        () => controller.userModel.value.followers!.contains(FireStoreUtils.getCurrentUid())
                                            ? InkWell(
                                                onTap: () {
                                                  controller.unfollow();
                                                },
                                                child: imageWidget(themeChange, "assets/icons/icon_add-user.svg", "UnFollow"))
                                            : InkWell(
                                                onTap: () {
                                                  controller.followUser();
                                                },
                                                child: imageWidget(themeChange, "assets/icons/icon_add-user.svg", "Follow")),
                                      ),
                                      InkWell(
                                          onTap: () async {
                                            await FireStoreUtils.getUserProfile(controller.userModel.value.id.toString()).then((value) {
                                              UserModel userModel = value!;
                                              Get.to(const UserChatScreen(), arguments: {"receiverModel": userModel});
                                            });
                                          },
                                          child: imageWidget(themeChange, "assets/icons/icon_wechat.svg", "Message")),
                                      InkWell(
                                          onTap: () async {
                                            if (FireStoreUtils.getCurrentUid() == '' || FireStoreUtils.getCurrentUid().isEmpty) {
                                              Get.offAll(WelcomeScreen());
                                            } else {
                                              Get.to(ComplainReportScreen(),
                                                  arguments: {"type": Constant.appUserIssues, "givenBy": controller.userModel.value.id, "postId": controller.userModel.value.id});
                                            }
                                          },
                                          child: imageWidget(themeChange, "assets/icons/ic_warning.svg", "Report")),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "Contributions".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                        fontSize: 20,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Divider(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Constant.svgPictureShow("assets/icons/star.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, 24, 24),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "Review".tr,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData.semiboldOpenSans,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "${controller.reviewList.length}",
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                fontSize: 16,
                                                fontFamily: AppThemeData.semiboldOpenSans,
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(UserPhotoScreen(), arguments: {"userModel": controller.userModel.value});
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow("assets/icons/picture.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, 24, 24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Photos".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData.semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.photoList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData.semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "Community".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                        fontSize: 20,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Divider(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(FollowersList(), arguments: {"userModel": controller.userModel.value.id})!.then(
                                              (value) {
                                                controller.getUser();
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow("assets/icons/peoples-two.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, 24, 24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Followers".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData.semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.userModel.value.followers!.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData.semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(FollowingList(), arguments: {"userModel": controller.userModel.value})!.then(
                                              (value) {
                                                controller.getUser();
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow("assets/icons/peoples-two.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, 24, 24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Following".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData.semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.followingList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData.semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.to(ComplimentsListScreen(), arguments: {"userModel": controller.userModel.value})!.then(
                                              (value) {
                                                controller.getComplimentList();
                                              },
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              Constant.svgPictureShow("assets/icons/icon_hot-air-balloon.svg", themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, 24, 24),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "Compliments".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData.semiboldOpenSans,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${controller.complimentsList.length}",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                  fontSize: 16,
                                                  fontFamily: AppThemeData.semiboldOpenSans,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
          );
        });
  }

  Widget imageWidget(themeChange, String imagePath, String title) {
    return Column(
      children: [
        ClipOval(
            child: Container(
          decoration: BoxDecoration(
            color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Constant.svgPictureShow(imagePath, themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03, 28, 28),
          ),
        )),
        SizedBox(
          height: 5,
        ),
        Text(
          title.tr,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
            fontSize: 12,
            fontFamily: AppThemeData.mediumOpenSans,
          ),
        )
      ],
    );
  }

  void complimentBottomSheet(themeChange, OtherPeopleController controller) {
    Get.bottomSheet(
      DraggableScrollableSheet(
          initialChildSize: 0.6,
          // Starts at 30% of screen height
          minChildSize: 0.6,
          // Minimum height (30% of screen)
          maxChildSize: 0.9,
          // Can expand up to
          shouldCloseOnMinExtent: false,
          builder: (context, scrollController) {
            return Container(
              height: Responsive.height(32, Get.context!),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: themeChange.getThem() ? AppThemeData.surfaceDark50 : AppThemeData.surface50,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: SvgPicture.asset(
                              "assets/icons/icon_close.svg",
                              colorFilter: ColorFilter.mode(
                                themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01,
                                BlendMode.srcIn,
                              ),
                              width: 22,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "Compliment".tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                              fontSize: 18,
                              fontFamily: AppThemeData.boldOpenSans,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            controller.sendCompliment();
                          },
                          child: Text(
                            "Send".tr,
                            style: TextStyle(
                              color: themeChange.getThem() ? AppThemeData.teal02 : AppThemeData.teal02,
                              fontSize: 16,
                              fontFamily: AppThemeData.boldOpenSans,
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Divider(),
                    ),
                    SizedBox(
                      height: 150,
                      child: CupertinoPicker(
                        itemExtent: 40,
                        scrollController: FixedExtentScrollController(initialItem: controller.selectedIndex.value),
                        onSelectedItemChanged: (index) {
                          controller.selectedIndex.value = index;
                        },
                        children: controller.items.map((item) => Center(child: Text(item.tr))).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFieldWidget(
                      controller: controller.complimentTextFieldController.value,
                      hintText: 'Like  : You’re like wasabi — bold, unforgettable, and a little dangerous.'.tr,
                      maxLine: 5,
                    ),
                  ],
                ),
              ),
            );
          }),
      isScrollControlled: true, // Allows BottomSheet to take full height
      isDismissible: false,
    );
  }
}
