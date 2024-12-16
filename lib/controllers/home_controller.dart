// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_flight_tracker/config/images.dart';

enum Plan { WEEKLY, MONTHLY, YEARLY }

enum Speed { MPH, KPH, KNOTS }

enum Distance { MILES, KM, NM }

enum Altitude { FEET, METER }

enum MapMode { Dark, Light, Satelite }

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final pageController = PageController();

  // Search flight input controllers
  final departingFrom = TextEditingController();
  final arrivingAt = TextEditingController();
  final flightCode = TextEditingController();
  final flightNumber = TextEditingController();
  final date = TextEditingController();

  void setSelectedDate() {
    date.text = DateFormat("EEE, d MMM y")
        .format(selectedDates.isEmpty ? DateTime.now() : selectedDates.first);
  }

  List<Map<String, dynamic>> flightDetails = [
    {
      'flightName': 'Cream White',
      'flightColor': Colors.white,
      'flightImage': white
    },
    {
      'flightName': 'Ocean Blue',
      'flightColor': Colors.blue,
      'flightImage': blue
    },
    {'flightName': 'Ruby Red', 'flightColor': Colors.red, 'flightImage': red},
    {
      'flightName': 'Sunset Orange',
      'flightColor': Colors.orange,
      'flightImage': orange
    },
    {
      'flightName': 'Petal Pink',
      'flightColor': Colors.pink,
      'flightImage': pink
    },
    {
      'flightName': 'Seafoam Green',
      'flightColor': Colors.green,
      'flightImage': green
    },
    {
      'flightName': 'Sunflower Yellow',
      'flightColor': Colors.yellow,
      'flightImage': yellow
    },
  ];

  // Private variables
  final RxInt _onboardingIndex = 0.obs;
  final RxInt _homeIndex = 0.obs;
  final RxInt _selectedPlaneIndex = 0.obs;
  final RxInt _searchToggleIndex = 0.obs;
  final Rx<Plan> _selectedPlan = Plan.WEEKLY.obs;
  final Rx<Speed> _selectedSpeed = Speed.KPH.obs;
  final Rx<Distance> _selectedDistance = Distance.KM.obs;
  final Rx<Altitude> _selectedAltitude = Altitude.METER.obs;
  final Rx<MapMode> _selectedMapMode = MapMode.Dark.obs;

  final RxList<DateTime> _selectedDates = <DateTime>[].obs;

  // Getters
  int get onboardingIndex => _onboardingIndex.value;
  int get homeIndex => _homeIndex.value;
  int get selectedPlaneIndex => _selectedPlaneIndex.value;
  int get searchToggleIndex => _searchToggleIndex.value;
  Plan get selectedPlan => _selectedPlan.value;
  Speed get selectedSpeed => _selectedSpeed.value;
  Distance get selectedDistance => _selectedDistance.value;
  Altitude get selectedAltitude => _selectedAltitude.value;
  MapMode get selectedMapMode => _selectedMapMode.value;

  List<DateTime> get selectedDates => _selectedDates;

  // Setters
  set onboardingIndex(value) => _onboardingIndex.value = value;
  set homeIndex(value) => _homeIndex.value = value;
  set selectedPlaneIndex(value) => _selectedPlaneIndex.value = value;
  set searchToggleIndex(value) => _searchToggleIndex.value = value;
  set selectedPlan(value) => _selectedPlan.value = value;
  set selectedSpeed(value) => _selectedSpeed.value = value;
  set selectedDistance(value) => _selectedDistance.value = value;
  set selectedAltitude(value) => _selectedAltitude.value = value;
  set selectedMapMode(value) => _selectedMapMode.value = value;

  set selectedDates(value) => _selectedDates.value = value;
}
