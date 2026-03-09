import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/chat_screen/user_chat_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/following_list_controller.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/network_image_widget.dart';

class FollowingList extends StatelessWidget {
  const FollowingList({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: FollowingListController(),
        dispose: (state) {
          Get.delete<FollowingListController>();
        },
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
                "Following".tr,
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
                        horizontal: 16, vertical: 20),
                    child: controller.followingList.isEmpty
                        ? Constant.showEmptyView(
                            message: "Your Friend List is Empty".tr)
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.followingList.length,
                            itemBuilder: (context, index) {
                              UserModel userModel =
                                  controller.followingList[index];
                              return InkWell(
                                onTap: () async {
                                  Get.to(const UserChatScreen(),
                                      arguments: {"receiverModel": userModel});
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: themeChange.getThem()
                                          ? AppThemeData.greyDark10
                                          : AppThemeData.grey10,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border: Border.all(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark07
                                            : AppThemeData.grey07,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: ClipOval(
                                                    child: NetworkImageWidget(
                                                        imageUrl: userModel
                                                            .profilePic
                                                            .toString()),
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        userModel.fullName(),
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          color: themeChange
                                                                  .getThem()
                                                              ? AppThemeData
                                                                  .greyDark02
                                                              : AppThemeData
                                                                  .grey02,
                                                          fontSize: 16,
                                                          fontFamily:
                                                              AppThemeData
                                                                  .boldOpenSans,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          controller.myProfile.value
                                              ? RoundedButtonFill(
                                                  title: 'Unfollow'.tr,
                                                  height: 4,
                                                  width: 22,
                                                  textColor: themeChange
                                                          .getThem()
                                                      ? AppThemeData.greyDark10
                                                      : AppThemeData.grey10,
                                                  color: themeChange.getThem()
                                                      ? AppThemeData.redDark02
                                                      : AppThemeData.red02,
                                                  onPress: () {
                                                    controller
                                                        .unfollow(userModel);
                                                  },
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          );
        });
  }
}
