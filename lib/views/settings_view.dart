import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/utility_functions.dart';
import 'package:live_flight_tracker/views/units_view.dart';
import 'package:share_plus/share_plus.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Setting',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: whiteColor,
                      ),
                    ),
                    SvgPicture.asset(premiumIcon)
                  ]),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                _items(
                  settingsMap,
                  'Maps',
                  SvgPicture.asset(rightArrow),
                  () {},
                ),
                _items(
                  settingsPlane,
                  'Planes',
                  SvgPicture.asset(rightArrow),
                  () {},
                ),
                _items(
                  settingsUnit,
                  'Units',
                  SvgPicture.asset(rightArrow),
                  () {
                    NavigatorKey.push(const UnitsView());
                  },
                ),
                _items(
                  settingsCompass,
                  'Compass',
                  AdvancedSwitch(
                    activeColor: primaryColor,
                    inactiveColor: Colors.grey,
                    initialValue: true,
                    width: 40.w,
                    height: 24.h,
                    onChanged: (value) {},
                  ),
                  () {},
                ),
                _items(
                  settingsContact,
                  'Contact Us',
                  SvgPicture.asset(rightArrow),
                  () {
                    UtilityFunctions.openUrl(supportUrl);
                  },
                ),
                _items(
                  settingsPrivacy,
                  'Privacy Policy',
                  SvgPicture.asset(rightArrow),
                  () {
                    UtilityFunctions.openUrl(privacyPolicyUrl);
                  },
                ),
                _items(
                  settingsTerms,
                  'Terms of Use',
                  SvgPicture.asset(rightArrow),
                  () {
                    UtilityFunctions.openUrl(termsOfUseUrl);
                  },
                ),
                _items(
                  settingsShare,
                  'Share with friends',
                  SvgPicture.asset(rightArrow),
                  () async {
                    try {
                      await Share.share(shareText);
                    } catch (e) {
                      debugPrint('Faild to share with friends');
                    }
                  },
                ),
              ]),
            )
          ]),
        ),
      ),
    );
  }

  Widget _items(
    String leading,
    String title,
    Widget ending,
    Function callBack,
  ) {
    return InkWell(
      onTap: () => callBack(),
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(vertical: 22.h),
        child: Row(children: [
          SizedBox(
            width: 20,
            height: 20,
            child: SvgPicture.asset(leading),
          ),
          SizedBox(width: 20.w),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: whiteColor,
            ),
          ),
          const Spacer(),
          ending
        ]),
      ),
    );
  }
}
