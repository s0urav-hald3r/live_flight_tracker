import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/components/route_form.dart';
import 'package:live_flight_tracker/components/search_toggle.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class SearchFlightsView extends StatelessWidget {
  const SearchFlightsView({super.key});

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
                    'Search Flight',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                  const Text('  '),
                ]),
          ),
          SizedBox(height: 8.h),
          const SearchToggle(),
          SizedBox(height: 4.h),
          const RouteForm()
        ]),
      ),
    );
  }
}
