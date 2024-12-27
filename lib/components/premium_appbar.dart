import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/views/home_view.dart';

class PremiumAppBar extends StatelessWidget {
  const PremiumAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        // InkWell(
        //   onTap: () {
        //     SettingsController.instance.restorePurchases();
        //   },
        //   child: Container(
        //     width: 80.w,
        //     height: 28.h,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(100),
        //       color: whiteColor,
        //     ),
        //     child: const Center(
        //       child: Text(
        //         'Restore',
        //         style: TextStyle(
        //           fontSize: 14,
        //           fontWeight: FontWeight.w400,
        //           color: bgColor,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
        InkWell(
          onTap: () {
            if (NavigatorKey.currentRoute == '/onboardingToPremium') {
              NavigatorKey.pushReplacement(const HomeView());
            } else {
              NavigatorKey.pop();
            }
          },
          child: SvgPicture.asset(close),
        ),
      ]),
    );
  }
}
