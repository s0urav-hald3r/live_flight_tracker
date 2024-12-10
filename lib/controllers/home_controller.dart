import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  // Private variables
  final RxInt _onboardingIndex = 0.obs;

  // Getters
  int get onboardingIndex => _onboardingIndex.value;

  // Setters
  set onboardingIndex(value) => _onboardingIndex.value = value;
}
