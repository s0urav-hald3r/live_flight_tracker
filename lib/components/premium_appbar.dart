import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/views/home_view.dart';
import 'package:lottie/lottie.dart';
import 'package:super_tooltip/super_tooltip.dart';

class PremiumAppBar extends StatelessWidget {
  const PremiumAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
        SuperTooltip(
          showBarrier: true,
          showDropBoxFilter: true,
          sigmaX: 5,
          sigmaY: 5,
          hideTooltipOnTap: true,
          arrowLength: 10,
          arrowBaseWidth: 15,
          content: const Text(
            '''
Subscription Info:
- A pro user can change the plane icon and map style, along with unlimited flight details access, while a non-pro user can only get the benefits for a maximum of two times.
- This app has 1 monthly Subscription priced at \$12.99 per month, 1 weekly subscription priced at \$4.99 per week with a 3-day trial and 1 yearly subscription priced at \$49.99 with a 3-day trial, This subscription unlocks all the features of the app.
- Subscription may be cancelled at any time within the iTunes and App Store Apple ID Settings. All prices include applicable local sales taxes.
- Payment will be charged to the iTunes Account at confirmation of purchase.
- Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period.
- Account will be charged for renewal within 24 hours before the end of the current period, and identify the cost of the renewal.
- The user and auto-renewal may manage subscriptions may be turned off by going to the user's Account Settings after purchase.
- No cancellation of the current subscription is allowed during the active subscription period.''',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: bgColor,
            ),
          ),
          child: Lottie.asset(subscription, width: 30.w),
        ),
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
