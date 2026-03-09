import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/other_people_screen/other_people_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/compliments_list_controller.dart';
import 'package:allubmarket/models/compliment_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/widgets/user_view.dart';

import '../../models/user_model.dart';

class ComplimentsListScreen extends StatelessWidget {
  const ComplimentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<ComplimentsListController>(
        init: ComplimentsListController(),
        dispose: (_) => Get.delete<ComplimentsListController>(),
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
                "Compliments".tr,
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
                    child: controller.complimentsList.isEmpty
                        ? Constant.showEmptyView(
                            message: "Your Friend List is Empty".tr)
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.complimentsList.length,
                            itemBuilder: (context, index) {
                              ComplimentModel userModel =
                                  controller.complimentsList[index];
                              return Padding(
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: InkWell(
                                                    onTap: () async {
                                                      UserModel? userModel0 =
                                                          await FireStoreUtils
                                                              .getUserProfile(
                                                                  userModel.from
                                                                      .toString());
                                                      Get.to(
                                                          OtherPeopleScreen(),
                                                          arguments: {
                                                            "userModel":
                                                                userModel0
                                                          });
                                                    },
                                                    child: UserView(
                                                        userId: userModel.from
                                                            .toString()))),
                                            Text(
                                              Constant.formatTimestamp(
                                                      userModel.createdAt!)
                                                  .tr,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.greyDark03
                                                    : AppThemeData.grey03,
                                                fontSize: 12,
                                                fontFamily: AppThemeData
                                                    .regularOpenSans,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${userModel.title}".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.greyDark01
                                                : AppThemeData.grey01,
                                            fontSize: 16,
                                            fontFamily:
                                                AppThemeData.semiboldOpenSans,
                                          ),
                                        ),
                                        Text(
                                          "${userModel.description}".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.greyDark02
                                                : AppThemeData.grey02,
                                            fontSize: 14,
                                            fontFamily:
                                                AppThemeData.mediumOpenSans,
                                          ),
                                        ),
                                      ],
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
