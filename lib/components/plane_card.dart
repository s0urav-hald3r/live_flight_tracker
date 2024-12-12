import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/views/premium_view.dart';

class PlaneCard extends StatelessWidget {
  final Map model;
  final int index;
  const PlaneCard({super.key, required this.model, required this.index});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () {
          if (SettingsController.instance.isPremium) {
            HomeController.instance.selectedPlaneIndex = index;
            return;
          }
          NavigatorKey.push(const PremiumView());
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0E0F35),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: HomeController.instance.selectedPlaneIndex == index
                  ? primaryColor
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: model['flightName'].split(' ')[0],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: whiteColor,
                      ),
                    ),
                    TextSpan(
                      text: ' ${model['flightName'].split(' ')[1]}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: model['flightColor'],
                      ),
                    )
                  ]),
                ),
                Stack(alignment: Alignment.bottomRight, children: [
                  SizedBox(
                    width: 136,
                    height: 130,
                    child: Image.asset(
                      model['flightImage'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (index != 0 && !SettingsController.instance.isPremium)
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: SvgPicture.asset(premiumIcon),
                      )
                    ])
                ]),
              ]),
        ),
      );
    });
  }
}
