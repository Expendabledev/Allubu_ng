import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/chat_screen/chat_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/project_details_controller.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/themes/round_button_border.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';

class ProjectDetailsScreen extends StatelessWidget {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ProjectDetailsController(),
        builder: (controller) {
          return Scaffold(
            body: controller.isLoading.value
                ? Constant.loader()
                : NestedScrollView(
                    controller: controller.scrollController,
                    headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: Responsive.height(26, context),
                          floating: false,
                          pinned: true,
                          scrolledUnderElevation: 0,
                          automaticallyImplyLeading: false,
                          leadingWidth: 120,
                          leading: DebouncedInkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Row(
                              children: [
                                Constant.svgPictureShow(
                                    "assets/icons/icon_left.svg",
                                    innerBoxIsScrolled
                                        ? themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01
                                        : themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01,
                                    26,
                                    26),
                                Text(
                                  "Back".tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: innerBoxIsScrolled
                                        ? themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01
                                        : themeChange.getThem()
                                            ? AppThemeData.greyDark01
                                            : AppThemeData.grey01,
                                    fontSize: 14,
                                    fontFamily: AppThemeData.semiboldOpenSans,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [],
                          backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Padding(
                              padding: const EdgeInsets.only(top: 120),
                              child: Column(
                                children: [
                                  NetworkImageWidget(
                                    imageUrl: controller.pricingRequestModel.value.category!.icon.toString(),
                                    width: 44,
                                    height: 44,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${controller.pricingRequestModel.value.category?.name}".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                      fontSize: 16,
                                      fontFamily: AppThemeData.boldOpenSans,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    Constant.formatTimestamp(controller.pricingRequestModel.value.createdAt!).tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                      fontSize: 12,
                                      fontFamily: AppThemeData.regularOpenSans,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(48),
                            child: Align(
                              alignment: Alignment.centerLeft, // 👈 Align to left
                              child: TabBar(
                                controller: controller.tabController,
                                isScrollable: false,
                                indicatorSize: TabBarIndicatorSize.label,
                                // or Tab if you want full tab width
                                // 👈 This makes it scrollable
                                onTap: (value) {
                                  controller.currentIndex.value = value;
                                },
                                indicatorColor: themeChange.getThem() ? AppThemeData.red02 : AppThemeData.red02,
                                labelColor: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                unselectedLabelColor: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                                labelPadding: EdgeInsets.symmetric(horizontal: 5),
                                // 👈 Equal padding
                                indicator: UnderlineTabIndicator(
                                  insets: EdgeInsets.symmetric(horizontal: controller.tabController.length > 3 ? -20 : -50),
                                  borderSide: BorderSide(
                                    color: themeChange.getThem() ? AppThemeData.red02 : AppThemeData.red02,
                                    width: 4,
                                  ),
                                ),
                                tabs: [
                                  Tab(text: "Messages".tr),
                                  Tab(text: "Project Details".tr),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      controller: controller.tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          color: themeChange.getThem() ? AppThemeData.surfaceDark50 : AppThemeData.surface50,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: controller.businessList.length,
                              itemBuilder: (context, index) {
                                BusinessModel businessModel = controller.businessList[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                ClipOval(
                                                  child: NetworkImageWidget(
                                                    height: Responsive.height(6, context),
                                                    width: Responsive.width(14, context),
                                                    imageUrl: businessModel.coverPhoto.toString(),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "${businessModel.businessName}".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData.boldOpenSans,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            StreamBuilder<bool>(
                                              stream: controller.checkStatus(businessModel),
                                              builder: (context, snapshot) {
                                                bool isChatDone = snapshot.data ?? false;
                                                return isChatDone
                                                    ? StreamBuilder<int>(
                                                        stream: controller.getUnreadChatCount(businessModel),
                                                        builder: (context, snapshot) {
                                                          final count = snapshot.data ?? 0;
                                                          return RoundedButtonBorder(
                                                            title: 'See Message'.tr,
                                                            height: 5.5,
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
                                                                themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                                32,
                                                                32,
                                                              ),
                                                            ),
                                                            isRight: false,
                                                            isCenter: true,
                                                            borderColor: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                                                            textColor: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                            color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                                            onPress: () async {
                                                              UserModel? userModel = await FireStoreUtils.getUserProfile(controller.pricingRequestModel.value.userId.toString());
                                                              Get.to(ChatScreen(), arguments: {
                                                                "userModel": userModel,
                                                                "businessModel": businessModel,
                                                                "projectModel": controller.pricingRequestModel.value,
                                                                "isSender": "user",
                                                              });
                                                            },
                                                          );
                                                        },
                                                      )
                                                    : Text(
                                                        "Is Reviewing your request".tr,
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                          fontSize: 14,
                                                          fontFamily: AppThemeData.regularOpenSans,
                                                        ),
                                                      );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          color: themeChange.getThem() ? AppThemeData.surfaceDark50 : AppThemeData.surface50,
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              child: Column(
                                children: [
                                  Container(
                                    width: Responsive.width(100, context),
                                    decoration: BoxDecoration(
                                      color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                      borderRadius: BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Request Information".tr,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                              fontSize: 16,
                                              fontFamily: AppThemeData.boldOpenSans,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "Any details you'd like to add?".tr,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.grey03 : AppThemeData.grey03,
                                              fontSize: 14,
                                              fontFamily: AppThemeData.mediumOpenSans,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${controller.pricingRequestModel.value.description}".tr,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.grey03 : AppThemeData.grey03,
                                              fontSize: 14,
                                              fontFamily: AppThemeData.mediumOpenSans,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  controller.pricingRequestModel.value.images == null || controller.pricingRequestModel.value.images!.isEmpty
                                      ? SizedBox()
                                      : Container(
                                          margin: EdgeInsets.only(top: 10),
                                          width: Responsive.width(100, context),
                                          decoration: BoxDecoration(
                                            color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: 120,
                                              child: ListView.builder(
                                                itemCount: controller.pricingRequestModel.value.images!.length,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                                                      child: NetworkImageWidget(
                                                        imageUrl: controller.pricingRequestModel.value.images![index],
                                                        fit: BoxFit.cover,
                                                        width: 100,
                                                        height: 100,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
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
}
