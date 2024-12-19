import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_flight_tracker/components/flight_details.dart';
import 'package:live_flight_tracker/components/location_box.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/config/images.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/flights_data.dart';
import 'package:live_flight_tracker/models/flight_model.dart';
import 'package:live_flight_tracker/models/place_model.dart';
import 'package:live_flight_tracker/services/map_repository.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/views/premium_view.dart';

class LivePlanesView extends StatefulWidget {
  const LivePlanesView({super.key});

  @override
  State<LivePlanesView> createState() => LivePlanesViewState();
}

class LivePlanesViewState extends State<LivePlanesView>
    with AutomaticKeepAliveClientMixin<LivePlanesView> {
  StreamController<LatLng> locationController = StreamController();
  final controller = HomeController.instance;
  GoogleMapController? _controller;

  Set<Marker> markers = {};
  LatLng? initPos;

  // Declare a debounce timer
  Timer? _debounce;

  late MapType currentMapType;

  @override
  void initState() {
    super.initState();
    getCurrentLoc();
    fetchLiveFlights();
    changeMapType();
  }

  changeMarkerIcon() {
    debugPrint('called changeMarkerIcon function');
  }

  changeMapType() {
    debugPrint('called changeMapType function');
    setState(() {
      switch (controller.selectedMapMode) {
        case MapMode.Dark:
          currentMapType = MapType.hybrid;
          break;
        case MapMode.Light:
          currentMapType = MapType.terrain;
          break;
        case MapMode.Satelite:
          currentMapType = MapType.satellite;
          break;
      }
    });
  }

  void fetchLiveFlights() async {
    List<FlightModel> flights = [];
    if (kReleaseMode) {
      flights = await controller.fetchLiveFlights();
    } else {
      for (var flight in flightsData) {
        flights.add(FlightModel.fromJson(flight));
      }
    }
    _addFlightMarkers(flights);
  }

  // Method to add plane markers to the map
  Future<void> _addFlightMarkers(List<FlightModel> flights) async {
    final BitmapDescriptor planeIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      whitePlane,
    );

    Set<Marker> flightMarkers = flights
        .map((flight) {
          final live = flight.live;
          if (live != null) {
            return Marker(
              markerId: MarkerId(
                  flight.aircraft?.registration ?? UniqueKey().toString()),
              position: LatLng(
                (live.latitude ?? 0).toDouble(),
                (live.longitude ?? 0).toDouble(),
              ),
              icon: planeIcon,
              // Rotate marker based on direction
              rotation: (live.direction ?? 0).toDouble(),
              anchor: const Offset(0.5, 0.5),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) {
                      return FlightDetails(model: flight);
                    });
              },
            );
          }
          return null;
        })
        .where((marker) => marker != null)
        .cast<Marker>()
        .toSet();

    setState(() {
      markers = flightMarkers;
    });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  getCurrentLoc() async {
    LocationPermission permission;
    controller.loadingMap = true;

    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.requestPermission();
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      await showPermissionBox();
    }

    Position position = await Geolocator.getCurrentPosition();

    initPos = LatLng(position.latitude, position.longitude);

    controller.loadingMap = false;
    controller.havePermission = true;
  }

  Future<void> showPermissionBox() async {
    showModalBottomSheet(
        context: context,
        isDismissible: false,
        builder: (context) {
          return LocationBox(notnow: () {
            controller.loadingMap = false;
            controller.havePermission = false;
            NavigatorKey.pop();
          }, allow: () async {
            LocationPermission permission;
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              controller.loadingMap = false;
              controller.havePermission = false;
              return Future.error('Location permissions are denied');
            }
            if (permission == LocationPermission.deniedForever) {
              controller.loadingMap = false;
              controller.havePermission = false;
              return Future.error(
                  'Location permissions are permanently denied, we cannot request permissions.');
            }

            Position position = await Geolocator.getCurrentPosition();

            initPos = LatLng(position.latitude, position.longitude);

            controller.loadingMap = false;
            controller.havePermission = true;

            NavigatorKey.pop();
          });
        });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required when using AutomaticKeepAliveClientMixin
    return Scaffold(
      floatingActionButton: Obx(() {
        if (controller.turnOnCompass) {
          return FloatingActionButton(
            onPressed: () {
              _controller?.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: initPos!, // Keep the current target
                    zoom: 10, // Keep the same zoom level
                    bearing: 0.0, // Reset orientation to north
                  ),
                ),
              );
            },
            shape: const CircleBorder(),
            backgroundColor: bgColor,
            child: SvgPicture.asset(compass),
          );
        }
        return const SizedBox.shrink();
      }),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              width: MediaQuery.of(context).size.width,
              height: 48.h,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Live Planes',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: whiteColor,
                      ),
                    ),
                    Obx(() {
                      return Visibility.maintain(
                        visible: !SettingsController.instance.isPremium,
                        child: InkWell(
                          onTap: () {
                            NavigatorKey.push(const PremiumView());
                          },
                          child: SvgPicture.asset(premiumIcon),
                        ),
                      );
                    }),
                  ]),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              width: MediaQuery.of(context).size.width,
              height: 48.h,
              child: CupertinoTextField(
                onChanged: (value) {
                  controller.isSearching = value.isNotEmpty;

                  // Cancel the previous timer if it exists
                  if (_debounce?.isActive ?? false) _debounce!.cancel();

                  // Set up a new timer
                  _debounce =
                      Timer(const Duration(milliseconds: 300), () async {
                    if (controller.isSearching) {
                      controller.searchedPlaces =
                          await MapRepository.getAutocomplete(value);
                    }
                  });
                },
                decoration: BoxDecoration(
                  color: const Color(0xFF323558),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.only(left: 0.w),
                prefix: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SvgPicture.asset(search, color: textColor),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: whiteColor,
                ),
                placeholder: 'Search Places',
                placeholderStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
            ),
            Obx(() {
              if (controller.loadingMap) {
                return const Expanded(
                  child: Center(
                    child: CupertinoActivityIndicator(color: whiteColor),
                  ),
                );
              }

              if (!controller.havePermission) {
                return Expanded(
                    child: Center(
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: primaryColor,
                    ),
                    child: ElevatedButton(
                      child: const Text(
                        'Allow Location Permission',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                      ),
                      onPressed: () {
                        showPermissionBox();
                      },
                    ),
                  ),
                ));
              }

              if (controller.isSearching) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.searchedPlaces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Place selectedPlace = await MapRepository.getPlace(
                            controller.searchedPlaces[index].placeId!);
                        LatLng pos = LatLng(
                            selectedPlace.geometry!.location!.lat!,
                            selectedPlace.geometry!.location!.lng!);
                        _controller?.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: pos, zoom: 17.4746),
                          ),
                        );
                        locationController.add(pos);
                        initPos = pos;
                        // setMarker();

                        controller.isSearching = false;
                      },
                      leading: const Icon(
                        Icons.location_on,
                        color: primaryColor,
                      ),
                      title: Text(
                        controller.searchedPlaces[index].description!,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                );
              }

              return Expanded(
                child: GoogleMap(
                  zoomControlsEnabled: true,
                  myLocationEnabled: true,
                  buildingsEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  indoorViewEnabled: true,
                  zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  markers: markers,
                  onCameraMove: (CameraPosition pos) async {
                    locationController.add(pos.target);
                    initPos = pos.target;
                  },
                  initialCameraPosition: CameraPosition(
                    target: initPos!,
                    zoom: 6,
                  ),
                  mapType: currentMapType,
                ),
              );
            })
          ]),
        ),
      ),
    );
  }
}
