import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/views/live_planes_view.dart';
import 'package:live_flight_tracker/views/my_flights_view.dart';
import 'package:live_flight_tracker/views/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = HomeController.instance;

  final GlobalKey<LivePlanesViewState> mapViewKey =
      GlobalKey<LivePlanesViewState>();

  void changeMarkerIcon() {
    mapViewKey.currentState?.changeMarkerIcon();
  }

  void changeMapType() {
    mapViewKey.currentState?.changeMapType();
  }

  @override
  Widget build(BuildContext context) {
    double bottomPadding = MediaQuery.of(context).padding.bottom;

    return Obx(() {
      return Scaffold(
          backgroundColor: bgColor,
          resizeToAvoidBottomInset: false,
          body: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                LivePlanesView(key: mapViewKey),
                const MyFlightsView(),
                SettingsView(marker: changeMarkerIcon, map: changeMapType),
              ]),
          bottomNavigationBar: Container(
            height: 60 + bottomPadding,
            padding: EdgeInsets.fromLTRB(0, 10, 0, bottomPadding),
            color: bgColor,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(0, explore, 'Explore', () {
                    controller.homeIndex = 0;
                    controller.pageController.jumpToPage(0);
                  }),
                  _navItem(1, flights, 'My flights', () {
                    controller.homeIndex = 1;
                    controller.pageController.jumpToPage(1);
                  }),
                  _navItem(2, settings, 'Settings', () {
                    controller.homeIndex = 2;
                    controller.pageController.jumpToPage(2);
                  }),
                ]),
          ));
    });
  }

  Widget _navItem(int index, String icon, String title, Function callBack) {
    return InkWell(
      onTap: () {
        callBack();
      },
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SvgPicture.asset(
          icon,
          color: HomeController.instance.homeIndex == index
              ? primaryColor
              : textColor,
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: HomeController.instance.homeIndex == index
                ? primaryColor
                : textColor,
          ),
        )
      ]),
    );
  }
}
