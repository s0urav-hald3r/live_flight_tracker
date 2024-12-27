import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/components/plan_container.dart';
import 'package:live_flight_tracker/components/premium_appbar.dart';
import 'package:live_flight_tracker/components/premium_links.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/utils/extension.dart';
import 'package:live_flight_tracker/config/icons.dart';
import 'package:live_flight_tracker/config/images.dart';
import 'package:live_flight_tracker/controllers/settings_controller.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PremiumView extends StatefulWidget {
  const PremiumView({super.key});

  @override
  State<PremiumView> createState() => _PremiumViewState();
}

class _PremiumViewState extends State<PremiumView> {
  bool _showAppbar = false;
  final controller = SettingsController.instance;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showAppbar = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(children: [
          Image.asset(premiumBg),
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  bgColor.withOpacity(.1),
                  bgColor,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            width: size.width,
            height: size.height,
            child: SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showAppbar) const PremiumAppBar(),
                    const Spacer(),
                    SizedBox(height: 16.h),
                    const Text(
                      'Choose Your Plan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: whiteColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    const Text(
                      'Go Beyond Limits!  Unlimited access, personalized tracking, and seamless searches',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(() {
                      return Skeletonizer(
                        enabled: controller.isLoading,
                        child: const PlanContainer(),
                      );
                    }),
                    Obx(() {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: 48.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: controller.isLoading
                              ? primaryColor.withOpacity(.5)
                              : primaryColor,
                        ),
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : () {
                                  controller.purchaseProduct();
                                },
                          child: Text(
                            controller.isPremium ? 'Subscribed' : 'Continue ≻',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: controller.isLoading
                                  ? whiteColor.withOpacity(.5)
                                  : whiteColor,
                            ),
                          ),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(verified),
                            SizedBox(width: 8.w),
                            const Text(
                              'No Payment Now',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: whiteColor,
                              ),
                            )
                          ]),
                    ),
                    const PremiumLinks(),
                    SizedBox(height: 16.h)
                  ]),
            ),
          )
        ]),
      ),
    );
  }
}
