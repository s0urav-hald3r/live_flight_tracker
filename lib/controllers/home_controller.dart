// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_flight_tracker/airports_data.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/config/images.dart';
import 'package:live_flight_tracker/country_data.dart';
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
  final RxList<Map<String, dynamic>> _filteredItems =
      <Map<String, dynamic>>[].obs;

  bool get loadingMap => _loadingMap.value;
  bool get havePermission => _havePermission.value;
  bool get isSearching => _isSearching.value;
  List<PlaceSearchModel> get searchedPlaces => _searchedPlaces;
  List<Map<String, dynamic>> get filteredItems => _filteredItems;

  set loadingMap(status) => _loadingMap.value = status;
  set havePermission(status) => _havePermission.value = status;
  set isSearching(status) => _isSearching.value = status;
  set searchedPlaces(value) => _searchedPlaces.value = value;
  set filteredItems(value) => _filteredItems.value = value;

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
      debugPrint('DioException Error: $e');
      return [];
    } catch (e) {
      debugPrint('Unknown Error: $e');
      return [];
    }
  }

  void setField(String field, dynamic value) {
    if (field == 'departingFrom') {
      departingFrom.text = '${value['iata']} - ${value['name']}';
    }

    if (field == 'arrivingAt') {
      arrivingAt.text = '${value['iata']} - ${value['name']}';
    }
  }

  num calculatedSpeed(num speed) {
    // as upcoming speed by default KPH
    switch (selectedSpeed) {
      case Speed.MPH:
        return speed * 0.621371;
      case Speed.KPH:
        return speed;
      case Speed.KNOTS:
        return speed * 0.539957;
    }
  }

  num calculatedAltitude(num altitude) {
    // as upcoming altitude by default METER
    switch (selectedAltitude) {
      case Altitude.FEET:
        return altitude * 3.28084;
      case Altitude.METER:
        return altitude;
    }
  }

  double haversine(String depIATA, String arrIATA) {
    if (depIATA.isEmpty || arrIATA.isEmpty) {
      return 0.0;
    }

    double lat1 = double.parse(airportsData.firstWhere(
            (airport) => airport['iata_code'] == depIATA)['latitude_deg'] ??
        '0.0');
    double long1 = double.parse(airportsData.firstWhere(
            (airport) => airport['iata_code'] == depIATA)['longitude_deg'] ??
        '0.0');

    double lat2 = double.parse(airportsData.firstWhere(
            (airport) => airport['iata_code'] == arrIATA)['latitude_deg'] ??
        '0.0');
    double long2 = double.parse(airportsData.firstWhere(
            (airport) => airport['iata_code'] == arrIATA)['longitude_deg'] ??
        '0.0');

    const R = 6371; // Earth's radius in km

    // Convert degrees to radians
    double toRadians(double degree) => degree * pi / 180;

    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(long2 - long1);

    lat1 = toRadians(lat1);
    lat2 = toRadians(lat2);

    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // as upcoming distance by default KM
    switch (selectedDistance) {
      case Distance.MILES:
        return R * c * 0.621371;
      case Distance.KM:
        return R * c;
      case Distance.NM:
        return R * c * 0.539957;
    }
  }

  String getDepCountryFlag(String depIATA) {
    String countryCode = airportsData.firstWhere(
        (airport) => airport['iata_code'] == depIATA)['iso_country'];

    return countryData.firstWhereOrNull((country) =>
            country['code'] == countryCode ||
            country['code'].contains(countryCode))?['flag'] ??
        '';
  }

  String getArrCountryFlag(String arrIATA) {
    String countryCode = airportsData.firstWhere(
        (airport) => airport['iata_code'] == arrIATA)['iso_country'];

    return countryData.firstWhereOrNull((country) =>
            country['code'] == countryCode ||
            country['code'].contains(countryCode))?['flag'] ??
        '';
  }

  String getDepCountry(String depIATA) {
    String countryCode = airportsData.firstWhere(
        (airport) => airport['iata_code'] == depIATA)['iso_country'];

    return countryData.firstWhereOrNull((country) =>
            country['code'] == countryCode ||
            country['code'].contains(countryCode))?['name'] ??
        '';
  }

  String getArrCountry(String arrIATA) {
    String countryCode = airportsData.firstWhere(
        (airport) => airport['iata_code'] == arrIATA)['iso_country'];

    return countryData.firstWhereOrNull((country) =>
            country['code'] == countryCode ||
            country['code'].contains(countryCode))?['name'] ??
        '';
  }

  double currentDistance(String depIATA, num cLat, num cLong) {
    double lat1 = double.parse(airportsData.firstWhere(
            (airport) => airport['iata_code'] == depIATA)['latitude_deg'] ??
        '0.0');
    double long1 = double.parse(airportsData.firstWhere(
            (airport) => airport['iata_code'] == depIATA)['longitude_deg'] ??
        '0.0');

    double lat2 = cLat.toDouble();
    double long2 = cLong.toDouble();

    const R = 6371; // Earth's radius in km

    // Convert degrees to radians
    double toRadians(double degree) => degree * pi / 180;

    double dLat = toRadians(lat2 - lat1);
    double dLon = toRadians(long2 - long1);

    lat1 = toRadians(lat1);
    lat2 = toRadians(lat2);

    double a =
        pow(sin(dLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(dLon / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c;
  }
}
