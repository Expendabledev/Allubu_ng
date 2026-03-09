import 'dart:async';

import 'package:get/get.dart';
import 'package:allubmarket/constant/collection_name.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class MoreScreenController extends GetxController {
  RxList<BusinessModel> businessList = <BusinessModel>[].obs;

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getBusiness();
    super.onInit();
  }

  Future<void> getBusiness() async {
    await FireStoreUtils.getMyBusiness().then(
      (value) {
        businessList.value = value;
      },
    );

    isLoading.value = false;
    update();
  }

  Stream<int> getLiveCount(BusinessModel businessModel) async* {
    final projectRequests = await FireStoreUtils.fireStore
        .collection(CollectionName.projectRequest)
        .where("businessIds", arrayContains: businessModel.id)
        .get();

    if (projectRequests.docs.isEmpty) {
      yield 0;
      return;
    }

    yield* Stream.multi((controller) {
      List<int> counts = List.filled(projectRequests.docs.length, 0);

      for (int i = 0; i < projectRequests.docs.length; i++) {
        final docId = projectRequests.docs[i].id;

        FireStoreUtils.fireStore
            .collection(CollectionName.projectRequest)
            .doc(docId)
            .collection("chat")
            .where("receiverId", isEqualTo: businessModel.id)
            .where("isRead", isEqualTo: false)
            .snapshots()
            .listen((snapshot) {
          counts[i] = snapshot.docs.length;
          int total = counts.fold(0, (int sum, int count) => sum + count);
          controller.add(total);
        }, onError: (e) {
          counts[i] = 0;
          int total = counts.fold(0, (int sum, int count) => sum + count);
          controller.add(total);
        });
      }
    });
  }

  RxBool isShow = false.obs;
  RxBool isAdminShow = false.obs;
}
