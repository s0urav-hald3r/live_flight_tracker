import 'package:flutter/material.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/utils/utility_functions.dart';

class PremiumLinks extends StatelessWidget {
  const PremiumLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      InkWell(
        onTap: () {
          UtilityFunctions.openUrl(termsOfUseUrl);
        },
        child: const Text(
          'Terms',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFFA7ABB1),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: CircleAvatar(
          radius: 2,
          backgroundColor: Color(0xFFA7ABB1),
        ),
      ),
      InkWell(
        onTap: () {
          UtilityFunctions.openUrl(privacyPolicyUrl);
        },
        child: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFFA7ABB1),
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: CircleAvatar(
          radius: 2,
          backgroundColor: Color(0xFFA7ABB1),
        ),
      ),
      InkWell(
        onTap: () {
          SettingsController.instance.restorePurchases();
        },
        child: const Text(
          'Restore',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xFFA7ABB1),
          ),
        ),
      ),
    ]);
  }
}
