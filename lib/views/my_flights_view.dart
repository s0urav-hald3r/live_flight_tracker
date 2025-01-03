import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/components/save_flight_card.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/views/premium_view.dart';
import 'package:live_flight_tracker/views/search_flights_view.dart';

class MyFlightsView extends StatelessWidget {
  const MyFlightsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;

    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          SizedBox(
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
                        'My Flight',
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
              Obx(() {
                if (controller.isLoading) {
                  return const Expanded(
                    child: Center(
                      child: CupertinoActivityIndicator(
                        color: whiteColor,
                      ),
                    ),
                  );
                }

                if (controller.savedFlights.isEmpty) {
                  return Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(myFlightsPlane),
                          SizedBox(height: 20.h),
                          const Text(
                            'Search your Flights',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          const Text(
                            'Search your flights for your upcoming\njourney.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Container(
                            height: 48.h,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: primaryColor,
                            ),
                            child: ElevatedButton(
                              child: const Text(
                                'Go to Search',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor,
                                ),
                              ),
                              onPressed: () {
                                NavigatorKey.push(const SearchFlightsView());
                              },
                            ),
                          ),
                        ]),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.savedFlights.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    controller.removeFromMyFlights(index);
                                  },
                                  autoClose: true,
                                  backgroundColor: bgColor,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Remove',
                                ),
                              ]),
                          child: SaveFlightCard(
                            model: controller.savedFlights[index],
                            index: index,
                          ),
                        );
                      }),
                );
              })
            ]),
          ),
          Obx(() {
            if (controller.isFetching) {
              return const Center(
                child: CupertinoActivityIndicator(
                  color: whiteColor,
                ),
              );
            }
            return const SizedBox.shrink();
          })
        ]),
      ),
    );
  }
}
