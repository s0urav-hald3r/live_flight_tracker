// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_flight_tracker/airports_data.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/config/images.dart';
import 'package:live_flight_tracker/country_data.dart';
import 'package:live_flight_tracker/main.dart';
import 'package:live_flight_tracker/models/flight_model.dart';
import 'package:live_flight_tracker/models/place_search_model.dart';
import 'package:live_flight_tracker/services/dio_client.dart';
import 'package:live_flight_tracker/services/local_storage.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';

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
    retriveLocalFlights();
    setMapType();
    setPlaneIndex();
    setSpeed();
    setDistance();
    setAltitude();
  }

  void retriveLocalFlights() {
    final jsonList = LocalStorage.getData(savedLocalFlights, KeyType.DYNAMIC);

    if ((jsonList ?? '').isNotEmpty) {
      savedFlights.clear();

      for (var json in jsonList) {
        _savedFlights.add(FlightModel.fromJson(json));
      }
    }
  }

  void setAltitude() {
    String altitude = LocalStorage.getData(altitudeFactor, KeyType.STR);
    debugPrint('initial altitude: $altitude');

    if (altitude.isEmpty) {
      selectedAltitude = Altitude.METER;
      return;
    }

    if (altitude == Altitude.FEET.name) {
      selectedAltitude = Altitude.FEET;
      return;
    }

    if (altitude == Altitude.METER.name) {
      selectedAltitude = Altitude.METER;
      return;
    }
  }

  void setDistance() {
    String distance = LocalStorage.getData(distanceFactor, KeyType.STR);
    debugPrint('initial distance: $distance');

    if (distance.isEmpty) {
      selectedDistance = Distance.KM;
      return;
    }

    if (distance == Distance.MILES.name) {
      selectedDistance = Distance.MILES;
      return;
    }

    if (distance == Distance.KM.name) {
      selectedDistance = Distance.KM;
      return;
    }

    if (distance == Distance.NM.name) {
      selectedDistance = Distance.NM;
      return;
    }
  }

  void setSpeed() {
    String speed = LocalStorage.getData(speedFactor, KeyType.STR);
    debugPrint('initial speed: $speed');

    if (speed.isEmpty) {
      selectedSpeed = Speed.KPH;
      return;
    }

    if (speed == Speed.MPH.name) {
      selectedSpeed = Speed.MPH;
      return;
    }

    if (speed == Speed.KPH.name) {
      selectedSpeed = Speed.KPH;
      return;
    }

    if (speed == Speed.KNOTS.name) {
      selectedSpeed = Speed.KNOTS;
      return;
    }
  }

  void setPlaneIndex() {
    int value = LocalStorage.getData(planeIndex, KeyType.INT);

    if (value == 0) {
      selectedPlaneIndex = 3;
    } else {
      selectedPlaneIndex = value;
    }
    debugPrint('initial marker index: $selectedPlaneIndex');
  }

  void setMapType() {
    String map = LocalStorage.getData(mapMode, KeyType.STR);
    debugPrint('initial mapType: $map');

    if (map.isEmpty) {
      selectedMapMode = MapMode.Dark;
      return;
    }

    if (map == MapMode.Dark.name) {
      selectedMapMode = MapMode.Dark;
      return;
    }

    if (map == MapMode.Light.name) {
      selectedMapMode = MapMode.Light;
      return;
    }

    if (map == MapMode.Satelite.name) {
      selectedMapMode = MapMode.Satelite;
      return;
    }
  }

  final pageController = PageController();

  final departingFrom = TextEditingController();
  final arrivingAt = TextEditingController();
  final flightCode = TextEditingController();
  final flightNumber = TextEditingController();
  final date = TextEditingController(
      text: DateFormat("EEE, d MMM y").format(DateTime.now()));

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
  final RxBool _isLoading = false.obs;
  final RxBool _isFetching = false.obs;
  final RxInt _onboardingIndex = 0.obs;
  final RxInt _homeIndex = 0.obs;
  final RxInt _selectedPlaneIndex = 3.obs;
  final RxInt _searchToggleIndex = 0.obs;
  final Rx<Plan> _selectedPlan = Plan.WEEKLY.obs;
  final Rx<Speed> _selectedSpeed = Speed.KPH.obs;
  final Rx<Distance> _selectedDistance = Distance.KM.obs;
  final Rx<Altitude> _selectedAltitude = Altitude.METER.obs;
  final Rx<MapMode> _selectedMapMode = MapMode.Dark.obs;
  final RxBool _turnOnCompass = true.obs;
  final RxList<FlightModel> _savedFlights = <FlightModel>[].obs;
  final RxList<DateTime> _selectedDates = <DateTime>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isFetching => _isFetching.value;
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
  List<FlightModel> get savedFlights => _savedFlights;
  List<DateTime> get selectedDates => _selectedDates;

  // Setters
  set isLoading(status) => _isLoading.value = status;
  set isFetching(status) => _isFetching.value = status;
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
  set savedFlights(value) => _savedFlights.value = value;
  set selectedDates(value) => _selectedDates.value = value;

  addToMyFlights(FlightModel model) {
    savedFlights.add(model);
    // pop the route view from stack
    NavigatorKey.pop();
    // pop the modal sheet of home view from stack
    NavigatorKey.pop();
    homeIndex = 1;
    pageController.jumpToPage(1);

    // saving to local stoage
    List<Map<String, dynamic>> jsonList =
        savedFlights.map((flight) => flight.toJson()).toList();

    LocalStorage.addData(savedLocalFlights, jsonList);
  }

  removeFromMyFlights(int index) {
    savedFlights.removeAt(index);
    if (NavigatorKey.canPop()) {
      NavigatorKey.pop();
    }

    // saving to local stoage
    List<Map<String, dynamic>> jsonList =
        savedFlights.map((flight) => flight.toJson()).toList();

    LocalStorage.addData(savedLocalFlights, jsonList);
  }

  /// [----------------------------------------------------------------]

  final RxBool _loadingMap = false.obs;
  final RxBool _havePermission = false.obs;
  final RxBool _isSearching = false.obs;
  final RxList<PlaceSearchModel> _searchedPlaces = <PlaceSearchModel>[].obs;
  final RxList<FlightModel> _searchedFlights = <FlightModel>[].obs;
  final RxList<Map<String, dynamic>> _filteredItems =
      <Map<String, dynamic>>[].obs;

  bool get loadingMap => _loadingMap.value;
  bool get havePermission => _havePermission.value;
  bool get isSearching => _isSearching.value;
  List<PlaceSearchModel> get searchedPlaces => _searchedPlaces;
  List<FlightModel> get searchedFlights => _searchedFlights;
  List<Map<String, dynamic>> get filteredItems => _filteredItems;

  set loadingMap(status) => _loadingMap.value = status;
  set havePermission(status) => _havePermission.value = status;
  set isSearching(status) => _isSearching.value = status;
  set searchedPlaces(value) => _searchedPlaces.value = value;
  set searchedFlights(value) => _searchedFlights.value = value;
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
    setSpeed();

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
    setAltitude();

    // as upcoming altitude by default METER
    switch (selectedAltitude) {
      case Altitude.FEET:
        return altitude * 3.28084;
      case Altitude.METER:
        return altitude;
    }
  }

  String getAirportName(String iata) {
    if (iata.isEmpty) {
      return 'NA';
    }

    return airportsData
        .firstWhere((airport) => airport['iata_code'] == iata)['name'];
  }

  String getCountryFlag(String iata) {
    if (iata.isEmpty) {
      return '';
    }

    String countryCode = airportsData
        .firstWhere((airport) => airport['iata_code'] == iata)['iso_country'];

    return countryData.firstWhereOrNull((country) =>
            country['code'] == countryCode ||
            country['code'].contains(countryCode))?['flag'] ??
        '';
  }

  String getCountryName(String iata) {
    if (iata.isEmpty) {
      return 'NA';
    }

    String countryCode = airportsData
        .firstWhere((airport) => airport['iata_code'] == iata)['iso_country'];

    return countryData.firstWhereOrNull((country) =>
            country['code'] == countryCode ||
            country['code'].contains(countryCode))?['name'] ??
        '';
  }

  double haversine(String depIATA, String arrIATA) {
    setDistance();

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

  void searchFlightsByRoute() async {
    isSearching = true;
    try {
      final String apiKey = FlutterConfig.get('AVIAIONSTACK_API_KEY');
      final String departIATA = departingFrom.text.split('-')[0].trim();
      final String arriveIATA = arrivingAt.text.split('-')[0].trim();

      String url;
      if (FlutterConfig.get('AVIAIONSTACK_PLAN_TYPE') != PlanType.FREE.name) {
        final String selectedDate = DateFormat("yyyy-MM-dd")
            .format(DateFormat("EEE, d MMM y").parse(date.text));

        url =
            'https://api.aviationstack.com/v1/flights?access_key=$apiKey&flight_date=$selectedDate&dep_iata=$departIATA&arr_iata=$arriveIATA';
      } else {
        url =
            'https://api.aviationstack.com/v1/flights?access_key=$apiKey&dep_iata=$departIATA&arr_iata=$arriveIATA';
      }

      final temp = <FlightModel>[];
      final response = await _dioClient.get(url);

      for (var flight in response.data['data']) {
        temp.add(FlightModel.fromJson(flight));
      }

      searchedFlights = temp;
      isSearching = false;
    } on DioException catch (e) {
      debugPrint('DioException Error: $e');
      isSearching = false;
    } catch (e) {
      debugPrint('Unknown Error: $e');
      isSearching = false;
    }
  }

  void searchFlightsByCode() async {
    isSearching = true;
    try {
      final String apiKey = FlutterConfig.get('AVIAIONSTACK_API_KEY');
      final String flightIATA =
          '${flightCode.text.trim()}${flightNumber.text.trim()}';

      String url;
      if (FlutterConfig.get('AVIAIONSTACK_PLAN_TYPE') != PlanType.FREE.name) {
        final String selectedDate = DateFormat("yyyy-MM-dd")
            .format(DateFormat("EEE, d MMM y").parse(date.text));

        url =
            'https://api.aviationstack.com/v1/flights?access_key=$apiKey&flight_iata=$flightIATA&flight_date=$selectedDate';
      } else {
        url =
            'https://api.aviationstack.com/v1/flights?access_key=$apiKey&flight_iata=$flightIATA';
      }

      final temp = <FlightModel>[];
      final response = await _dioClient.get(url);

      for (var flight in response.data['data']) {
        temp.add(FlightModel.fromJson(flight));
      }

      searchedFlights = temp;
      isSearching = false;
    } on DioException catch (e) {
      debugPrint('DioException Error: $e');
      isSearching = false;
    } catch (e) {
      debugPrint('Unknown Error: $e');
      isSearching = false;
    }
  }

  Future<FlightModel?> checkCurrentStatus(FlightModel demo) async {
    isFetching = true;
    try {
      final String apiKey = FlutterConfig.get('AVIAIONSTACK_API_KEY');
      final String depIata = demo.departure?.iata ?? '';
      final String arrIata = demo.arrival?.iata ?? '';
      final String flightIata = demo.flight?.iata ?? '';

      String url =
          'https://api.aviationstack.com/v1/flights?access_key=$apiKey&dep_iata=$depIata&arr_iata=$arrIata&flight_iata=$flightIata';

      final temp = <FlightModel>[];
      final response = await _dioClient.get(url);

      for (var flight in response.data['data']) {
        final value = FlightModel.fromJson(flight);
        if (value.flightDate!.isToday) {
          temp.add(value);
        }
      }

      isFetching = false;
      return temp.first;
    } on DioException catch (e, st) {
      debugPrint('DioException Error: $e');
      debugPrint('DioException Stack: $st');
      isFetching = false;
      return null;
    } catch (e, st) {
      Get.snackbar(
        '',
        '',
        icon: const Icon(Icons.error),
        shouldIconPulse: true,
        titleText: const Text(
          'Failed',
          style: TextStyle(
              fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold),
        ),
        messageText: const Text(
          'This flight has been already completed it journey.\nSlide to remove from saved list.',
          style: TextStyle(fontSize: 14, color: whiteColor),
        ),
        backgroundColor: primaryColor,
        snackPosition: SnackPosition.BOTTOM,
      );
      debugPrint('Unknown Error: $e');
      debugPrint('Unknown Stack: $st');
      isFetching = false;
      return null;
    }
  }
}
