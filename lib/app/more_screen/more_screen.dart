import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/auth_screen/welcome_screen.dart';
import 'package:yelpify/app/chat_screen/inbox_screen.dart';
import 'package:yelpify/app/chat_screen/user_chat_screen.dart';
import 'package:yelpify/app/create_bussiness_screen/create_business_screen.dart';
import 'package:yelpify/app/settings_screen/setting_screens.dart';
import 'package:yelpify/app/user_subscriotion_screen/user_subscription_screen.dart';
import 'package:yelpify/constant/collection_name.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/more_screen_controller.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/service/ad_manager.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/responsive.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: MoreScreenController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.surfaceDark50 : AppThemeData.surface50,
              centerTitle: true,
              leadingWidth: 120,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              title: Row(
                children: [
                  NetworkImageWidget(
                    imageUrl: Constant.appLogo,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorWidget: Constant.svgPictureShow(
                      "assets/images/ic_logo.svg",
                      null,
                      40,
                      40,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    Constant.applicationName.tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: AppThemeData.red02,
                      fontSize: 24,
                      fontFamily: AppThemeData.bold,
                    ),
                  ),
                ],
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: AdManager.bannerAdWidget(),
                          ),

                          if (FireStoreUtils.getCurrentUid() != '')
                            Container(
                              width: Responsive.width(100, context),
                              decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10, borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    DebouncedInkWell(
                                      onTap: () {
                                        if (FireStoreUtils.getCurrentUid() == '' || FireStoreUtils.getCurrentUid().isEmpty) {
                                          Get.offAll(WelcomeScreen());
                                        } else {
                                          Get.to(InboxScreen());
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FireStoreUtils.fireStore
                                                .collection(CollectionName.userChat)
                                                .doc(FireStoreUtils.getCurrentUid())
                                                .collection("inbox")
                                                .where("receiverId", isEqualTo: FireStoreUtils.getCurrentUid())
                                                .where("chatType", isEqualTo: "chat")
                                                .where("seen", isEqualTo: false)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              final int unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
                                              return badges.Badge(
                                                showBadge: unreadCount > 0,
                                                badgeStyle: badges.BadgeStyle(
                                                  badgeColor: AppThemeData.red02,
                                                ),
                                                badgeContent: Text(
                                                  unreadCount.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Constant.svgPictureShow(
                                                    "assets/icons/message-emoji.svg",
                                                    null,
                                                    20,
                                                    20,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Message".tr,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                              fontSize: 16,
                                              fontFamily: AppThemeData.semiboldOpenSans,
                                            ),
                                          ),
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
                          // Container(
                          //   width: Responsive.width(100, context),
                          //   decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10, borderRadius: BorderRadius.all(Radius.circular(10))),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           'app_for_business'.trParams({
                          //             'appName': Constant.applicationName,
                          //           }).tr,
                          //           textAlign: TextAlign.start,
                          //           style: TextStyle(
                          //             color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                          //             fontSize: 20,
                          //             fontFamily: AppThemeData.boldOpenSans,
                          //           ),
                          //         ),
                          //         SizedBox(
                          //           height: 16,
                          //         ),
                          //         InkWell(
                          //           onTap: () {
                          //             if (FireStoreUtils.getCurrentUid() == '') {
                          //               ShowToastDialog.showToast('Please create your account first before adding a business.');
                          //               Get.offAll(WelcomeScreen());
                          //             } else {
                          //               showCustomBottomSheet(themeChange, context, controller);
                          //             }
                          //           },
                          //           child: Row(
                          //             children: [
                          //               Padding(
                          //                 padding: const EdgeInsets.all(8.0),
                          //                 child: Constant.svgPictureShow("assets/icons/shop.svg", null, 20, 20),
                          //               ),
                          //               SizedBox(
                          //                 width: 10,
                          //               ),
                          //               Text(
                          //                 "Add a Business".tr,
                          //                 textAlign: TextAlign.start,
                          //                 style: TextStyle(
                          //                   color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                          //                   fontSize: 16,
                          //                   fontFamily: AppThemeData.semiboldOpenSans,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //         if (controller.businessList.isEmpty == false)
                          //           SizedBox(
                          //             height: 10,
                          //           ),
                          //         controller.businessList.isEmpty
                          //             ? SizedBox()
                          //             : Column(
                          //                 crossAxisAlignment: CrossAxisAlignment.start,
                          //                 children: [
                          //                   Text(
                          //                     "Recently added Business".tr,
                          //                     textAlign: TextAlign.start,
                          //                     style: TextStyle(
                          //                       color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                          //                       fontSize: 14,
                          //                       fontFamily: AppThemeData.semiboldOpenSans,
                          //                     ),
                          //                   ),
                          //                   ListView.builder(
                          //                     itemCount: controller.businessList.length,
                          //                     shrinkWrap: true,
                          //                     physics: NeverScrollableScrollPhysics(),
                          //                     itemBuilder: (context, index) {
                          //                       BusinessModel businessModel = controller.businessList[index];
                          //                       return InkWell(
                          //                         onTap: () {
                          //                           Get.to(MyBusinessProfileScreen(), arguments: {"businessModel": businessModel})!.then(
                          //                             (value) {
                          //                               controller.getBusiness();
                          //                             },
                          //                           );
                          //                         },
                          //                         child: Padding(
                          //                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          //                           child: Row(
                          //                             children: [
                          //                               ClipRRect(
                          //                                 borderRadius: BorderRadius.all(Radius.circular(10)),
                          //                                 child: NetworkImageWidget(
                          //                                   imageUrl: businessModel.coverPhoto.toString(),
                          //                                   height: 50,
                          //                                   width: 50,
                          //                                   fit: BoxFit.cover,
                          //                                   errorWidget: Container(
                          //                                     decoration: BoxDecoration(
                          //                                       color: themeChange.getThem() ? AppThemeData.greyDark09 : AppThemeData.grey09,
                          //                                       borderRadius: BorderRadius.all(
                          //                                         Radius.circular(10),
                          //                                       ),
                          //                                     ),
                          //                                     child: Padding(
                          //                                       padding: const EdgeInsets.all(6),
                          //                                       child: NetworkImageWidget(imageUrl: Constant.placeHolderImage),
                          //                                     ),
                          //                                   ),
                          //                                 ),
                          //                               ),
                          //                               SizedBox(
                          //                                 width: 10,
                          //                               ),
                          //                               Expanded(
                          //                                 child: Column(
                          //                                   crossAxisAlignment: CrossAxisAlignment.start,
                          //                                   children: [
                          //                                     Text(
                          //                                       businessModel.businessName!.tr,
                          //                                       textAlign: TextAlign.start,
                          //                                       style: TextStyle(
                          //                                         color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                          //                                         fontSize: 14,
                          //                                         fontFamily: AppThemeData.semiboldOpenSans,
                          //                                       ),
                          //                                     ),
                          //                                     Text(
                          //                                       Constant.getFullAddressModel(businessModel.address!),
                          //                                       textAlign: TextAlign.start,
                          //                                       style: TextStyle(
                          //                                         color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                          //                                         fontSize: 14,
                          //                                         fontFamily: AppThemeData.regularOpenSans,
                          //                                       ),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                               InkWell(
                          //                                 onTap: () async {
                          //                                   var result = await Get.bottomSheet(
                          //                                     BookMarkBottomSheet(businessModel: businessModel),
                          //                                     isScrollControlled: true,
                          //                                     backgroundColor: AppThemeData.grey10,
                          //                                   );
                          //
                          //                                   if (result == true) {
                          //                                     controller.getBusiness();
                          //                                   }
                          //                                 },
                          //                                 child: Constant.svgPictureShow(
                          //                                   businessModel.bookmarkUserId!.contains(FireStoreUtils.getCurrentUid())
                          //                                       ? "assets/icons/bookmark-one_fill.svg"
                          //                                       : "assets/icons/icon_bookmark-one.svg",
                          //                                   businessModel.bookmarkUserId!.contains(FireStoreUtils.getCurrentUid())
                          //                                       ? AppThemeData.red02
                          //                                       : themeChange.getThem()
                          //                                           ? AppThemeData.greyDark04
                          //                                           : AppThemeData.grey04,
                          //                                   24,
                          //                                   24,
                          //                                 ),
                          //                               ),
                          //                               SizedBox(
                          //                                 width: 10,
                          //                               ),
                          //                               (businessModel.ownerId == null || businessModel.ownerId != FireStoreUtils.getCurrentUid())
                          //                                   ? SizedBox()
                          //                                   : StreamBuilder<int>(
                          //                                       stream: controller.getLiveCount(businessModel),
                          //                                       builder: (context, snapshot) {
                          //                                         if (snapshot.connectionState == ConnectionState.waiting) {
                          //                                           return Padding(
                          //                                             padding: const EdgeInsets.all(6.0),
                          //                                             child: Constant.svgPictureShow(
                          //                                               "assets/icons/icon_message-unread.svg",
                          //                                               themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                          //                                               24,
                          //                                               24,
                          //                                             ),
                          //                                           );
                          //                                         } else {
                          //                                           return badges.Badge(
                          //                                             badgeContent: Text(
                          //                                               (snapshot.data ?? 0).toString(),
                          //                                               style: TextStyle(
                          //                                                 color: AppThemeData.grey10,
                          //                                               ),
                          //                                             ),
                          //                                             showBadge: snapshot.data == 0 ? false : true,
                          //                                             badgeStyle: badges.BadgeStyle(badgeColor: AppThemeData.teal02),
                          //                                             child: InkWell(
                          //                                               onTap: () {
                          //                                                 Get.to(BusinessProjectListScreen(), arguments: {"businessModel": businessModel});
                          //                                               },
                          //                                               child: Padding(
                          //                                                 padding: const EdgeInsets.all(6.0),
                          //                                                 child: Constant.svgPictureShow(
                          //                                                   "assets/icons/icon_message-unread.svg",
                          //                                                   themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                          //                                                   24,
                          //                                                   24,
                          //                                                 ),
                          //                                               ),
                          //                                             ),
                          //                                           );
                          //                                         }
                          //                                       },
                          //                                     )
                          //                             ],
                          //                           ),
                          //                         ),
                          //                       );
                          //                     },
                          //                   ),
                          //                 ],
                          //               ),
                          //         SizedBox(
                          //           height: 8,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // if (FireStoreUtils.getCurrentUid() != '')
                          //   SizedBox(
                          //     height: 20,
                          //   ),
                          if (FireStoreUtils.getCurrentUid() != '')
                            Container(
                              width: Responsive.width(100, context),
                              decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10, borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Subscription".tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                        fontSize: 20,
                                        fontFamily: AppThemeData.boldOpenSans,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Constant.adSetupModel!.subscriptionEnable == false
                                        ? SizedBox()
                                        : InkWell(
                                            onTap: () {
                                              if (FireStoreUtils.getCurrentUid() == '' || FireStoreUtils.getCurrentUid().isEmpty) {
                                                Get.offAll(WelcomeScreen());
                                              } else {
                                                Get.to(UserSubscriptionScreen());
                                              }
                                            },
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Constant.svgPictureShow("assets/icons/gift.svg", null, 20, 20),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Subscription".tr,
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                                    fontSize: 16,
                                                    fontFamily: AppThemeData.semiboldOpenSans,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          if (FireStoreUtils.getCurrentUid() != '')
                            SizedBox(
                              height: 20,
                            ),

                          Container(
                            width: Responsive.width(100, context),
                            decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10, borderRadius: BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Settings and Support".tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                      fontSize: 20,
                                      fontFamily: AppThemeData.boldOpenSans,
                                    ),
                                  ),
                                  if (FireStoreUtils.getCurrentUid() != '')
                                    SizedBox(
                                      height: 16,
                                    ),
                                  if (FireStoreUtils.getCurrentUid() != '')
                                    InkWell(
                                      onTap: () {
                                        if (FireStoreUtils.getCurrentUid() == '' || FireStoreUtils.getCurrentUid().isEmpty) {
                                          Get.offAll(WelcomeScreen());
                                        } else {
                                          UserModel userModel = UserModel(
                                            id: 'admin1234567890',
                                            firstName: "Admin",
                                            lastName: '',
                                          );

                                          Get.to(
                                            const UserChatScreen(),
                                            arguments: {"receiverModel": userModel},
                                          );
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          StreamBuilder<QuerySnapshot>(
                                            stream: FireStoreUtils.fireStore
                                                .collection(CollectionName.userChat)
                                                .doc(FireStoreUtils.getCurrentUid())
                                                .collection("inbox")
                                                .where("receiverId", isEqualTo: FireStoreUtils.getCurrentUid())
                                                .where("chatType", isEqualTo: "adminChat")
                                                .where("seen", isEqualTo: false)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              final int unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

                                              return badges.Badge(
                                                showBadge: unreadCount > 0,
                                                badgeStyle: badges.BadgeStyle(
                                                  badgeColor: AppThemeData.red02,
                                                ),
                                                badgeContent: Text(
                                                  unreadCount.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Constant.svgPictureShow(
                                                    "assets/icons/message-emoji.svg",
                                                    null,
                                                    20,
                                                    20,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Support chat".tr,
                                            style: TextStyle(
                                              color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                              fontSize: 16,
                                              fontFamily: AppThemeData.semiboldOpenSans,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ), // StreamBuilder(
                                  // StreamBuilder(
                                  //   stream: controller.getLiveCountAdminChat(),
                                  //   builder: (context, snapshot0) {
                                  //     if (!snapshot0.hasData) return SizedBox();
                                  //     return InkWell(
                                  //       onTap: () {
                                  //         UserModel userModel = UserModel(id: 'admin1234567890', firstName: "Admin", lastName: '');
                                  //         Get.to(const UserChatScreen(), arguments: {"receiverModel": userModel});
                                  //       },
                                  //       child: Row(
                                  //         children: [
                                  //           badges.Badge(
                                  //             badgeContent: Text(
                                  //               (snapshot0.data).toString(),
                                  //               style: TextStyle(
                                  //                 color: AppThemeData.grey10,
                                  //               ),
                                  //             ),
                                  //             showBadge: snapshot0.data == 0 ? false : true,
                                  //             badgeStyle: badges.BadgeStyle(badgeColor: AppThemeData.red02),
                                  //             child: Padding(
                                  //               padding: const EdgeInsets.all(12),
                                  //               child: Constant.svgPictureShow("assets/icons/headset-one.svg", null, 20, 20),
                                  //             ),
                                  //           ),
                                  //           SizedBox(
                                  //             width: 10,
                                  //           ),
                                  //           Text(
                                  //             "Support chat".tr,
                                  //             textAlign: TextAlign.start,
                                  //             style: TextStyle(
                                  //               color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                  //               fontSize: 16,
                                  //               fontFamily: AppThemeData.semiboldOpenSans,
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     );
                                  //   },
                                  // ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Get.to(SettingScreens());
                                    },
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Constant.svgPictureShow("assets/icons/setting-two.svg", null, 20, 20),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Settings".tr,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                                            fontSize: 16,
                                            fontFamily: AppThemeData.semiboldOpenSans,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          );
        });
  }

  void showCustomBottomSheet(themeChange, BuildContext context, MoreScreenController controller) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/bussiness_create_illustator.png',
                    width: Responsive.width(100, context),
                    height: Responsive.height(30, context),
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(
                        "assets/icons/icon_close.svg",
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ), // Add an illustration
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      "Add a business".tr,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                        fontSize: 16,
                        fontFamily: AppThemeData.boldOpenSans,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "What’s your relationship with the business you’d like to add?".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                        fontSize: 16,
                        fontFamily: AppThemeData.regularOpenSans,
                      ),
                    ),
                    SizedBox(height: 15),
                    RoundedButtonFill(
                      title: 'I’m a customer',
                      color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                      textColor: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                      onPress: () {
                        Get.back();
                        Get.to(CreateBusinessScreen(), arguments: {"asCustomerOrWorkAtBusiness": true})!.then(
                          (value) {
                            if (value == true) {
                              controller.getBusiness();
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    RoundedButtonFill(
                      title: 'I work at the business',
                      color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06,
                      textColor: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                      onPress: () {
                        Get.back();
                        Get.to(CreateBusinessScreen(), arguments: {"asCustomerOrWorkAtBusiness": false})!.then(
                          (value) {
                            if (value == true) {
                              controller.getBusiness();
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 25),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
