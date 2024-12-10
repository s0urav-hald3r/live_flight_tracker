import 'package:fadingpageview/fadingpageview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/config/extension.dart';
import 'package:live_flight_tracker/config/images.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:live_flight_tracker/services/local_storage.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/views/premium_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  FadingPageViewController pageController = FadingPageViewController(0, 3);
  final controller = HomeController.instance;

  DateTime? lastTapTime;

  final contentBody = [
    {
      'image': onboarding1,
      'title': 'Welcome to Live Flight Tracker',
      'description':
          'Track your flights with ease, stay informed, and travel stress-free.'
    },
    {
      'image': onboarding2,
      'title': 'Real-Time Flight Updates',
      'description':
          'Get instant updates on flight statuses, delays, and gate changes.'
    },
    {
      'image': onboarding3,
      'title': 'Let’s Make Travel Simple!',
      'description':
          'Start your journey with the ultimate flight tracking experience.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(children: [
        SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FadingPageView(
                controller: pageController,
                disableWhileAnimating: true,
                fadeInDuration: const Duration(milliseconds: 250),
                fadeOutDuration: const Duration(milliseconds: 250),
                itemBuilder: (context, itemIndex) {
                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
                    child: Column(children: [
                      SizedBox(
                        width: 300.w,
                        child: Image.asset(
                          contentBody[itemIndex]['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: 60.h,
                        child: Image.asset(onboardingShadow),
                      ),
                      Text(
                        contentBody[itemIndex]['title']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        contentBody[itemIndex]['description']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: whiteColor,
                        ),
                      ),
                    ]),
                  );
                }),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: SafeArea(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Obx(() {
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.onboardingIndex == index
                            ? const Color(0xFFD2DDF4)
                            : const Color(0xFF323558),
                      ),
                    );
                  });
                }),
              ),
              SizedBox(height: 50.h),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 50.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: primaryColor,
                ),
                child: ElevatedButton(
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: whiteColor,
                    ),
                  ),
                  onPressed: () {
                    final cTime = DateTime.now();
                    if (lastTapTime == null ||
                        cTime.difference(lastTapTime!) >
                            const Duration(milliseconds: 500)) {
                      lastTapTime = cTime;
                      // Your button action here
                      debugPrint("Button tapped");
                    } else {
                      debugPrint("Double tap detected - ignored");
                      return;
                    }

                    if (controller.onboardingIndex < 2) {
                      controller.onboardingIndex++;

                      pageController.next();
                    } else {
                      LocalStorage.addData(isOnboardingDone, false);
                      NavigatorKey.pushReplacement(const PremiumView(),
                          routeName: '/onboardingToPremium');
                    }
                  },
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }
}
