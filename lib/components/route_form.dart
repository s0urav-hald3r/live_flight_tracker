import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/components/date_picker_widget.dart';
import 'package:live_flight_tracker/components/flight_code_form.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/views/premium_view.dart';
import 'package:live_flight_tracker/views/select_airports.dart';

class RouteForm extends StatelessWidget {
  const RouteForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;

    return ClipPath(
      clipper: TicketClipper(hFactor: 0.61),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 217.5.h,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF323558),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(children: [
          Container(
            height: 48.h,
            margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
            child: CupertinoTextField(
              controller: HomeController.instance.departingFrom,
              readOnly: true,
              onTap: () async {
                final arguments =
                    await NavigatorKey.push(const SelectAirports());
                if (arguments != null) {
                  controller.setField('departingFrom', arguments);
                }
              },
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: whiteColor,
              ),
              placeholder: 'Departing from',
              placeholderStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
          Container(
            height: 48.h,
            margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            child: CupertinoTextField(
              controller: HomeController.instance.arrivingAt,
              readOnly: true,
              onTap: () async {
                final arguments =
                    await NavigatorKey.push(const SelectAirports());
                if (arguments != null) {
                  controller.setField('arrivingAt', arguments);
                }
              },
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: whiteColor,
              ),
              placeholder: 'Arriving at',
              placeholderStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          ),
          DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1.5.h,
            dashLength: 6.w,
            dashColor: bgColor,
            dashGapLength: 3.w,
            dashGapColor: Colors.transparent,
          ),
          Container(
            height: 48.h,
            margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: CupertinoTextField(
              readOnly: true,
              controller: HomeController.instance.date,
              onTap: () {
                if (SettingsController.instance.isPremium) {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return const DatePickerWidget();
                      });
                } else {
                  NavigatorKey.push(const PremiumView());
                }
              },
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.zero,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: whiteColor,
              ),
              placeholder: 'Wed, 6 Nov 2024',
              placeholderStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
              prefix: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SvgPicture.asset(calendar),
              ),
              prefixMode: OverlayVisibilityMode.always,
            ),
          ),
        ]),
      ),
    );
  }
}
