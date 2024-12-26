import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_flight_tracker/components/distance_indicator.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/models/flight_model.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class RouteDetails extends StatelessWidget {
  final FlightModel model;
  const RouteDetails({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color(0xFF0E0F35),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        // Bar indicator
        Container(
          width: 40.w,
          height: 4.h,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: whiteColor,
          ),
        ),

        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
          child: Column(children: [
            // Flight ragistration details
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                width: 250.w,
                color: Colors.transparent,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.flight?.icao ?? 'NA',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 24,
                          color: whiteColor,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        model.airline?.name ?? 'NA',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: textColor,
                        ),
                      )
                    ]),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759).withOpacity(.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Text(
                    'En Route',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Color(0xFF34C759),
                    ),
                  ),
                ),
              )
            ]),

            SizedBox(height: 16.h),

            // Flight details
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF323558),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 130.w,
                          color: Colors.transparent,
                          child: Text(
                            controller
                                .getAirportName(model.departure?.iata ?? 'NA'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        // const Text(
                        //   '|',
                        //   style: TextStyle(
                        //     color: whiteColor,
                        //     fontSize: 20,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                        Container(
                          width: 130.w,
                          color: Colors.transparent,
                          child: Text(
                            controller
                                .getAirportName(model.arrival?.iata ?? 'NA'),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ]),
                ),
                SizedBox(height: 16.h),
                Container(
                  color: Colors.transparent,
                  height: 68.h,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 8.w),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                model.departure?.iata ?? 'NA',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: whiteColor,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                DateFormat("H:mm").format(
                                    model.departure?.scheduled ??
                                        DateTime.now()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              )
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: textColor,
                                ),
                                child: Center(
                                  child: Text(
                                    controller.getCountryFlag(
                                        model.departure?.iata ?? ''),
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                controller.getCountryName(
                                    model.departure?.iata ?? ''),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: textColor,
                                ),
                                child: Center(
                                  child: Text(
                                    controller.getCountryFlag(
                                        model.arrival?.iata ?? ''),
                                    style: const TextStyle(fontSize: 26),
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                controller
                                    .getCountryName(model.arrival?.iata ?? ''),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: whiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              )
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                model.arrival?.iata ?? 'NA',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: whiteColor,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                DateFormat("H:mm").format(
                                    model.arrival?.scheduled ?? DateTime.now()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: textColor,
                                ),
                              )
                            ]),
                        SizedBox(width: 8.w),
                      ]),
                ),
                SizedBox(height: 16.h),
              ]),
            ),

            SizedBox(height: 16.h),

            // Distance indicator
            DistanceIndicator(
              totalDistance: controller.haversine(
                  model.departure?.iata ?? '', model.arrival?.iata ?? ''),
              currentDistance: controller.currentDistance(
                model.departure?.iata ?? '',
                model.live?.latitude ?? 0,
                model.live?.longitude ?? 0,
              ),
            ),

            SizedBox(height: 16.h),

            // Show flight route button
            Container(
              width: MediaQuery.of(context).size.width,
              height: 42.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: primaryColor),
                color: primaryColor,
              ),
              child: ElevatedButton(
                child: const Text(
                  'Add to My Flights',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: whiteColor,
                  ),
                ),
                onPressed: () {
                  controller.addToMyFlights(model);
                },
              ),
            ),

            SizedBox(height: 16.h),
          ]),
        ),
      ]),
    );
  }
}
