// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/services/local_storage.dart';
import 'package:live_flight_tracker/views/home_view.dart';
import 'package:live_flight_tracker/views/onboarding_view.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/services/store_config.dart';

enum PlanType { FREE, BASIC, PROFESSIONAL, BUSINESS }

// ignore: unused_element
Future<void> _configureSDK() async {
  // Enable debug logs before calling `configure`.
  if (kReleaseMode) {
    await Purchases.setLogLevel(LogLevel.info);
  } else {
    await Purchases.setLogLevel(LogLevel.debug);
  }

  PurchasesConfiguration configuration;

  configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);

  await Purchases.configure(configuration);
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Load environment variables
  await FlutterConfig.loadEnvVariables();

  // Initialize storage
  await GetStorage.init();

  // Configure store for in-app purchase
  if (Platform.isIOS) {
    StoreConfig(
      store: Store.appStore,
      apiKey: appleApiKey,
    );
  }

  await _configureSDK();

  // Dependency injection
  Get.lazyPut(() => HomeController());
  Get.put(SettingsController());

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // whenever your initialization is completed, remove the splash screen:
  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Ubuntu',
        scaffoldBackgroundColor: bgColor,
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        // appBarTheme: const AppBarTheme(
        //   titleTextStyle: TextStyle(
        //     color: whiteColor,
        //     fontSize: 18,
        //     fontWeight: FontWeight.w600,
        //   ),
        // ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      navigatorKey: NavigatorKey.navigatorKey,
      home: LocalStorage.getData(isOnboardingDone, KeyType.BOOL)
          ? const HomeView()
          : const OnboardingView(),
    );
  }
}
