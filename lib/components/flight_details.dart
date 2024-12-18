import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/models/flight_model.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class FlightDetails extends StatelessWidget {
  final FlightModel model;
  const FlightDetails({super.key, required this.model});

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
      child: Column(children: [
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
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF323558),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(children: [
                SizedBox(height: 16.h),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 16.w),
                      Column(children: [
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
                          DateFormat("H:m").format(
                              model.departure?.scheduled ?? DateTime.now()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: textColor,
                          ),
                        )
                      ]),
                      Column(children: [
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
                          DateFormat("H:m").format(
                              model.arrival?.scheduled ?? DateTime.now()),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: textColor,
                          ),
                        )
                      ]),
                      SizedBox(width: 16.w),
                    ]),
                Divider(color: bgColor, height: 32.h),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 16.w),
                      Column(children: [
                        const Text(
                          'Speed',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Obx(() {
                          return Text(
                            '${controller.calculatedSpeed(model.live?.speedHorizontal ?? 0).toStringAsFixed(2)} ${controller.selectedSpeed.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: whiteColor,
                            ),
                          );
                        })
                      ]),
                      Column(children: [
                        const Text(
                          'Altitude',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Obx(() {
                          return Text(
                            '${controller.calculatedAltitude(model.live?.altitude ?? 0).toStringAsFixed(2)} ${controller.selectedAltitude.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: whiteColor,
                            ),
                          );
                        })
                      ]),
                      Column(children: [
                        const Text(
                          'Distance',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Obx(() {
                          return Text(
                            '${controller.haversine(model.departure?.iata ?? '', model.arrival?.iata ?? '').toStringAsFixed(2)} ${controller.selectedDistance.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: whiteColor,
                            ),
                          );
                        })
                      ]),
                      SizedBox(width: 16.w),
                    ]),
                SizedBox(height: 16.h),
              ]),
            ),
          ]),
        ),
        SizedBox(height: MediaQuery.of(context).padding.bottom)
      ]),
    );
  }
}
