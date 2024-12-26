import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/models/flight_model.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class SaveFlightCard extends StatelessWidget {
  final FlightModel model;
  const SaveFlightCard({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0F35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 130.w,
            color: Colors.transparent,
            child: Text(
              controller.getAirportName(model.departure?.iata ?? ''),
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
              controller.getAirportName(model.arrival?.iata ?? ''),
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
        SizedBox(height: 16.h),
        Container(
          color: Colors.transparent,
          height: 68.h,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(width: 8.w),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                DateFormat("H:mm")
                    .format(model.departure?.scheduled ?? DateTime.now()),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                DateFormat("EE dd-MM-yy")
                    .format(model.arrival?.scheduled ?? DateTime.now()),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: textColor,
                ),
              )
            ]),
            SizedBox(width: 4.h),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: textColor,
                ),
                child: Center(
                  child: Text(
                    controller.getCountryFlag(model.departure?.iata ?? ''),
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                controller.getCountryName(model.departure?.iata ?? ''),
                style: const TextStyle(
                  fontSize: 14,
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              )
            ]),
            SizedBox(width: 4.h),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 35,
                height: 35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: textColor,
                ),
                child: Center(
                  child: Text(
                    controller.getCountryFlag(model.arrival?.iata ?? ''),
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                controller.getCountryName(model.arrival?.iata ?? ''),
                style: const TextStyle(
                  fontSize: 14,
                  color: whiteColor,
                  fontWeight: FontWeight.w400,
                ),
              )
            ]),
            SizedBox(width: 4.h),
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                DateFormat("H:mm")
                    .format(model.arrival?.scheduled ?? DateTime.now()),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                DateFormat("EE dd-MM-yy")
                    .format(model.arrival?.scheduled ?? DateTime.now()),
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
      ]),
    );
  }
}
