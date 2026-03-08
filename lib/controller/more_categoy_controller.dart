import 'package:get/get.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class MoreCategoryController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<CategoryModel> subCategoryList = <CategoryModel>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getParentCategory();
    super.onInit();
  }

  Future<void> getParentCategory() async {
    await FireStoreUtils.categoryParentList().then(
      (value) {
        categoryList.value = value;
      },
    );
    isLoading.value = false;
  }

  Future<void> getSubCategory(CategoryModel model) async {
    await FireStoreUtils.subCategoryParentList(model).then(
      (value) {
        subCategoryList.value = value;
        print("===>${subCategoryList.length}");
      },
    );
    isLoading.value = false;
  }
}
