import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/chat_screen/user_chat_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/followes_list_controller.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/widgets/user_view.dart';

import '../../utils/fire_store_utils.dart';

class FollowersList extends StatelessWidget {
  const FollowersList({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: FollowersListController(),
        dispose: (state) {
          Get.delete<FollowersListController>();
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
              title: Text(
                "Followers".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: controller.userModel.value.followers!.isEmpty
                        ? Constant.showEmptyView(message: "Your Friend List is Empty".tr)
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.userModel.value.followers!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                    border: Border.all(
                                      color: themeChange.getThem() ? AppThemeData.greyDark07 : AppThemeData.grey07,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () async {
                                        await FireStoreUtils.getUserProfile(controller.userModel.value.followers![index]).then((value) {
                                          UserModel userModel = value!;
                                          Get.to(const UserChatScreen(), arguments: {"receiverModel": userModel});
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(child: UserView(userId: controller.userModel.value.followers![index])),
                                          controller.myProfile.value?RoundedButtonFill(
                                            title: 'Remove'.tr,
                                            height: 4,
                                            width: 22,
                                            textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                            color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02,
                                            onPress: () {
                                              controller.unfollow();
                                            },
                                          ):SizedBox(),
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
