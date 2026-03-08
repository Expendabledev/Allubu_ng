import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/widgets/debounced_inkwell.dart';

class TermsAndConditionScreen extends StatelessWidget {
  final String? type;

  const TermsAndConditionScreen({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeChange.getThem() ? AppThemeData.greyDark10 : AppThemeData.grey10,
        centerTitle: true,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: DebouncedInkWell(
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
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: themeChange.getThem() ? AppThemeData.greyDark08 : AppThemeData.grey08,
            height: 2.0,
          ),
        ),
        title: Text(
          type == "privacy" ? "Privacy Policy".tr : "Terms & Conditions".tr.tr,
          textAlign: TextAlign.start,
          style: TextStyle(
            color: themeChange.getThem() ? AppThemeData.greyDark01 : AppThemeData.grey01,
            fontSize: 16,
            fontFamily: AppThemeData.semiboldOpenSans,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        child: SingleChildScrollView(
          child: Html(
            shrinkWrap: true,
            data: type == "privacy" ? Constant.privacyPolicy : Constant.termsAndConditions,
          ),
        ),
      ),
    );
  }
}
