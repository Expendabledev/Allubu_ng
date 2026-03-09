import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/controller/user_view_controller.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';
import 'package:allubmarket/utils/network_image_widget.dart';

class UserView extends StatelessWidget {
  final String userId;
  final UserViewController userController = Get.put(UserViewController());

  UserView({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    userController.fetchUser(userId); // Fetch user only if not already in cache
    return Obx(() {
      if (!userController.userMap.containsKey(userId)) {
        return Center(child: CircularProgressIndicator());
      }
      UserModel userModel = userController.userMap[userId]!;
      return Row(
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: ClipOval(
              child:
                  NetworkImageWidget(imageUrl: userModel.profilePic.toString()),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.fullName(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark02
                        : AppThemeData.grey02,
                    fontSize: 16,
                    fontFamily: AppThemeData.boldOpenSans,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
