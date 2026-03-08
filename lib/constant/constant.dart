import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:yelpify/models/ad_setup_model.dart';
import 'package:yelpify/models/business_history_model.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/models/country_model.dart';
import 'package:yelpify/models/language_model.dart';
import 'package:yelpify/models/mail_setting.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/utils/business_history_storage.dart';
import 'package:yelpify/utils/preferences.dart';

class Constant {
  static const String emailLoginType = "email";
  static const String phoneLoginType = "phone";
  static const String googleLoginType = "google";
  static const String appleLoginType = "apple";
  static String termsAndConditions = "";
  static String privacyPolicy = "";

  static String deepLinkUrl = '';
  static String claimBusinessURL = "";
  static String defaultCountryCode = "";

  static String? apiBaseUrl = "";
  static String? apiSecureKey = "";

  static const userPlaceHolder = "assets/images/user_placeholder.svg";
  static String businessDeepLink = '/business-detail/';
  static String applicationName = 'Yelpify';
  static String jsonNotificationFileURL = '';
  static String senderId = '';

  static String mapAPIKey = "";
  static String mapType = "";
  static String appVersion = "";
  static String radios = "5000";
  static String maxBusinessCategory = "1";
  static String appColor = "";
  static String appLogo = "";
  static String checkInRadius = "5";
  static String youMightAlsoConsider = "2";
  static String sponsoredMarker = "";
  static MailSettings? mailSettings;

  static Position? currentLocation;
  static LatLng? currentLocationLatLng;
  static AdSetupModel? adSetupModel;
  static UserModel? userModel;
  static CountryModel? countryModel;

  static String placeHolderImage = "";
  static String adminEmail = "";

  static String menuItemPhotos = "menuItemPhotos";
  static String reviewPhotos = "reviewPhotos";
  static String businessPhotos = "businessPhotos";
  static String menuPhotos = "menuPhotos";
  static String checkInPhotos = "checkInPhotos";

  static String reviewIssues = "Review Issues";
  static String appUserIssues = "App/User Issues";
  static String businessIssues = "Business Issues";
  static String photoIssues = "Photo Issues";

  static Widget loader() {
    return Center(
      child: CircularProgressIndicator(color: AppThemeData.red02),
    );
  }

  static String dateToString(DateTime timestamp) {
    return DateFormat('yyyy-MM-dd').format(timestamp);
  }

  static DateTime stringToDate(String openDineTime) {
    return DateFormat('yyyy-MM-dd').parse(openDineTime);
  }

  static Widget svgPictureShow(String path, Color? color, double? height, double? width) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  static String replacePlaceholders(String template, Map<String, String> values) {
    values.forEach((key, value) {
      template = template.replaceAll('{$key}', value);
    });
    return template;
  }

  static LanguageModel getLanguage() {
    final String user = Preferences.getString(Preferences.languageCodeKey);
    Map<String, dynamic> userMap = jsonDecode(user);
    return LanguageModel.fromJson(userMap);
  }

  static int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust if the birthday hasn't occurred yet this year
    if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  static Widget showEmptyView({required String message}) {
    return Center(
      child: Text(message.tr, textAlign: TextAlign.center, style: const TextStyle(fontFamily: AppThemeData.regularOpenSans, fontSize: 16)),
    );
  }

  static String getFullAddress(place) {
    return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  }

  static String getFullAddressModel(AddressModel place) {
    return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  }

  static String getCategoryNames(List<CategoryModel>? categoryList) {
    if (categoryList == null || categoryList.isEmpty) {
      return ""; // Return empty string if list is null or empty
    }
    return categoryList.map((category) => category.name ?? "").where((name) => name.isNotEmpty).join(", ");
  }

  static Widget buildStatusText(themeChange, String status, bool isList) {
    TextStyle defaultStyle = TextStyle(
        fontSize: 12,
        color: isList
            ? themeChange.getThem()
                ? AppThemeData.greyDark02
                : AppThemeData.grey02
            : themeChange.getThem()
                ? AppThemeData.greyDark06
                : AppThemeData.grey06,
        fontFamily: AppThemeData.mediumOpenSans);
    TextStyle openStyle = TextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.greenDark02 : AppThemeData.green02, fontFamily: AppThemeData.boldOpenSans);
    TextStyle closedStyle = TextStyle(fontSize: 12, color: themeChange.getThem() ? AppThemeData.greenDark02 : AppThemeData.red02, fontFamily: AppThemeData.boldOpenSans);

    if (status.startsWith("Open until")) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Open", style: openStyle),
            TextSpan(text: " Until ${status.replaceFirst("Open until", "").trim()}", style: defaultStyle),
          ],
        ),
      );
    } else if (status.startsWith("Closed until")) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Closed", style: closedStyle),
            TextSpan(text: " until ${status.replaceFirst("Closed until", "").trim()}", style: defaultStyle),
          ],
        ),
      );
    } else if (status == "Closed") {
      return RichText(
        text: TextSpan(
          text: "Closed",
          style: closedStyle,
        ),
      );
    } else {
      return Text(status, style: defaultStyle);
    }
  }

  static String timeAgo(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    Duration difference = DateTime.now().difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} ${'seconds ago'.tr}';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${'minutes ago'.tr}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${'hours ago'.tr}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${'days ago'.tr}';
    } else {
      return DateFormat('dd MMM, yyyy').format(date); // Example: "12 Feb, 2024"
    }
  }

  String? validateEmail(String? value) {
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(pattern);
    if (value == null || value.isEmpty) {
      return "Email is Required".tr;
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email".tr;
    } else {
      return null;
    }
  }

  bool hasValidUrl(String value) {
    String pattern = r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return false;
    } else if (!regExp.hasMatch(value)) {
      return false;
    }
    return true;
  }

  static Future<DateTime?> selectPastDate(context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppThemeData.red03, // header background color
                onPrimary: AppThemeData.grey09, // header text color
                onSurface: AppThemeData.grey09, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppThemeData.grey09, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
        initialDate: DateTime.now(),
        //get today's date
        firstDate: DateTime(1800),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime.now());
    return pickedDate;
  }

  static List<String> generateSearchKeywords(String name) {
    Set<String> keywords = {};

    // Convert name to lowercase and split into words
    String lowerCaseName = name.toLowerCase();
    List<String> words = lowerCaseName.split(" ");

    // Generate substrings (n-grams) for each word
    for (String word in words) {
      for (int i = 1; i <= word.length; i++) {
        keywords.add(word.substring(0, i)); // Add partial word match
      }
    }

    // Also store full word combinations
    for (int i = 0; i < words.length; i++) {
      for (int j = i; j < words.length; j++) {
        keywords.add(words.sublist(i, j + 1).join(" "));
      }
    }

    return keywords.toList();
  }

  static String getUuid() {
    return const Uuid().v4();
  }

  static Future<String> uploadUserImageToFireStorage(File image, String filePath, String fileName) async {
    Reference upload = FirebaseStorage.instance.ref().child('$filePath/$fileName');
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl = await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static String calculateReview({required String? reviewCount, required String? reviewSum}) {
    if (0 == double.parse(reviewSum.toString()) && 0 == double.parse(reviewSum.toString())) {
      return "0";
    }
    return (double.parse(reviewSum.toString()) / double.parse(reviewCount.toString())).toStringAsFixed(1);
  }

  static String formatReviewCount(String count) {
    if (double.parse(count) >= 1000000) {
      return '${(double.parse(count) / 1000000).toStringAsFixed(0).replaceAll('.0', '')}M';
    } else if (double.parse(count) >= 1000) {
      return '${(double.parse(count) / 1000).toStringAsFixed(0).replaceAll('.0', '')}K';
    } else {
      return double.parse(count).toStringAsFixed(0);
    }
  }

  static String generateRandomCode(String collectionName, {int length = 6}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String randomPart = List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
    return "${collectionName.toUpperCase()}_$randomPart";
  }

  bool isBusinessOpenNow(Map<String, dynamic> businessHours) {
    String today = DateFormat('EEEE').format(DateTime.now()).toLowerCase(); // e.g., "monday"
    String currentTime = DateFormat('HH:mm').format(DateTime.now());

    if (businessHours[today] == "Closed") return false;

    for (String timeRange in businessHours[today]) {
      List<String> times = timeRange.split('-');
      if (currentTime.compareTo(times[0]) >= 0 && currentTime.compareTo(times[1]) <= 0) {
        return true; // Business is open
      }
    }
    return false;
  }

  static String formatTimestamp(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime date = timestamp.toDate();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(Duration(days: 1));

    DateTime dateOnly = DateTime(date.year, date.month, date.day);
    String time = DateFormat.jm().format(date); // e.g., 3:59 PM

    if (dateOnly == today) {
      return '${'Today'.tr} $time';
    } else if (dateOnly == yesterday) {
      return '${'Yesterday'.tr} $time';
    } else {
      String formattedDate = DateFormat('MMM d').format(date); // e.g., Apr 12
      return '$formattedDate, $time';
    }
  }

  static String getBusinessStatus(BusinessHours businessHours) {
    final now = DateTime.now();
    final today = DateFormat('EEEE').format(now).toLowerCase();
    final tomorrow = DateFormat('EEEE').format(now.add(Duration(days: 1))).toLowerCase();
    final currentTime = DateFormat('HH:mm').format(now);

    List<dynamic> todayHours = getDayHours(businessHours, today);
    List<dynamic> tomorrowHours = getDayHours(businessHours, tomorrow);

    for (var range in todayHours) {
      final times = range.split('-');
      if (times.length != 2) continue;
      final start = times[0];
      final end = times[1];

      if (currentTime.compareTo(start) >= 0 && currentTime.compareTo(end) <= 0) {
        return "Open until ${formatTimeBusiness(end)}";
      }

      if (currentTime.compareTo(start) >= 0 && currentTime.compareTo(end) <= 0) {
        return "Open until ${formatTimeBusiness(end)}";
      }

      // Overnight shift
      if (end.compareTo(start) < 0 && currentTime.compareTo(start) >= 0) {
        return "Open until ${formatTimeBusiness(end)}";
      }
    }

    for (var range in todayHours) {
      final start = range.split('-')[0];
      if (currentTime.compareTo(start) < 0) {
        return "Closed until ${formatTimeBusiness(start)}";
      }
    }

    if (tomorrowHours.isNotEmpty) {
      final start = tomorrowHours[0].split('-')[0];
      return "Closed until ${formatTimeBusiness(start)}";
    }

    return "Closed";
  }

  static String getTodaySingleTimeSlot(BusinessHours businessHours) {
    final now = DateTime.now();
    final todayKey = DateFormat('EEEE').format(now).toLowerCase();

    List<dynamic>? timeRanges;

    switch (todayKey) {
      case 'monday':
        timeRanges = businessHours.monday;
        break;
      case 'tuesday':
        timeRanges = businessHours.tuesday;
        break;
      case 'wednesday':
        timeRanges = businessHours.wednesday;
        break;
      case 'thursday':
        timeRanges = businessHours.thursday;
        break;
      case 'friday':
        timeRanges = businessHours.friday;
        break;
      case 'saturday':
        timeRanges = businessHours.saturday;
        break;
      case 'sunday':
        timeRanges = businessHours.sunday;
        break;
    }

    if (timeRanges == null || timeRanges.isEmpty) {
      return 'Closed';
    }

    // Get the first start and last end from time ranges
    String firstStart = timeRanges.first.split('-')[0];
    String lastEnd = timeRanges.last.split('-')[1];

    return '${formatTimeBusinessHours(firstStart)} - ${formatTimeBusinessHours(lastEnd)}';
  }

  static String formatTimeBusinessHours(String time24) {
    final timeParts = time24.split(':');
    if (timeParts.length != 2) return time24;

    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    final dt = DateTime(0, 0, 0, hour, minute);
    return DateFormat.jm().format(dt); // e.g., 9:00 AM
  }

  static List<dynamic> getDayHours(BusinessHours hours, String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return hours.monday ?? [];
      case 'tuesday':
        return hours.tuesday ?? [];
      case 'wednesday':
        return hours.wednesday ?? [];
      case 'thursday':
        return hours.thursday ?? [];
      case 'friday':
        return hours.friday ?? [];
      case 'saturday':
        return hours.saturday ?? [];
      case 'sunday':
        return hours.sunday ?? [];
      default:
        return [];
    }
  }

  static String formatTimeBusiness(String time24h) {
    final parts = time24h.split(':');
    if (parts.length != 2) return time24h;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    final time = TimeOfDay(hour: hour, minute: minute);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat("hh:mm a").format(dt); // e.g. "9:00 AM"
  }

  static List<String> getFormattedSlots(List<dynamic>? slots) {
    if (slots == null || slots.isEmpty) return ['Closed'];
    return slots
        .map((slot) {
          final times = slot.split('-');
          if (times.length == 2) {
            return '${formatTimeBusiness(times[0])} - ${formatTimeBusiness(times[1])}';
          }
          return '';
        })
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static Future<TimeOfDay?> pickTime({required BuildContext context, required TimeOfDay initialTime}) async {
    return await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return child!;
      },
    );
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  static bool isNumeric(String str) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(str);
  }

  static String capitalizeFirst(String text) {
    if (text.isEmpty) return '';
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static double calculateDistance(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    const earthRadius = 6371; // Earth's radius in KM

    final dLat = _toRadians(endLatitude - startLatitude);
    final dLon = _toRadians(endLongitude - startLongitude);

    final a = sin(dLat / 2) * sin(dLat / 2) + cos(_toRadians(startLatitude)) * cos(_toRadians(endLatitude)) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    final distance = earthRadius * c;
    return distance; // in kilometers
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  static Timestamp? addDayInTimestamp({required String? days, required Timestamp date}) {
    if (days?.isNotEmpty == true && days != '0') {
      Timestamp now = date;
      DateTime dateTime = now.toDate();
      DateTime newDateTime = dateTime.add(Duration(days: int.parse(days!)));
      Timestamp newTimestamp = Timestamp.fromDate(newDateTime);
      return newTimestamp;
    } else {
      return null;
    }
  }

  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
      r"[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?"
      r"(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
    );
    return emailRegex.hasMatch(email);
  }

  static bool isPlanExpire() {
    bool isPlanExpire = true;
    if (userModel?.subscription?.expireDate == null) {
      isPlanExpire = true;
    } else {
      DateTime? expiryDate = userModel!.subscription?.expireDate?.toDate();
      isPlanExpire = expiryDate!.isBefore(DateTime.now());
    }
    return isPlanExpire;
  }

  static String formatTimestampToDateTime(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('dd MMM yyyy • hh:mm a').format(date);
  }

  static Future<void> setRecentBusiness(BusinessModel businessModel) async {
    BusinessHistoryModel model = BusinessHistoryModel();
    model.id = Constant.getUuid();
    model.business = businessModel;
    model.createdAt = Timestamp.now();

    BusinessHistoryStorage.addCategoryHistoryItem(model);
  }

  static Future<void> launchUrlOfClimBusiness(BuildContext context, String url) async {
    final theme = Theme.of(context);
    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: AppThemeData.red03,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: theme.colorScheme.surface,
          preferredControlTintColor: theme.colorScheme.onSurface,
          barCollapsingEnabled: true,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
      debugPrint(e.toString());
    }
  }
}
