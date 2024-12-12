// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum Plan { WEEKLY, MONTHLY, YEARLY }

enum Speed { MPH, KPH, KNOTS }

enum Distance { MILES, KM, NM }

enum Altitude { FEET, METER }

enum MapMode { Dark, Light, Satelite }

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final pageController = PageController();

  // Private variables
  final RxInt _onboardingIndex = 0.obs;
  final RxInt _homeIndex = 0.obs;
  final Rx<Plan> _selectedPlan = Plan.WEEKLY.obs;
  final Rx<Speed> _selectedSpeed = Speed.KPH.obs;
  final Rx<Distance> _selectedDistance = Distance.KM.obs;
  final Rx<Altitude> _selectedAltitude = Altitude.METER.obs;
  final Rx<MapMode> _selectedMapMode = MapMode.Dark.obs;

  // Getters
  int get onboardingIndex => _onboardingIndex.value;
  int get homeIndex => _homeIndex.value;
  Plan get selectedPlan => _selectedPlan.value;
  Speed get selectedSpeed => _selectedSpeed.value;
  Distance get selectedDistance => _selectedDistance.value;
  Altitude get selectedAltitude => _selectedAltitude.value;
  MapMode get selectedMapMode => _selectedMapMode.value;

  // Setters
  set onboardingIndex(value) => _onboardingIndex.value = value;
  set homeIndex(value) => _homeIndex.value = value;
  set selectedPlan(value) => _selectedPlan.value = value;
  set selectedSpeed(value) => _selectedSpeed.value = value;
  set selectedDistance(value) => _selectedDistance.value = value;
  set selectedAltitude(value) => _selectedAltitude.value = value;
  set selectedMapMode(value) => _selectedMapMode.value = value;
}
