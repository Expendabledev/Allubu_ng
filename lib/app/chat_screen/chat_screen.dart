import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/collection_name.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/controller/chat_controller.dart';
import 'package:yelpify/models/conversation_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/network_image_widget.dart';
import 'package:yelpify/widgets/firebase_pagination/src/firestore_pagination.dart';
import 'package:yelpify/widgets/firebase_pagination/src/models/view_type.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ChatController(),
        dispose: (state) {
          if (state.controller != null) {
            state.controller!.stopListeningToUnreadChats();
          }
        },
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
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
                      colorFilter: ColorFilter.mode(themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, BlendMode.srcIn),
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
                  height: 2.0,
                ),
              ),
              title: Text(
                "${controller.isSender.value == "business" ? controller.userModel.value.fullName() : controller.businessModel.value.businessName}".tr,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                  fontSize: 16,
                  fontFamily: AppThemeData.semiboldOpenSans,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: FirestorePagination(
                        controller: controller.scrollController,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, documentSnapshots, index) {
                          ConversationModel inboxModel = ConversationModel.fromJson(documentSnapshots[index].data() as Map<String, dynamic>);

                          return chatItemView(
                            themeChange,
                            controller.isSender.value == "business"
                                ? inboxModel.senderId == controller.businessModel.value.id
                                : inboxModel.senderId == FireStoreUtils.getCurrentUid(),
                            inboxModel,
                          );
                        },
                        onEmpty: Constant.showEmptyView(message: "No Conversion found".tr),
                        // orderBy is compulsory to enable pagination
                        reverse: true,
                        query: FireStoreUtils.fireStore
                            .collection(CollectionName.projectRequest)
                            .doc(controller.projectModel.value.id)
                            .collection("chat")
                            .where("businessId", isEqualTo: controller.businessModel.value.id)
                            .orderBy('createdAt', descending: true),
                        isLive: true,
                        viewType: ViewType.list,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: TextFieldWidget(
                      controller: controller.messageTextFieldController.value,
                      hintText: 'Send a message'.tr,
                      suffix: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                            onTap: () {
                              controller.sendMessage();
                            },
                            child: Icon(Icons.send)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget chatItemView(themeChange, bool isMe, ConversationModel data) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: isMe
          ? Align(
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  data.messageType == "text"
                      ? Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                            color: AppThemeData.red02,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          child: Text(
                            data.message.toString(),
                            style: const TextStyle(
                              fontFamily: AppThemeData.medium,
                              fontSize: 16,
                              color: AppThemeData.grey10,
                            ),
                          ),
                        )
                      : ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomLeft: Radius.circular(12)),
                          child: Stack(alignment: Alignment.center, children: [
                            GestureDetector(
                              onTap: () {},
                              child: Hero(
                                tag: data.imageUrl.toString(),
                                child: NetworkImageWidget(
                                  imageUrl: data.imageUrl.toString(),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ]),
                        ),
                  const SizedBox(height: 5),
                  Text(
                    Constant.formatTimestamp(data.createdAt!),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    data.messageType == "text"
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                              color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Text(
                              data.message.toString(),
                              style: TextStyle(
                                fontFamily: AppThemeData.medium,
                                fontSize: 16,
                                color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                              ),
                            ),
                          )
                        : ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 50,
                              maxWidth: 200,
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                              child: Stack(alignment: Alignment.center, children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Hero(
                                    tag: data.imageUrl.toString(),
                                    child: NetworkImageWidget(
                                      imageUrl: data.imageUrl.toString(),
                                    ),
                                  ),
                                ),
                              ]),
                            ))
                  ],
                ),
                const SizedBox(height: 5),
                Text(Constant.formatTimestamp(data.createdAt!), style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
    );
  }
}
