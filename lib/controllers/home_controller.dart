// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';

enum Plan { WEEKLY, MONTHLY, YEARLY }

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // Private variables
  final RxInt _onboardingIndex = 0.obs;
  final Rx<Plan> _selectedPlan = Plan.WEEKLY.obs;

  // Getters
  int get onboardingIndex => _onboardingIndex.value;
  Plan get selectedPlan => _selectedPlan.value;

  // Setters
  set onboardingIndex(value) => _onboardingIndex.value = value;
  set selectedPlan(value) => _selectedPlan.value = value;
}
