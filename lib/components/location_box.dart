import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class LocationBox extends StatelessWidget {
  const LocationBox({super.key, required this.notnow, required this.allow});

  final Function notnow;
  final Function allow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          16.w, 24.h, 16.w, MediaQuery.of(context).padding.bottom + 24.h),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: primaryColor.withOpacity(.2),
          child: SvgPicture.asset(location),
        ),
        SizedBox(height: 24.h),
        const Text(
          'Allow access location',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: whiteColor,
          ),
        ),
        SizedBox(height: 16.h),
        const Text(
          'Before we start we will need to access your location so we can track your location while you are using the app. ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: textColor,
          ),
        ),
        SizedBox(height: 24.h),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: 160.w,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: whiteColor,
            ),
            child: ElevatedButton(
              child: const Text(
                'Not Now',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: bgColor,
                ),
              ),
              onPressed: () {
                notnow();
              },
            ),
          ),
          Container(
            width: 160.w,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: primaryColor,
            ),
            child: ElevatedButton(
              child: const Text(
                'Allow',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: whiteColor,
                ),
              ),
              onPressed: () {
                allow();
              },
            ),
          ),
        ])
      ]),
    );
  }
}
