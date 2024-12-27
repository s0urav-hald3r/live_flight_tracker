import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:live_flight_tracker/controllers/home_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:live_flight_tracker/config/colors.dart';
import 'package:live_flight_tracker/config/constants.dart';
import 'package:live_flight_tracker/services/local_storage.dart';
import 'package:live_flight_tracker/services/overlay_loader.dart';

class SettingsController extends GetxController {
  static SettingsController get instance => Get.find();

  @override
  void onInit() {
    super.onInit();
    isPremium = LocalStorage.getData(isPremiumUser, KeyType.BOOL);
    callAPIs();
  }

  Future<void> callAPIs() async {
    await checkSubscriptionStatus();
    await fetchProducts();
  }

  // Variables
  final RxBool _isPremium = false.obs;
  final RxBool _isLoading = true.obs;

  final RxList<StoreProduct> _storeProduct = <StoreProduct>[].obs;

  // Getters
  bool get isPremium => _isPremium.value;
  bool get isLoading => _isLoading.value;

  List<StoreProduct> get storeProduct => _storeProduct;

  // Setters
  set isPremium(value) => _isPremium.value = value;
  set isLoading(value) => _isLoading.value = value;

  set storeProduct(value) => _storeProduct.value = value;

  // Functions
  Future fetchProducts() async {
    isLoading = true;

    try {
      final products = await Purchases.getProducts([
        weeklyPlanIndentifier,
        monthlyPlanIndentifier,
        yearlyPlanIndentifier,
      ]);
      debugPrint('store products: $products');

      storeProduct = products;
      isLoading = false;
    } catch (e, st) {
      isLoading = false;
      debugPrint('fetchProducts error: $e');
      debugPrint('fetchProducts stack: $st');
    }
  }

  String getPlanIndentifier() {
    switch (HomeController.instance.selectedPlan) {
      case Plan.WEEKLY:
        return weeklyPlanIndentifier;
      case Plan.MONTHLY:
        return monthlyPlanIndentifier;
      case Plan.YEARLY:
        return yearlyPlanIndentifier;
    }
  }

  StoreProduct getProduct() {
    return SettingsController.instance.storeProduct
        .firstWhere((element) => element.identifier == getPlanIndentifier());
  }

  Future purchaseProduct() async {
    OverlayLoader.show();
    try {
      final customerInfo = await Purchases.purchaseStoreProduct(getProduct());

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
      isPremium = false;
      LocalStorage.addData(isPremiumUser, false);
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
      LocalStorage.addData(isPremiumUser, isPremium);

      if (isPremium) {
        OverlayLoader.hide();
        // Grant access to premium features
        // (e.g., update UI or store the entitlement state locally)
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
      isPremium = false;
      LocalStorage.addData(isPremiumUser, false);
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
