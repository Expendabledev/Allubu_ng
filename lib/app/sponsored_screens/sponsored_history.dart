import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/controller/sponsored_history_controller.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/sponsored_request_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/themes/round_button_fill.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/widgets/business_view.dart';

class SponsoredHistory extends StatelessWidget {
  const SponsoredHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: SponsoredHistoryController(),
        builder: (controller) {
          return DefaultTabController(
            length: 5, // Number of tabs
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
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
                            themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey01,
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
                            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                            fontSize: 14,
                            fontFamily: AppThemeData.semiboldOpenSans,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(120),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: DropdownButtonFormField<BusinessModel>(
                          hint: Text("Select Business"),
                          initialValue: controller.selectedBusiness.value.id == null ? null : controller.selectedBusiness.value,
                          onChanged: (BusinessModel? newValue) {
                            controller.selectedBusiness.value = newValue!;
                            controller.getSponsoredHistory();
                          },
                          items: controller.businessList.map((BusinessModel reason) {
                            return DropdownMenuItem<BusinessModel>(
                              value: reason,
                              child: Text(reason.businessName.toString()),
                            );
                          }).toList(),
                          style: TextStyle(color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01, fontFamily: AppThemeData.medium),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: themeChange.getThem() ? AppThemeData.greyDark06 : AppThemeData.grey06, width: 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TabBar(
                        tabAlignment: TabAlignment.start,
                        labelColor: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                        unselectedLabelColor: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                        labelStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: AppThemeData.semiboldOpenSans,
                          color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
                        ),
                        unselectedLabelStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: AppThemeData.regularOpenSans,
                          color: themeChange.getThem() ? AppThemeData.greyDark04 : AppThemeData.grey04,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        // Makes the indicator full width
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 4, color: AppThemeData.red02), // Full-width red indicator
                        ),
                        isScrollable: true,
                        tabs: [
                          Tab(text: "Running"),
                          Tab(text: "Accepted"),
                          Tab(text: "Pending"),
                          Tab(text: "Expired"),
                          Tab(text: "Cancelled"),
                        ],
                      )
                    ],
                  ),
                ),
                title: Text(
                  "History".tr,
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
                  : TabBarView(
                      children: [
                        showListView(themeChange, controller.runningHistoryList, controller),
                        showListView(themeChange, controller.acceptedHistoryList, controller),
                        showListView(themeChange, controller.pendingHistoryList, controller),
                        showListView(themeChange, controller.expiredHistoryList, controller),
                        showListView(themeChange, controller.canceledHistoryList, controller),
                      ],
                    ),
            ),
          );
        });
  }

  Widget showListView(themeChange, List<SponsoredRequestModel> sponsoredHistoryList, SponsoredHistoryController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: sponsoredHistoryList.isEmpty
          ? Constant.showEmptyView(message: "Data not found".tr)
          : ListView.builder(
              itemCount: sponsoredHistoryList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                SponsoredRequestModel model = sponsoredHistoryList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "#${model.id!}".tr,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: themeChange.getThem() ? AppThemeData.greyDark03 : AppThemeData.grey03,
                                    fontSize: 14,
                                    fontFamily: AppThemeData.regularOpenSans,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    Clipboard.setData(ClipboardData(text: "${model.id}")).then((_) {
                                      ShowToastDialog.showToast("ID Copied");
                                    });
                                  },
                                  child: Icon(Icons.copy))
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BusinessView(
                            businessId: model.businessId.toString(),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "Start Date : ".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                                  fontSize: 14,
                                  fontFamily: AppThemeData.mediumOpenSans,
                                ),
                              ),
                              Text(
                                Constant.formatTimestampToDateTime(model.startDate!),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                                  fontSize: 14,
                                  fontFamily: AppThemeData.boldOpenSans,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "End Date : ".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                                  fontSize: 14,
                                  fontFamily: AppThemeData.mediumOpenSans,
                                ),
                              ),
                              Text(
                                Constant.formatTimestampToDateTime(model.endDate!),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                                  fontSize: 14,
                                  fontFamily: AppThemeData.boldOpenSans,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                "Status : ".tr,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.greyDark02 : AppThemeData.grey02,
                                  fontSize: 14,
                                  fontFamily: AppThemeData.mediumOpenSans,
                                ),
                              ),
                              Text(
                                Constant.capitalizeFirst(model.status.toString()),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: themeChange.getThem() ? AppThemeData.red02 : AppThemeData.red02,
                                  fontSize: 14,
                                  fontFamily: AppThemeData.boldOpenSans,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          model.status == "pending" || model.status == "accepted"
                              ? RoundedButtonFill(
                                  title: 'Cansel'.tr,
                                  height: 5,
                                  textColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
                                  color: themeChange.getThem() ? AppThemeData.redDark02 : AppThemeData.red02,
                                  onPress: () {},
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
