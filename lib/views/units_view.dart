import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/services/local_storage.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/views/premium_view.dart';

class UnitsView extends StatelessWidget {
  UnitsView({super.key});

  final controller = HomeController.instance;
  final settingsController = SettingsController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        iconTheme: const IconThemeData(color: whiteColor),
        title: const Text(
          'Units',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: whiteColor,
          ),
        ),
        actions: [
          InkWell(
            onTap: () async {
              await LocalStorage.addData(
                  speedFactor, controller.selectedSpeed.name);
              await LocalStorage.addData(
                  distanceFactor, controller.selectedDistance.name);
              await LocalStorage.addData(
                  altitudeFactor, controller.selectedAltitude.name);
              NavigatorKey.pop();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Obx(() {
          return Column(children: [
            Expanded(
              child: ListView(padding: EdgeInsets.zero, children: [
                _menuHeader('Speed'),
                _speedItems(Speed.MPH, controller.selectedSpeed),
                _speedItems(Speed.KPH, controller.selectedSpeed),
                _speedItems(Speed.KNOTS, controller.selectedSpeed),
                Divider(height: 1.h, color: const Color(0xFF323558)),
                _menuHeader('Distance'),
                _distanceItems(Distance.MILES, controller.selectedDistance),
                _distanceItems(Distance.KM, controller.selectedDistance),
                _distanceItems(Distance.NM, controller.selectedDistance),
                Divider(height: 1.h, color: const Color(0xFF323558)),
                _menuHeader('Altitude'),
                _altitudeItems(Altitude.FEET, controller.selectedAltitude),
                _altitudeItems(Altitude.METER, controller.selectedAltitude),
              ]),
            ),
          ]);
        }),
      ),
    );
  }

  Widget _speedItems(Speed cValue, Speed gValue) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          cValue.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: whiteColor,
          ),
        ),
        if (cValue == gValue)
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 7.5),
              color: whiteColor,
            ),
          )
        else
          InkWell(
            onTap: () {
              if (settingsController.isPremium) {
                controller.selectedSpeed = cValue;
                return;
              }
              NavigatorKey.push(const PremiumView());
            },
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: whiteColor),
              ),
            ),
          )
      ]),
    );
  }

  Widget _distanceItems(Distance cValue, Distance gValue) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          cValue.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: whiteColor,
          ),
        ),
        if (cValue == gValue)
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 7.5),
              color: whiteColor,
            ),
          )
        else
          InkWell(
            onTap: () {
              if (settingsController.isPremium) {
                controller.selectedDistance = cValue;
                return;
              }
              NavigatorKey.push(const PremiumView());
            },
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: whiteColor),
              ),
            ),
          )
      ]),
    );
  }

  Widget _altitudeItems(Altitude cValue, Altitude gValue) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          cValue.name,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: whiteColor,
          ),
        ),
        if (cValue == gValue)
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 7.5),
              color: whiteColor,
            ),
          )
        else
          InkWell(
            onTap: () {
              if (settingsController.isPremium) {
                controller.selectedAltitude = cValue;
                return;
              }
              NavigatorKey.push(const PremiumView());
            },
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: whiteColor),
              ),
            ),
          )
      ]),
    );
  }

  Widget _menuHeader(String title) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: whiteColor,
          ),
        ),
        if (!settingsController.isPremium)
          SizedBox(
            width: 24,
            height: 24,
            child: SvgPicture.asset(premiumIcon),
          )
      ]),
    );
  }
}
