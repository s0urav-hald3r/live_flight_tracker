import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class SearchToggle extends StatelessWidget {
  const SearchToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;

    return Obx(() {
      return AnimatedToggleSwitch<int>.size(
        textDirection: TextDirection.rtl,
        current: controller.searchToggleIndex,
        values: const [0, 1],
        iconOpacity: .75,
        selectedIconScale: 1.1,
        height: 40.h,
        indicatorSize:
            Size.fromWidth((MediaQuery.of(context).size.width - 32.w) / 2),
        iconBuilder: (index) {
          return [
            const Text(
              'By Flight Code',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: whiteColor,
              ),
            ),
            const Text(
              'By Route',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: whiteColor,
              ),
            ),
          ][index];
        },
        iconAnimationType: AnimationType.onHover,
        style: ToggleStyle(
          borderColor: Colors.transparent,
          borderRadius: BorderRadius.circular(40.0),
        ),
        styleBuilder: (i) {
          return const ToggleStyle(
            indicatorColor: primaryColor,
            backgroundColor: Color(0xFF323558),
          );
        },
        onChanged: (i) {
          controller.searchToggleIndex = i;
        },
      );
    });
  }
}
