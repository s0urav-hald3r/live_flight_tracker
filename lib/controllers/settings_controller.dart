import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/services/local_storage.dart';
import 'package:live_flight_tracker/services/navigator_key.dart';
import 'package:live_flight_tracker/services/overlay_loader.dart';
import 'package:live_flight_tracker/views/premium_view.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  // @override
  // void onInit() {
  //   super.onInit();
  //   callAPIs();
  // }

  Future<void> callAPIs() async {
    await checkSubscriptionStatus();
    await fetchProducts();
  }

  // Variables
  final RxBool _isPremium = false.obs;

  final RxList<StoreProduct> _storeProduct = <StoreProduct>[].obs;

  // Getters
  bool get isPremium => _isPremium.value;

  List get storeProduct => _storeProduct;

  // Setters
  set isPremium(value) => _isPremium.value = value;

  set storeProduct(value) => _storeProduct.value = value;

  // Functions
  Future fetchProducts() async {
    try {
      final offerings = await Purchases.getOfferings();
      Offering? offering = offerings.current;
      if (offering != null) {
        // Look for the package with a trial period
        Package? weeklyPlan = offering.getPackage('\$rc_monthly');
        debugPrint('weeklyPlan: $weeklyPlan');

        if (weeklyPlan != null) {
          StoreProduct storeProduct = weeklyPlan.storeProduct;
          _storeProduct.add(storeProduct);

          debugPrint(
              'Free Product title: ${storeProduct.introductoryPrice?.price}');
          debugPrint(
              'Free Product price: ${storeProduct.introductoryPrice?.priceString}');
          debugPrint(
              'Free Product duration: ${storeProduct.introductoryPrice?.period}'); // Should show 3 days
        }

        // Don't redirect if user is not complete onboarding process yet
        if (!LocalStorage.getData(isOnboardingDone, KeyType.BOOL)) return;

        // Don't redirect if user is already subscribed
        if (isPremium) return;

        // Don't redirect if there is no purchase product
        if (storeProduct.isEmpty) return;

        NavigatorKey.push(const PremiumView());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future purchaseProduct(StoreProduct storeProduct) async {
    OverlayLoader.show();
    try {
      final customerInfo = await Purchases.purchaseStoreProduct(storeProduct);

      // Access customer information to verify the active subscriptions
      if (customerInfo.activeSubscriptions.isNotEmpty) {
        debugPrint("User successfully subscribed with free trial!");
        isPremium = true;
        LocalStorage.addData(isPremiumUser, true);
        OverlayLoader.hide();
        Get.back();
        Get.snackbar('', '',
            icon: const Icon(Icons.done),
            shouldIconPulse: true,
            titleText: const Text(
              'Success',
              style: TextStyle(
                  fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold),
            ),
            messageText: const Text(
              'Subscription purchase successfully !',
              style: TextStyle(fontSize: 14, color: whiteColor),
            ),
            backgroundColor: primaryColor,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        OverlayLoader.hide();
      }

      debugPrint('customerInfo while purchase: $customerInfo');
    } on PlatformException catch (e) {
      debugPrint('error: $e');
      OverlayLoader.hide();
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint('PurchasesErrorCode.purchaseCancelledError');
      }
    }
  }

  Future restorePurchases() async {
    OverlayLoader.show();
    await Future.delayed(const Duration(seconds: 1));
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      debugPrint('customerInfo while restore: $customerInfo');

      // Check if the user has the required entitlement
      isPremium = customerInfo.entitlements.active.containsKey(entitlementID);

      if (isPremium) {
        OverlayLoader.hide();
        // Grant access to premium features
        // (e.g., update UI or store the entitlement state locally)
        LocalStorage.addData(isPremiumUser, true);
        Get.back();
        Get.snackbar('', '',
            icon: const Icon(Icons.done),
            shouldIconPulse: true,
            titleText: const Text(
              'Success',
              style: TextStyle(
                  fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold),
            ),
            messageText: const Text(
              'Subscription restored successfully !',
              style: TextStyle(fontSize: 14, color: whiteColor),
            ),
            backgroundColor: primaryColor,
            snackPosition: SnackPosition.BOTTOM);
      } else {
        OverlayLoader.hide();
        Get.snackbar('', '',
            icon: const Icon(Icons.error),
            shouldIconPulse: true,
            titleText: const Text(
              'Failed',
              style: TextStyle(
                  fontSize: 16, color: whiteColor, fontWeight: FontWeight.bold),
            ),
            messageText: const Text(
              'Subscription not found !',
              style: TextStyle(fontSize: 14, color: whiteColor),
            ),
            backgroundColor: primaryColor,
            snackPosition: SnackPosition.BOTTOM);
      }
    } on PlatformException catch (e) {
      OverlayLoader.hide();
      debugPrint('error: $e');
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.receiptAlreadyInUseError) {
        debugPrint('PurchasesErrorCode.receiptAlreadyInUseError');
      }
      if (errorCode == PurchasesErrorCode.missingReceiptFileError) {
        debugPrint('PurchasesErrorCode.missingReceiptFileError');
      }
    }
  }

  Future checkSubscriptionStatus() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      debugPrint('customerInfo: $customerInfo');

      // Replace "your_entitlement_id" with the ID of your entitlement in RevenueCat
      EntitlementInfo? entitlement =
          customerInfo.entitlements.all[entitlementID];
      if (entitlement != null && entitlement.isActive) {
        isPremium = true;
        LocalStorage.addData(isPremiumUser, true);
      } else {
        isPremium = false;
        LocalStorage.addData(isPremiumUser, false);
      }
      debugPrint('isPremiumUser: $isPremium');
    } catch (e) {
      debugPrint("Error fetching subscription status: $e");
      isPremium = false;
      LocalStorage.addData(isPremiumUser, false);
    }
  }
}
