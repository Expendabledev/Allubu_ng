import 'package:get/get.dart';
import 'package:allubmarket/app/collection_screen/collection_screen.dart';
import 'package:allubmarket/app/home_screen/home_screen.dart';
import 'package:allubmarket/app/more_screen/more_screen.dart';
import 'package:allubmarket/app/profile_screen/profile_screen.dart';
import 'package:allubmarket/app/project_screen/project_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/utils.dart';

class DashBoardController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxList pageList = [].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    pageList.value = FireStoreUtils.getCurrentUid() != ''
        ? [
            const HomeScreen(),
            const ProjectScreen(),
            const ProfileScreen(),
            const CollectionScreen(),
            const MoreScreen(),
          ]
        : [
            const HomeScreen(),
            const MoreScreen(),
          ];

    getCurrentLocation();
    super.onInit();
  }

  Future<void> getCurrentLocation() async {
    if (FireStoreUtils.getCurrentUid() != '')
      await FireStoreUtils.getCurrentUserModel();
    Constant.currentLocation = await Utils.getCurrentLocation();
  }

  DateTime? currentBackPressTime;
  RxBool canPopNow = false.obs;
}
