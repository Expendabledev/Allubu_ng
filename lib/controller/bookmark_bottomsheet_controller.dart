import 'package:get/get.dart';
import 'package:allubmarket/models/bookmarks_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class BookmarkBottomSheetController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getMyCollection();
    super.onInit();
  }

  RxList<BookmarksModel> bookmarksList = <BookmarksModel>[].obs;

  Future<void> getMyCollection() async {
    await FireStoreUtils.getBookmarks(FireStoreUtils.getCurrentUid()).then(
      (value) {
        bookmarksList.value = value;
        bookmarksList.sort((a, b) {
          if (a.isDefault == true && b.isDefault != true) return -1;
          if (a.isDefault != true && b.isDefault == true) return 1;
          return 0;
        });
      },
    );
    isLoading.value = false;
  }
}
