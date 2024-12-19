import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

class NavigatorKey {
  NavigatorKey._();

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static String? previousRoute;
  static String? currentRoute;

  static Future<dynamic>? push(dynamic route, {String? routeName}) {
    previousRoute = Get.currentRoute; // Update GetX's previousRoute
    currentRoute = routeName; // Update GetX's currentRoute

    return navigatorKey.currentState?.push(PageTransition(
      child: route,
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 250),
    ));
  }

  static Future<dynamic>? pushReplacement(dynamic route, {String? routeName}) {
    previousRoute = Get.currentRoute; // Update GetX's previousRoute
    currentRoute = routeName; // Update GetX's currentRoute

    return navigatorKey.currentState?.pushReplacement(PageTransition(
      child: route,
      type: PageTransitionType.fade,
      duration: const Duration(milliseconds: 250),
    ));
  }

  static Future<dynamic>? pushAndRemoveUntil(dynamic route,
      {String? routeName}) {
    previousRoute = Get.currentRoute; // Update GetX's previousRoute
    currentRoute = routeName; // Update GetX's currentRoute

    return navigatorKey.currentState?.pushAndRemoveUntil(
        PageTransition(
          child: route,
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 250),
        ),
        (route) => false);
  }

  static bool canPop() {
    return navigatorKey.currentState?.canPop() ?? false;
  }

  static void pop([dynamic arguments]) {
    currentRoute = previousRoute;
    return navigatorKey.currentState?.pop(arguments);
  }
}
