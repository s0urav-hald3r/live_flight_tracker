import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PlanContainer extends StatelessWidget {
  const PlanContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.instance;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      width: MediaQuery.of(context).size.width,
      child: Obx(() {
        return Column(children: [
          _planItem(
            weeklyPlan,
            Plan.WEEKLY,
            controller.selectedPlan,
          ),
          SizedBox(height: 8.h),
          _planItem(
            monthlyPlan,
            Plan.MONTHLY,
            controller.selectedPlan,
          ),
          SizedBox(height: 8.h),
          _planItem(
            yearlyPlan,
            Plan.YEARLY,
            controller.selectedPlan,
          ),
        ]);
      }),
    );
  }

  String getPlanIndentifier(Plan value) {
    switch (value) {
      case Plan.WEEKLY:
        return weeklyPlanIndentifier;
      case Plan.MONTHLY:
        return monthlyPlanIndentifier;
      case Plan.YEARLY:
        return yearlyPlanIndentifier;
    }
  }

  String getSubscriptionTenure(Plan value) {
    switch (value) {
      case Plan.WEEKLY:
        return 'week';
      case Plan.MONTHLY:
        return 'month';
      case Plan.YEARLY:
        return 'year';
    }
  }

  Widget _planItem(String icon, Plan cValue, Plan gValue) {
    StoreProduct? product = SettingsController.instance.storeProduct
        .firstWhereOrNull(
            (element) => element.identifier == getPlanIndentifier(cValue));

    return InkWell(
      onTap: () {
        HomeController.instance.selectedPlan = cValue;
      },
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: cValue == gValue ? primaryColor : Colors.transparent,
          ),
        ),
        child: Row(children: [
          SvgPicture.asset(icon),
          SizedBox(width: 16.w),
          Container(
            color: Colors.transparent,
            width: 235.w,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${product?.priceString ?? ''} / ${getSubscriptionTenure(cValue)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: whiteColor,
                    ),
                  ),
                  if (product?.introductoryPrice != null)
                    const Text(
                      'Try 3 days free, cancel anytime.',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: textColor,
                      ),
                    )
                  else
                    Text(
                      product?.description ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: textColor,
                      ),
                    )
                ]),
          ),
          const Spacer(),
          if (cValue == gValue)
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: primaryColor, width: 7.5),
                color: whiteColor,
              ),
            )
          else
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: whiteColor),
              ),
            )
        ]),
      ),
    );
  }
}
