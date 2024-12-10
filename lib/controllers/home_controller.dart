// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Plan { WEEKLY, MONTHLY, YEARLY }

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final pageController = PageController();

  // Private variables
  final RxInt _onboardingIndex = 0.obs;
  final RxInt _homeIndex = 0.obs;
  final Rx<Plan> _selectedPlan = Plan.WEEKLY.obs;

  // Getters
  int get onboardingIndex => _onboardingIndex.value;
  int get homeIndex => _homeIndex.value;
  Plan get selectedPlan => _selectedPlan.value;

  // Setters
  set onboardingIndex(value) => _onboardingIndex.value = value;
  set homeIndex(value) => _homeIndex.value = value;
  set selectedPlan(value) => _selectedPlan.value = value;
}
