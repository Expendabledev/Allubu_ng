import 'package:flutter/material.dart';
import 'package:yelpify/themes/app_them_data.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme ? AppThemeData.surfaceDark50 : AppThemeData.surface50,
      primaryColor: isDarkTheme ? AppThemeData.redDark03 : AppThemeData.red03,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      timePickerTheme: TimePickerThemeData(
        backgroundColor: isDarkTheme ? AppThemeData.greyDark10 : AppThemeData.grey10,
        dialTextStyle: TextStyle(fontWeight: FontWeight.bold, color: isDarkTheme ? AppThemeData.greyDark01 : AppThemeData.grey01),
        dialTextColor: isDarkTheme ? AppThemeData.greyDark01 : AppThemeData.grey01,
        hourMinuteTextColor: isDarkTheme ? AppThemeData.greyDark01 : AppThemeData.grey01,
        dayPeriodTextColor: isDarkTheme ? AppThemeData.greyDark01 : AppThemeData.grey01,
      ),
    );
  }
}
