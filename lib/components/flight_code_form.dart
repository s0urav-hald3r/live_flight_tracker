import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/components/date_picker_widget.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/utils/extension.dart';

class FlightCodeForm extends StatelessWidget {
  const FlightCodeForm({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TicketClipper(hFactor: 0.5),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 161.5.h,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF323558),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48.h,
                  margin: EdgeInsets.fromLTRB(16.w, 16.h, 4.w, 16.h),
                  child: CupertinoTextField(
                    controller: HomeController.instance.flightCode,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.only(left: 16.w),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    ),
                    placeholder: 'AA',
                    textCapitalization: TextCapitalization.characters,
                    placeholderStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  height: 48.h,
                  margin: EdgeInsets.fromLTRB(4.w, 16.h, 16.w, 16.h),
                  child: CupertinoTextField(
                    controller: HomeController.instance.flightNumber,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: EdgeInsets.only(left: 16.w),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: whiteColor,
                    ),
                    placeholder: '1234',
                    keyboardType: TextInputType.number,
                    placeholderStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ],
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
              controller: HomeController.instance.date,
              readOnly: true,
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return const DatePickerWidget();
                    });
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

class TicketClipper extends CustomClipper<Path> {
  final double hFactor;

  TicketClipper({required this.hFactor});

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addOval(
      Rect.fromCircle(
        center: Offset(5.w, size.height * hFactor),
        radius: 20,
      ),
    );
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.width - 5.w, size.height * hFactor),
        radius: 20,
      ),
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
