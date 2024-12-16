import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/models/place_model.dart';
import 'package:live_flight_tracker/services/map_repository.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/views/premium_view.dart';

class LivePlanesView extends StatefulWidget {
  const LivePlanesView({super.key});

  @override
  State<LivePlanesView> createState() => _LivePlanesViewState();
}

class _LivePlanesViewState extends State<LivePlanesView> {
  StreamController<LatLng> locationController = StreamController();
  final controller = HomeController.instance;
  GoogleMapController? _controller;

  Set<Marker> markers = {};
  LatLng? initPos;

  // Declare a debounce timer
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    getCurrentLoc();
  }

  setMarker() {
    // setState(() {
    //   markers.add(Marker(
    //       markerId: const MarkerId('id-1'),
    //       position: LatLng(initPos!.latitude, initPos!.longitude)));
    // });
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
    setMarker();
  }

  getCurrentLoc() async {
    LocationPermission permission;
    controller.loadingMap = true;

    if (!await Geolocator.isLocationServiceEnabled()) {
      await Geolocator.requestPermission();
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        controller.loadingMap = false;
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      controller.loadingMap = false;
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    initPos = LatLng(position.latitude, position.longitude);

    controller.loadingMap = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        if (controller.turnOnCompass) {
          return FloatingActionButton(
            onPressed: () {},
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
                          await MapRepository().getAutocomplete(value);
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

              if (controller.isSearching) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.searchedPlaces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Place selectedPlace = await MapRepository().getPlace(
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
                  // myLocationEnabled: true,
                  buildingsEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: controller.turnOnCompass,
                  indoorViewEnabled: true,
                  onMapCreated: _onMapCreated,
                  markers: markers,
                  onCameraMove: (CameraPosition pos) async {
                    locationController.add(pos.target);
                    initPos = pos.target;
                  },
                  initialCameraPosition: CameraPosition(
                    target: initPos!,
                    zoom: 17.4746,
                  ),
                  mapType: MapType.terrain,
                ),
              );
            })
          ]),
        ),
      ),
    );
  }
}
