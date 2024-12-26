import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_flight_tracker/airports_data.dart';
import 'package:live_flight_tracker/components/route_details.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/images.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/models/flight_model.dart';

class FlightRouteView extends StatefulWidget {
  final FlightModel flight;
  const FlightRouteView({super.key, required this.flight});

  @override
  State<FlightRouteView> createState() => _FlightRouteViewState();
}

class _FlightRouteViewState extends State<FlightRouteView> {
  GoogleMapController? controller;
  late LatLng origin;
  late LatLng currentLocation;
  late LatLng destination;
  bool loadingRouteMap = true;

  MapType? currentMapType;

  late String darkString;

  Set<Polyline> _polylines = {};
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initializeLatLong();
    changeMapType();
  }

  changeMapType() {
    debugPrint('called changeMapType function');
    setState(() {
      switch (HomeController.instance.selectedMapMode) {
        case MapMode.Dark:
          DefaultAssetBundle.of(context)
              .loadString('assets/static/dark_mode.json')
              .then((value) {
            darkString = value;
          });

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

  void _initializeLatLong() {
    double originLat = double.parse(airportsData.firstWhere((airport) =>
            airport['iata_code'] ==
            widget.flight.departure!.iata)['latitude_deg'] ??
        '0.0');
    double originLong = double.parse(airportsData.firstWhere((airport) =>
            airport['iata_code'] ==
            widget.flight.departure!.iata)['longitude_deg'] ??
        '0.0');
    origin = LatLng(originLat, originLong);
    debugPrint('origin: $origin');

    double curLat = (widget.flight.live?.latitude ?? 0).toDouble();
    double curLong = (widget.flight.live?.longitude ?? 0).toDouble();
    currentLocation = LatLng(curLat, curLong);
    debugPrint('currentLocation: $currentLocation');

    double desLat = double.parse(airportsData.firstWhere((airport) =>
            airport['iata_code'] ==
            widget.flight.arrival!.iata)['latitude_deg'] ??
        '0.0');
    double desLong = double.parse(airportsData.firstWhere((airport) =>
            airport['iata_code'] ==
            widget.flight.arrival!.iata)['longitude_deg'] ??
        '0.0');
    destination = LatLng(desLat, desLong);
    debugPrint('destination: $destination');

    setState(() {
      loadingRouteMap = false;
    });

    _serMarker();
  }

  void _serMarker() async {
    final BitmapDescriptor planeIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(36, 36)),
      whitePlane,
    );

    Set<Marker> planeMarker = {
      Marker(
        markerId: MarkerId(
            widget.flight.aircraft?.registration ?? UniqueKey().toString()),
        position: LatLng(
          (widget.flight.live?.latitude ?? 0).toDouble(),
          (widget.flight.live?.longitude ?? 0).toDouble(),
        ),
        icon: planeIcon,
        // Rotate marker based on direction
        rotation: (widget.flight.live?.direction ?? 0).toDouble(),
        anchor: const Offset(0.5, 0.5),
      )
    };

    setState(() {
      markers = planeMarker;
    });

    _setPolylines();
  }

  void _setPolylines() {
    Set<Polyline> planePolyline = {
      Polyline(
        polylineId: const PolylineId("origin current"),
        points: [origin, currentLocation],
        width: 3,
        color: textColor,
        visible: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: const [PatternItem.dot],
      ),
      Polyline(
        polylineId: const PolylineId("current destination"),
        points: [currentLocation, destination],
        width: 3,
        color: primaryColor,
        visible: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        patterns: const [PatternItem.dot],
      ),
    };

    if (mounted) {
      setState(() {
        _polylines = planePolyline;
      });
    }
  }

  _onMapCreated(GoogleMapController mapController) async {
    setState(() {
      controller = mapController;
      if (HomeController.instance.selectedMapMode == MapMode.Dark) {
        controller!.setMapStyle(darkString);
      }
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
          loadingRouteMap
              ? const Center(
                  child: CupertinoActivityIndicator(color: whiteColor),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: currentMapType == null
                      ? GoogleMap(
                          zoomControlsEnabled: true,
                          myLocationEnabled: true,
                          buildingsEnabled: true,
                          myLocationButtonEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          zoomGesturesEnabled: true,
                          onMapCreated: _onMapCreated,
                          markers: markers,
                          initialCameraPosition: CameraPosition(
                            target: currentLocation,
                            zoom: 5,
                          ),
                          polylines: _polylines,
                        )
                      : GoogleMap(
                          zoomControlsEnabled: true,
                          myLocationEnabled: true,
                          buildingsEnabled: true,
                          myLocationButtonEnabled: false,
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          zoomGesturesEnabled: true,
                          onMapCreated: _onMapCreated,
                          markers: markers,
                          initialCameraPosition: CameraPosition(
                            target: currentLocation,
                            zoom: 5,
                          ),
                          polylines: _polylines,
                          mapType: currentMapType!,
                        ),
                ),
          Positioned(bottom: 0, child: RouteDetails(model: widget.flight))
        ]),
      ),
    );
  }
}
