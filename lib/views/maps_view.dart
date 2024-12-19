import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/config/images.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/views/premium_view.dart';

class MapsView extends StatelessWidget {
  final Function callBack;
  const MapsView({super.key, required this.callBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(
              right: 16.w,
              top: MediaQuery.of(context).padding.top,
            ),
            width: MediaQuery.of(context).size.width,
            height: 48.h + MediaQuery.of(context).padding.top,
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
                    'Maps',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      callBack();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ]),
          ),
          Expanded(
            child: ListView(padding: EdgeInsets.zero, children: [
              _mapItem(context, MapMode.Dark, darkMode),
              _mapItem(context, MapMode.Light, lightMode),
              _mapItem(context, MapMode.Satelite, sateliteMode),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _mapItem(BuildContext context, MapMode mode, String image) {
    return InkWell(
      onTap: () {
        if (SettingsController.instance.isPremium) {
          HomeController.instance.selectedMapMode = mode;
          return;
        }
        NavigatorKey.push(const PremiumView());
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            '${mode.name} mode',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: whiteColor,
            ),
          ),
          SizedBox(height: 12.h),
          Obx(() {
            return Stack(children: [
              Container(
                height: 190.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    width: 2,
                    color: HomeController.instance.selectedMapMode == mode
                        ? primaryColor
                        : Colors.transparent,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (HomeController.instance.selectedMapMode == mode)
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: SvgPicture.asset(mapTick),
                )
            ]);
          })
        ]),
      ),
    );
  }
}
