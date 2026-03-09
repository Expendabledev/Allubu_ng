import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/controller/user_subscription_history_controller.dart';
import 'package:allubmarket/models/subscription_ads_history.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';

class UserSubscriptionHistoryScreen extends StatelessWidget {
  const UserSubscriptionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: UserSubscriptionHistoryController(),
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
                        "assets/icons/icon_close.svg",
                        colorFilter: ColorFilter.mode(
                          themeChange.getThem()
                              ? AppThemeData.greyDark06
                              : AppThemeData.grey01,
                          BlendMode.srcIn,
                        ),
                        width: 22,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Close".tr,
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
                "History".tr,
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
                : Column(
                    children: [
                      controller.historyList.isEmpty
                          ? Constant.showEmptyView(
                              message: "Subscription history not fond")
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: ListView.builder(
                                itemCount: controller.historyList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  SubscriptionAdsHistory subscriptionHistory =
                                      controller.historyList[index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: themeChange.getThem()
                                            ? AppThemeData.greyDark10
                                            : AppThemeData.grey10,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "#${subscriptionHistory.purchaseID!}"
                                                        .tr,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: themeChange
                                                              .getThem()
                                                          ? AppThemeData
                                                              .greyDark03
                                                          : AppThemeData.grey03,
                                                      fontSize: 14,
                                                      fontFamily: AppThemeData
                                                          .regularOpenSans,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'exp_date'.trParams({
                                                    'date':
                                                        Constant.dateToString(
                                                            subscriptionHistory
                                                                .expireDate!
                                                                .toDate()),
                                                  }).tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: themeChange.getThem()
                                                        ? AppThemeData.red02
                                                        : AppThemeData.red02,
                                                    fontSize: 14,
                                                    fontFamily: AppThemeData
                                                        .boldOpenSans,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              subscriptionHistory
                                                  .subscription!.title!.tr,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.greyDark01
                                                    : AppThemeData.grey01,
                                                fontSize: 16,
                                                fontFamily:
                                                    AppThemeData.boldOpenSans,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              Constant.formatTimestampToDateTime(
                                                      subscriptionHistory
                                                          .createdAt!)
                                                  .tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.greyDark01
                                                    : AppThemeData.grey01,
                                                fontSize: 12,
                                                fontFamily:
                                                    AppThemeData.mediumOpenSans,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'days_duration'.trParams({
                                                'days': subscriptionHistory
                                                    .subscription!.duration
                                                    .toString(),
                                              }).tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: themeChange.getThem()
                                                    ? AppThemeData.greyDark01
                                                    : AppThemeData.grey01,
                                                fontSize: 12,
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
                            )
                    ],
                  ),
          );
        });
  }
}
