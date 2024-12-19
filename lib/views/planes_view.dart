import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/components/plane_card.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/services/local_storage.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class PlanesView extends StatelessWidget {
  final Function callBack;
  const PlanesView({super.key, required this.callBack});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;

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
                    'Planes',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: whiteColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      LocalStorage.addData(planeIndex,
                          HomeController.instance.selectedPlaneIndex);
                      callBack();
                      NavigatorKey.pop();
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
          SizedBox(height: 16.h),
          Expanded(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 16.w, // Horizontal spacing
                  mainAxisSpacing: 16.h, // Vertical spacing
                  childAspectRatio: 0.85, // width/height ratio
                ),
                itemCount: controller.flightDetails.length,
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w), // Number of items
                itemBuilder: (context, index) {
                  final flight = controller.flightDetails[index];

                  return PlaneCard(model: flight, index: index);
                }),
          ),
        ]),
      ),
    );
  }
}
