import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/components/flight_card.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class FlightsView extends StatelessWidget {
  const FlightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: const IconThemeData(color: whiteColor),
        title: const Text(
          'Available Flights',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: whiteColor,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Obx(() {
            if (controller.isSearching) {
              return const Expanded(
                child: Center(
                  child: CupertinoActivityIndicator(
                    color: whiteColor,
                  ),
                ),
              );
            }

            if (controller.searchedFlights.isEmpty) {
              return Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(myFlightsPlane),
                      SizedBox(height: 20.h),
                      const Text(
                        'No Results',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          color: textColor,
                        ),
                      ),
                    ]),
              );
            }

            return Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.searchedFlights.length,
                  itemBuilder: (context, index) {
                    return FlightCard(
                      model: controller.searchedFlights[index],
                    );
                  }),
            );
          })
        ]),
      ),
    );
  }
}
