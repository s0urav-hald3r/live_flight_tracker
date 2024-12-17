// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/config/images.dart';
import 'package:live_flight_tracker/models/flight_model.dart';
import 'package:live_flight_tracker/models/place_search_model.dart';
import 'package:live_flight_tracker/services/dio_client.dart';
import 'package:live_flight_tracker/services/local_storage.dart';

enum Plan { WEEKLY, MONTHLY, YEARLY }

enum Speed { MPH, KPH, KNOTS }

enum Distance { MILES, KM, NM }

enum Altitude { FEET, METER }

enum MapMode { Dark, Light, Satelite }

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  final _dioClient = DioClient();

  @override
  void onInit() {
    super.onInit();
    turnOnCompass = LocalStorage.getData(isTurnOnCompass, KeyType.BOOL);
  }

  final pageController = PageController();

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
      'flightImage': whitePlane
    },
    {
      'flightName': 'Ocean Blue',
      'flightColor': Colors.blue,
      'flightImage': bluePlane
    },
    {
      'flightName': 'Ruby Red',
      'flightColor': Colors.red,
      'flightImage': redPlane
    },
    {
      'flightName': 'Sunset Orange',
      'flightColor': Colors.orange,
      'flightImage': orangePlane
    },
    {
      'flightName': 'Petal Pink',
      'flightColor': Colors.pink,
      'flightImage': pinkPlane
    },
    {
      'flightName': 'Seafoam Green',
      'flightColor': Colors.green,
      'flightImage': greenPlane
    },
    {
      'flightName': 'Sunflower Yellow',
      'flightColor': Colors.yellow,
      'flightImage': yellowPlane
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
  final RxBool _turnOnCompass = true.obs;

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
  bool get turnOnCompass => _turnOnCompass.value;

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
  set turnOnCompass(value) => _turnOnCompass.value = value;

  set selectedDates(value) => _selectedDates.value = value;

  /// [----------------------------------------------------------------]

  final RxBool _loadingMap = false.obs;
  final RxBool _havePermission = false.obs;
  final RxBool _isSearching = false.obs;
  final RxList<PlaceSearchModel> _searchedPlaces = <PlaceSearchModel>[].obs;

  bool get loadingMap => _loadingMap.value;
  bool get havePermission => _havePermission.value;
  bool get isSearching => _isSearching.value;
  List<PlaceSearchModel> get searchedPlaces => _searchedPlaces;

  set loadingMap(status) => _loadingMap.value = status;
  set havePermission(status) => _havePermission.value = status;
  set isSearching(status) => _isSearching.value = status;
  set searchedPlaces(value) => _searchedPlaces.value = value;

  Future<List<FlightModel>> fetchLiveFlights() async {
    final String apiKey = FlutterConfig.get('AVIAIONSTACK_API_KEY');
    final String url =
        'https://api.aviationstack.com/v1/flights?access_key=$apiKey&flight_status=active';

    try {
      final temp = <FlightModel>[];
      final response = await _dioClient.get(url);

      for (var flight in response.data['data']) {
        temp.add(FlightModel.fromJson(flight));
      }
      return temp;
    } on DioException catch (e) {
      log('DioException Error: $e');
      return [];
    } catch (e) {
      log('Unknown Error: $e');
      return [];
    }
  }
}
