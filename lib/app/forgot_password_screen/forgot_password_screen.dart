import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/forgot_password_controller.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/themes/text_field_widget.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: ForgotPasswordController(),
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
                )),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forgot Password".tr,
                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01, fontSize: 22, fontFamily: AppThemeData.semibold),
                  ),
                  Text(
                    "No worries!! We’ll send you reset instructions".tr,
                    style: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01, fontSize: 16, fontFamily: AppThemeData.regular),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextFieldWidget(
                    title: 'Email Address'.tr,
                    controller: controller.emailEditingController.value,
                    hintText: 'Enter email address'.tr,
                    prefix: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        "assets/icons/ic_mail.svg",
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  RoundedButtonFill(
                    title: "Forgot Password".tr,
                    textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                    color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02,
                    onPress: () async {
                      if (!Constant.isValidEmail(controller.emailEditingController.value.text.trim())) {
                        ShowToastDialog.showToast("Enter valid email");
                        return;
                      } else {
                        controller.forgotPassword();
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
