import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/config/icons.dart';

class UnitsView extends StatelessWidget {
  const UnitsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(right: 16.w),
              width: MediaQuery.of(context).size.width,
              height: 48.h,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => NavigatorKey.pop(),
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: SvgPicture.asset(leftArrow),
                      ),
                    ),
                    const Text(
                      'Units',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: whiteColor,
                      ),
                    ),
                    const Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ]),
            ),
            _menuHeader('Speed'),
            Divider(height: 1.h, color: const Color(0xFF323558)),
            _menuHeader('Distance'),
            Divider(height: 1.h, color: const Color(0xFF323558)),
            _menuHeader('Altitude'),
          ]),
        ),
      ),
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
            fontSize: 24,
            color: whiteColor,
          ),
        ),
        SizedBox(
          width: 24,
          height: 24,
          child: SvgPicture.asset(premiumIcon),
        )
      ]),
    );
  }
}
