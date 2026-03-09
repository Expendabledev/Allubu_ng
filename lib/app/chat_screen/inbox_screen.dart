import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/widgets/debounced_inkwell.dart';
import 'package:allubmarket/app/chat_screen/user_chat_screen.dart';
import 'package:allubmarket/constant/collection_name.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/inbox_controller.dart';
import 'package:allubmarket/models/inbox_model.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/widgets/chat_user_view.dart';
import 'package:allubmarket/widgets/firebase_pagination/src/firestore_pagination.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: InboxController(),
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem()
                  ? AppThemeData.greyDark10
                  : AppThemeData.grey10,
              centerTitle: true,
              leadingWidth: 120,
              leading: DebouncedInkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/icon_left.svg",
                      colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          BlendMode.srcIn),
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark08
                      : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              title: Text(
                "Inbox".tr,
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
                : FirestorePagination(
                    scrollDirection: Axis.vertical,
                    query: FireStoreUtils.fireStore
                        .collection(CollectionName.userChat)
                        .doc(controller.senderUserModel.value.id)
                        .collection("inbox")
                        .orderBy("timestamp", descending: true),
                    isLive: true,
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    shrinkWrap: true,
                    reverse: true,
                    onEmpty: Constant.showEmptyView(
                        message: "No conversion found".tr),
                    itemBuilder: (context, documentSnapshots, index) {
                      InboxModel inboxModel = InboxModel.fromJson(
                          documentSnapshots[index].data()
                              as Map<String, dynamic>);
                      if (inboxModel.senderId == "admin1234567890" ||
                          inboxModel.receiverId == "admin1234567890") {
                        return const SizedBox(); // Return empty widget (hides the item)
                      }

                      return Container(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, top: 06, bottom: 06),
                          child: DebouncedInkWell(
                            onTap: () async {
                              ShowToastDialog.showLoader("Please wait".tr);
                              await FireStoreUtils.getUserProfile(
                                      controller.senderUserModel.value.id ==
                                              inboxModel.senderId.toString()
                                          ? inboxModel.receiverId.toString()
                                          : inboxModel.senderId.toString())
                                  .then((value) {
                                ShowToastDialog.closeLoader();
                                UserModel userModel = value!;
                                Get.to(const UserChatScreen(),
                                    arguments: {"receiverModel": userModel});
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeChange.getThem()
                                    ? AppThemeData.greyDark10
                                    : AppThemeData.grey10,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: ChatUserView(
                                          userId: controller.senderUserModel
                                                      .value.id ==
                                                  inboxModel.senderId.toString()
                                              ? inboxModel.receiverId.toString()
                                              : inboxModel.senderId.toString(),
                                          lastMessage:
                                              inboxModel.lastMessage.toString(),
                                        )),
                                        Text(
                                          Constant.timeAgo(
                                              inboxModel.timestamp!),
                                          style: TextStyle(
                                            color: themeChange.getThem()
                                                ? AppThemeData.greyDark01
                                                : AppThemeData.grey01,
                                            fontSize: 14,
                                            fontFamily:
                                                AppThemeData.regularOpenSans,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    },
                  ),
          );
        });
  }
}
