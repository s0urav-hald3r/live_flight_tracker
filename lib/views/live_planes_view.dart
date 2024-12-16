import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/views/premium_view.dart';

class LivePlanesView extends StatelessWidget {
  const LivePlanesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() {
        if (HomeController.instance.turnOnCompass) {
          return FloatingActionButton(
            onPressed: () {},
            shape: const CircleBorder(),
            backgroundColor: bgColor,
            child: SvgPicture.asset(compass),
          );
        }
        return const SizedBox.shrink();
      }),
      body: SafeArea(
        child: SizedBox(
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
                      'Live Planes',
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              width: MediaQuery.of(context).size.width,
              height: 48.h,
              child: CupertinoTextField(
                controller: HomeController.instance.searchPlace,
                decoration: BoxDecoration(
                  color: const Color(0xFF323558),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.only(left: 0.w),
                prefix: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SvgPicture.asset(search, color: textColor),
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: whiteColor,
                ),
                placeholder: 'Search Places',
                placeholderStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
