import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/chat_screen/chat_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/business_project_list_controller.dart';
import 'package:yelpify/models/pricing_request_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/widgets/readmore.dart';
import 'package:yelpify/widgets/user_view.dart';
import 'package:badges/badges.dart' as badges;

class BusinessProjectListScreen extends StatelessWidget {
  const BusinessProjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: BusinessProjectListController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    SvgPicture.asset("assets/icons/icon_left.svg",colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, BlendMode.srcIn),),
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              title: Text(
                "Project Request".tr,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: controller.activeSentRequest.isEmpty
                        ? Constant.showEmptyView(message: "You don’t have any project requests yet.")
                        : ListView.builder(
                            itemCount: controller.activeSentRequest.length,
                            itemBuilder: (context, index) {
                              PricingRequestModel pricingRequestModel = controller.activeSentRequest[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                    border: Border.all(
                                      color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        UserView(userId: pricingRequestModel.userId.toString()),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${pricingRequestModel.category!.name}".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.boldOpenSans,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ReadMoreText(
                                          "${pricingRequestModel.description}".tr,
                                          trimLines: 3,
                                          colorClickableText: Colors.pink,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Show more'.tr,
                                          trimExpandedText: 'Show less'.tr,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.grey03 : AppThemeData.grey03,
                                            fontSize: 12,
                                            fontFamily: AppThemeData.regularOpenSans,
                                          ),
                                          moreStyle: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.red02 : AppThemeData.red02,
                                            fontSize: 14,
                                            fontFamily: AppThemeData.boldOpenSans,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        StreamBuilder(
                                          stream: controller.checkStatus(pricingRequestModel),
                                          builder: (context, snapshot0) {
                                            if (!snapshot0.hasData) return SizedBox();
                                            bool isChatDone = snapshot0.data ?? false;
                                            return StreamBuilder<int>(
                                              stream: controller.getUnreadChatCount(pricingRequestModel),
                                              builder: (context, snapshot) {
                                                final count = snapshot.data ?? 0;
                                                return RoundedButtonFill(
                                                  title: isChatDone ? 'See Messages'.tr : 'Start a conversion'.tr,
                                                  height: 5,
                                                  icon: badges.Badge(
                                                    badgeContent: Text(
                                                      (count).toString(),
                                                      style: TextStyle(
                                                        color: AppThemeData.grey10,
                                                      ),
                                                    ),
                                                    showBadge: count == 0 ? false : true,
                                                    badgeStyle: badges.BadgeStyle(badgeColor: AppThemeData.red02),
                                                    child: Constant.svgPictureShow(
                                                      "assets/icons/icon_wechat.svg",
                                                      themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                      32,
                                                      32,
                                                    ),
                                                  ),
                                                  isRight: false,
                                                  isCenter: true,
                                                  textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                  color: isChatDone
                                                      ? themeChange.getThem()
                                                          ? AppThemeData.tealDark02
                                                          : AppThemeData.teal02
                                                      : themeChange.getThem()
                                                          ? AppThemeData.redDark02
                                                          : AppThemeData.red02,
                                                  onPress: () async {
                                                    UserModel? userModel = await FireStoreUtils.getUserProfile(pricingRequestModel.userId.toString());
                                                    Get.to(ChatScreen(), arguments: {
                                                      "userModel": userModel,
                                                      "businessModel": controller.businessModel.value,
                                                      "projectModel": pricingRequestModel,
                                                      "isSender": "business",
                                                    });
                                                  },
                                                );
                                              },
                                            );
                                          },
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
