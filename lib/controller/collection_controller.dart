import 'package:get/get.dart';
import 'package:allubmarket/models/bookmarks_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class CollectionController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getMyCollection();
    super.onInit();
  }

  RxList<BookmarksModel> bookmarksList = <BookmarksModel>[].obs;
  RxList<BookmarksModel> followingBookmarksList = <BookmarksModel>[].obs;

  Future<void> getMyCollection() async {
    isLoading.value = true;
    await FireStoreUtils.getBookmarks(FireStoreUtils.getCurrentUid()).then(
      (value) {
        bookmarksList.value = value;
        bookmarksList.sort((a, b) {
          // Sort by isDefault first (true values come first)
          if (a.isDefault == true && b.isDefault != true) return -1;
          if (a.isDefault != true && b.isDefault == true) return 1;
          return 0;
        });
      },
    );

    await FireStoreUtils.getFollowingBookmarks().then(
      (value) {
        followingBookmarksList.value = value;
      },
    );
    isLoading.value = false;
  }
}
