import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:live_flight_tracker/airports_data.dart';
import 'package:live_flight_tracker/components/route_details.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/images.dart';
import 'package:live_flight_tracker/models/flight_model.dart';

class FlightRouteView extends StatefulWidget {
  final FlightModel flight;
  const FlightRouteView({super.key, required this.flight});

  @override
  State<FlightRouteView> createState() => _FlightRouteViewState();
}

class _FlightRouteViewState extends State<FlightRouteView> {
  GoogleMapController? controller;
  late LatLng currentLocation;
  late LatLng destination;
  bool loadingRouteMap = true;

  Set<Polyline> _polylines = {};
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _initializeLatLong();
  }

  void _initializeLatLong() {
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
      const ImageConfiguration(size: Size(48, 48)),
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
        polylineId: const PolylineId("dottedLine"),
        points: [currentLocation, destination],
        width: 4,
        color: primaryColor,
        visible: true,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
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
                    initialCameraPosition: CameraPosition(
                      target: currentLocation,
                      zoom: 8,
                    ),
                    polylines: _polylines,
                    mapType: MapType.terrain,
                  ),
                ),
          Positioned(bottom: 0, child: RouteDetails(model: widget.flight))
        ]),
      ),
    );
  }
}
