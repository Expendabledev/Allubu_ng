import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/app/terms_and_condition/terms_and_condition_screen.dart';
import 'package:allubmarket/app/user_subscriotion_screen/user_subscription_history_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/controller/user_subscription_controller.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/round_button_fill.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';

class UserSubscriptionScreen extends StatelessWidget {
  const UserSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
      init: UserSubscriptionController(),
      autoRemove: true,
      dispose: (state) {
        state.controller!.resetPendingPurchase();
      },
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: themeChange.getThem()
                ? AppThemeData.greyDark10
                : AppThemeData.grey10,
            centerTitle: true,
            leadingWidth: 120,
            leading: InkWell(
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
              "Subscription".tr,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: themeChange.getThem()
                    ? AppThemeData.greyDark01
                    : AppThemeData.grey01,
                fontSize: 16,
                fontFamily: AppThemeData.semiboldOpenSans,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InkWell(
                  onTap: () {
                    Get.to(UserSubscriptionHistoryScreen());
                  },
                  child: Icon(
                    Icons.history,
                    color: themeChange.getThem()
                        ? AppThemeData.greyDark01
                        : AppThemeData.grey01,
                  ),
                ),
              )
            ],
          ),
          body: controller.isLoading.value
              ? Constant.loader()
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Upgrade Your Business".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          fontSize: 20,
                          fontFamily: AppThemeData.boldOpenSans,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'boost_visibility'.trParams({
                          'appName': Constant.applicationName,
                        }).tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: themeChange.getThem()
                              ? AppThemeData.greyDark01
                              : AppThemeData.grey01,
                          fontSize: 14,
                          fontFamily: AppThemeData.regularOpenSans,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Expanded(
                        child: controller.products.isEmpty
                            ? Constant.showEmptyView(
                                message: "Subscription plan not found")
                            : ListView.builder(
                                itemCount: controller.products.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  ProductDetails product =
                                      controller.products[index];
                                  return Obx(
                                    () => Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color:
                                            controller.selectedProduct.value ==
                                                    product
                                                ? AppThemeData.red03
                                                : themeChange.getThem()
                                                    ? AppThemeData.greyDark10
                                                    : AppThemeData.grey10,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14)),
                                        border: Border.all(
                                          color: controller
                                                      .selectedProduct.value ==
                                                  product
                                              ? AppThemeData.red01
                                              : themeChange.getThem()
                                                  ? AppThemeData.greyDark06
                                                  : AppThemeData.grey06,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            controller.selectedProduct.value =
                                                product;
                                          },
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      product.title.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .greyDark03
                                                            : AppThemeData
                                                                .grey03,
                                                        fontSize: 14,
                                                        fontFamily: AppThemeData
                                                            .mediumOpenSans,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "${product.price} / "
                                                              .tr,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .greyDark01
                                                                : AppThemeData
                                                                    .grey01,
                                                            fontSize: 20,
                                                            fontFamily:
                                                                AppThemeData
                                                                    .boldOpenSans,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${controller.getSubscriptionModel(product.id).duration} Days"
                                                              .tr,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: themeChange
                                                                    .getThem()
                                                                ? AppThemeData
                                                                    .greyDark01
                                                                : AppThemeData
                                                                    .grey01,
                                                            fontSize: 12,
                                                            fontFamily: AppThemeData
                                                                .mediumOpenSans,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "✅ Ad-free experience".tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: themeChange
                                                                .getThem()
                                                            ? AppThemeData
                                                                .greyDark01
                                                            : AppThemeData
                                                                .grey01,
                                                        fontSize: 14,
                                                        fontFamily: AppThemeData
                                                            .semiboldOpenSans,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Obx(
                                                () => Radio(
                                                  value: controller
                                                      .selectedProduct.value,
                                                  groupValue: product,
                                                  activeColor:
                                                      AppThemeData.red02,
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  onChanged: (value) {
                                                    controller.selectedProduct
                                                        .value = product;
                                                  },
                                                ),
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
                    ],
                  ),
                ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: 'agree_proceeding'.trParams({
                        'appName': Constant.applicationName,
                      }).tr,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppThemeData.regularOpenSans,
                        color: themeChange.getThem()
                            ? AppThemeData.greyDark04
                            : AppThemeData.grey04,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(
                                  const TermsAndConditionScreen(type: "terms"));
                            },
                          text: 'Terms of Service'.tr,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.tealDark02
                                : AppThemeData.teal02,
                            fontSize: 12,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: 'and'.tr,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: AppThemeData.regularOpenSans,
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark04
                                : AppThemeData.grey04,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(const TermsAndConditionScreen(
                                  type: "privacy"));
                            },
                          text: " ${" Privacy Policy.".tr} ",
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.tealDark02
                                : AppThemeData.teal02,
                            fontSize: 12,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text:
                              'subscriptions auto-renew unless canceled at least 24 hours before the end of the current period.'
                                  .tr,
                          style: TextStyle(
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark04
                                : AppThemeData.grey04,
                            fontSize: 12,
                            fontFamily: AppThemeData.regularOpenSans,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                RoundedButtonFill(
                  title: 'Purchase Plan'.tr,
                  height: 5,
                  textColor: themeChange.getThem()
                      ? AppThemeData.greyDark10
                      : AppThemeData.grey10,
                  color: themeChange.getThem()
                      ? AppThemeData.redDark02
                      : AppThemeData.red02,
                  onPress: () {
                    if (controller.selectedProduct.value == null) {
                      ShowToastDialog.showToast("Please select plan");
                    } else {
                      controller.subscribeTo(controller.selectedProduct.value!);
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
