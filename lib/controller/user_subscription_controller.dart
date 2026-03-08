import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:yelpify/constant/constant.dart' show Constant;
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/subscription_ads_history.dart';
import 'package:yelpify/models/subscription_ads_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class UserSubscriptionController extends GetxController {
  final InAppPurchase _iap = InAppPurchase.instance;
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final RxBool isAvailable = false.obs;
  final Rx<PurchaseDetails?> latestPurchase = Rx<PurchaseDetails?>(null);

  RxBool isLoading = true.obs;

  Rx<UserModel> userModel = UserModel().obs;
  RxList<SubscriptionAdsModel> subscriptionAdsList = <SubscriptionAdsModel>[].obs;

  Rx<ProductDetails?> selectedProduct = Rx<ProductDetails?>(null);
  List<String> kProductIds = <String>{}.toList();

  RxBool isPaymentPending = false.obs;
  RxString pendingProductId = ''.obs;

  Timer? pendingTimer;

  final Set<String> _handledPurchases = <String>{};
  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<void> getData() async {
    await FireStoreUtils.getSubscriptionAds().then(
      (value) {
        subscriptionAdsList.value = value;
        kProductIds = subscriptionAdsList
            .where((plan) => plan.enable == true) // Optional: only enabled plans
            .map((plan) => Platform.isIOS ? plan.iosPlanId : plan.androidPlanId)
            .whereType<String>() // Filters out nulls
            .toList();
      },
    );
    await FireStoreUtils.getCurrentUserModel().then(
      (value) {
        if (value != null) {
          userModel.value = value;
        }
      },
    );
    await initStoreInfo();

    isLoading.value = false;
  }

  Future<void> initStoreInfo() async {
    if (_purchaseSubscription != null) return; // Don't reattach

    final bool available = await _iap.isAvailable();
    isAvailable.value = available;
    if (!available) return;

    final ProductDetailsResponse response = await _iap.queryProductDetails(kProductIds.toSet());
    products.assignAll(response.productDetails);

    // Attach listener once
    _purchaseSubscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _purchaseSubscription = null,
      onError: (e) {
        print("Purchase Stream Error: $e");
      },
    );
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      final purchaseKey = purchaseDetails.purchaseID ?? purchaseDetails.transactionDate ?? purchaseDetails.productID;

      // Avoid duplicate handling
      if (_handledPurchases.contains(purchaseKey)) {
        continue;
      }

      log("===>${purchaseDetails.productID}");
      log("===>${purchaseDetails.status}");
      log("===");

      final isCurrentPurchase = pendingProductId.value == purchaseDetails.productID;

      if (purchaseDetails.status == PurchaseStatus.purchased && isCurrentPurchase) {
        _handledPurchases.add(purchaseKey);
        isPaymentPending.value = false;
        pendingProductId.value = '';
        await completeSubscription(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.restored) {
        // Handle restoration if required
      } else if (purchaseDetails.status == PurchaseStatus.canceled || purchaseDetails.status == PurchaseStatus.error) {
        isPaymentPending.value = false;
        pendingProductId.value = '';
        Get.defaultDialog(
          title: "Payment Failed".tr,
          middleText: "Payment was not completed. Please try again.".tr,
        );
      }
    }
  }

  void subscribeTo(ProductDetails productDetails) {
    // Prevent re-attempt during pending
    if (isPaymentPending.value && pendingProductId.value == productDetails.id) {
      Get.defaultDialog(
        title: "Pending Payment".tr,
        middleText: "Your last payment is not completed. Please wait or cancel it from Play Store/Apple Subscriptions.".tr,
      );
      return;
    }

    // Prevent re-subscribe to same active plan
    if (latestPurchase.value != null && latestPurchase.value!.productID == productDetails.id && latestPurchase.value!.status == PurchaseStatus.purchased) {
      Get.defaultDialog(
        title: "Already Subscribed".tr,
        middleText: "You're already subscribed to this plan. Cancel it before subscribing again or choose a different one.".tr,
      );
      return;
    }

    final purchaseParam = PurchaseParam(productDetails: productDetails);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
    isPaymentPending.value = true;
    pendingProductId.value = productDetails.id;

    pendingTimer?.cancel();
    pendingTimer = Timer(Duration(minutes: 2), () {
      resetPendingPurchase();
    });
  }

  Future<void> completeSubscription(PurchaseDetails purchase) async {
    SubscriptionAdsModel model = getSubscriptionModel(purchase.productID);

    Subscription subscription = Subscription();
    subscription.productID = purchase.productID;
    subscription.purchaseID = purchase.purchaseID;
    subscription.platform = Platform.isIOS ? "ios" : "android";
    subscription.expireDate = model.duration == '-1' ? null : Constant.addDayInTimestamp(days: model.duration, date: Timestamp.now());
    userModel.value.subscription = subscription;

    await FireStoreUtils.updateUser(userModel.value);

    SubscriptionAdsHistory subscriptionAdsHistory = SubscriptionAdsHistory();
    subscriptionAdsHistory.id = Constant.getUuid();
    subscriptionAdsHistory.productID = purchase.productID;
    subscriptionAdsHistory.purchaseID = purchase.purchaseID;
    subscriptionAdsHistory.transactionDate = purchase.transactionDate;
    subscriptionAdsHistory.verificationData = purchase.verificationData.localVerificationData;
    subscriptionAdsHistory.status = purchase.status.name;
    subscriptionAdsHistory.platform = Platform.isIOS ? "ios" : "android";
    subscriptionAdsHistory.subscription = model;
    subscriptionAdsHistory.userId = userModel.value.id;
    subscriptionAdsHistory.price = model.price;
    subscriptionAdsHistory.createdAt = Timestamp.now();

    subscriptionAdsHistory.expireDate = model.duration == '-1' ? null : Constant.addDayInTimestamp(days: model.duration, date: Timestamp.now());
    await FireStoreUtils.setSubscriptionAdsHistory(subscriptionAdsHistory);

    ShowToastDialog.showToast("Purchase successful");
    Get.back();
  }

  @override
  void onClose() {
    super.onClose();
    resetPendingPurchase(); // When user closes the subscription screen
  }

  void resetPendingPurchase() {
    isPaymentPending.value = false;
    pendingProductId.value = '';
    _purchaseSubscription?.cancel();
    _purchaseSubscription = null;
    pendingTimer?.cancel();
  }

  @override
  void dispose() {
    resetPendingPurchase(); // When user closes the subscription screen
    super.dispose();
  }

  SubscriptionAdsModel getSubscriptionModel(String planId) {
    return subscriptionAdsList.firstWhere((p0) => Platform.isIOS ? p0.iosPlanId == planId : p0.iosPlanId == planId);
  }
}
