import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:allubmarket/themes/app_them_data.dart';
import 'package:allubmarket/themes/responsive.dart';
import 'package:allubmarket/utils/dark_theme_provider.dart';

class CustomDialogBox extends StatelessWidget {
  final String title, descriptions, positiveString, negativeString;
  final Widget? img;
  final Function() positiveClick;
  final Function() negativeClick;

  const CustomDialogBox(
      {super.key,
      required this.title,
      required this.descriptions,
      required this.img,
      required this.positiveClick,
      required this.negativeClick,
      required this.positiveString,
      required this.negativeString});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Container contentBox(context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: themeChange.getThem()
              ? AppThemeData.greyDark10
              : AppThemeData.grey10,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          img ?? const SizedBox(),
          const SizedBox(
            height: 20,
          ),
          Visibility(
            visible: title.isNotEmpty,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppThemeData.semiboldOpenSans,
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark01
                      : AppThemeData.grey01),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Visibility(
            visible: descriptions.isNotEmpty,
            child: Text(
              descriptions,
              style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppThemeData.regular,
                  color: themeChange.getThem()
                      ? AppThemeData.greyDark02
                      : AppThemeData.grey02),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    negativeClick();
                  },
                  child: Container(
                    width: Responsive.width(100, context),
                    height: Responsive.height(5, context),
                    decoration: ShapeDecoration(
                      color: themeChange.getThem()
                          ? AppThemeData.greyDark09
                          : AppThemeData.grey09,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          negativeString.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppThemeData.medium,
                            color: themeChange.getThem()
                                ? AppThemeData.greyDark01
                                : AppThemeData.grey01,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    positiveClick();
                  },
                  child: Container(
                    width: Responsive.width(100, context),
                    height: Responsive.height(5, context),
                    decoration: ShapeDecoration(
                      color: AppThemeData.red02,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          positiveString.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: AppThemeData.medium,
                            color: AppThemeData.grey10,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
