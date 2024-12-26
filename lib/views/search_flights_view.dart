import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/components/flight_code_form.dart';
import 'package:live_flight_tracker/components/route_form.dart';
import 'package:live_flight_tracker/components/search_toggle.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/views/flights_view.dart';

class SearchFlightsView extends StatelessWidget {
  const SearchFlightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: const IconThemeData(color: whiteColor),
        title: const Text(
          'Search Flights',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: whiteColor,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            SizedBox(height: 8.h),
            const SearchToggle(),
            SizedBox(height: 4.h),
            Obx(() {
              if (controller.searchToggleIndex == 0) {
                return const RouteForm();
              }
              return const FlightCodeForm();
            }),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50.h,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: primaryColor,
              ),
              child: ElevatedButton(
                child: const Text(
                  'Search',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: whiteColor,
                  ),
                ),
                onPressed: () {
                  if (controller.searchToggleIndex == 0) {
                    controller.searchFlightsByRoute();
                  } else {
                    controller.searchFlightsByCode();
                  }
                  NavigatorKey.push(const FlightsView());
                },
              ),
            )
          ]),
        ),
      ),
    );
  }
}
