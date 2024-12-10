import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/extension.dart';
import 'package:live_flight_tracker/config/icons.dart';

class PlanContainer extends StatelessWidget {
  const PlanContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        _planItem(
          weeklyPlan,
          '₹369.00/week',
          'weekly',
          'weekly',
          (value) {},
        ),
        SizedBox(height: 8.h),
        _planItem(
          monthlyPlan,
          '₹999.00/month',
          'monthly',
          'weekly',
          (value) {},
        ),
        SizedBox(height: 8.h),
        _planItem(
          yearlyPlan,
          '₹5,400.00/year',
          'yearly',
          'weekly',
          (value) {},
        ),
      ]),
    );
  }

  Container _planItem(String icon, String price, String cValue, String gValue,
      ValueChanged callBack) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor),
      ),
      child: Row(children: [
        SvgPicture.asset(icon),
        SizedBox(width: 16.w),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: whiteColor,
                ),
              ),
              const Text(
                'Try 3 days free, cancel anytime.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ]),
        const Spacer(),
        cValue == gValue
            ? Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: primaryColor, width: 7.5),
                  color: whiteColor,
                ),
              )
            : Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: whiteColor),
                ),
              )
      ]),
    );
  }
}
