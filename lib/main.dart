import 'dart:convert';
import 'package:app_links/app_links.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/app/business_details_screen/business_details_screen.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/models/language_model.dart';
import 'package:yelpify/service/ad_manager.dart';
import 'package:yelpify/themes/styles.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';
import 'package:yelpify/utils/fire_store_utils.dart';
import 'package:yelpify/utils/preferences.dart';
import 'app/splash_screen.dart';
import 'controller/global_setting_controller.dart';
import 'firebase_options.dart';
import 'service/localization_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AdManager.initialize();
  FirebaseApp firebaseApp = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (currentEnv == FirebaseEnv.defaultDb) {
    FireStoreUtils.instance.init(firebaseApp);
  } else {
    FireStoreUtils.instance.init(firebaseApp,
        databaseId: 'staging'); // pass databaseId if named DB
  }
  await FirebaseAppCheck.instance.activate(
    providerWeb: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  );
  await Preferences.initPref();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _setInitialLanguage();
    getCurrentAppTheme();
    WidgetsBinding.instance.addObserver(this);
    _listenDeepLinks();
  }

  Future<void> _setInitialLanguage() async {
    if (Preferences.getString(Preferences.languageCodeKey)
        .toString()
        .isNotEmpty) {
      LanguageModel languageModel = Constant.getLanguage();
      LocalizationService().changeLocale(languageModel.slug.toString());
    } else {
      LanguageModel languageModel =
          LanguageModel(slug: "en", isRtl: false, title: "English");
      Preferences.setString(
          Preferences.languageCodeKey, jsonEncode(languageModel.toJson()));
    }
  }

  void _listenDeepLinks() {
    // Listen for incoming deep links when the app is already running
    _appLinks.uriLinkStream.listen((Uri uri) {
      _handleDeepLink(uri);
    });

    // Check for initial deep link if app is launched via deep link
    _appLinks.getInitialLink().then((Uri? initialLink) {
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    });
  }

  Future<void> _handleDeepLink(Uri uri) async {
    debugPrint("Received deep link: [38;5;10m");
    if (uri.pathSegments.isNotEmpty) {
      if (uri.pathSegments.contains('business-detail')) {
        String businessId = uri.pathSegments[1];
        final value = await FireStoreUtils.getBusinessById(businessId);
        if (value != null) {
          Get.to(BusinessDetailsScreen(), arguments: {"businessModel": value});
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => themeChangeProvider,
      child: Consumer<DarkThemeProvider>(
        builder: (context, value, child) {
          return GetMaterialApp(
            title: 'Yelpify'.tr,
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(
                themeChangeProvider.darkTheme == 0
                    ? true
                    : themeChangeProvider.darkTheme == 1
                        ? false
                        : false,
                context),
            localizationsDelegates: const [
              CountryLocalizations.delegate,
            ],
            locale: LocalizationService.locale,
            fallbackLocale: LocalizationService.locale,
            translations: LocalizationService(),
            builder: EasyLoading.init(),
            home: GetBuilder<GlobalSettingController>(
              init: GlobalSettingController(),
              builder: (context) => const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
