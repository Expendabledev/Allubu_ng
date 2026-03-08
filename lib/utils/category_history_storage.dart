import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yelpify/models/category_history_model.dart';

class CategoryHistoryStorage {
  static const String _key = 'category_history_list';

  /// Add a single CategoryHistoryModel to the existing list
  static Future<void> addCategoryHistoryItem(CategoryHistoryModel newItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load existing list
    List<String> jsonList = prefs.getStringList(_key) ?? [];

    // Convert to models
    List<CategoryHistoryModel> rawList = jsonList.map((jsonStr) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      return CategoryHistoryModel.fromJson(jsonMap);
    }).toList();

    // Remove any existing item with the same slug
    rawList.removeWhere((item) => item.category?.slug == newItem.category?.slug);

    // Add new item
    rawList.add(newItem);

    // Convert back to string list
    List<String> updatedJsonList = rawList.map((item) => jsonEncode(item.toJson())).toList();

    // Save
    await prefs.setStringList(_key, updatedJsonList);
  }

  /// Get the full list
  static Future<List<CategoryHistoryModel>> getCategoryHistoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_key);

    if (jsonList == null) return [];

    // Parse list
    List<CategoryHistoryModel> rawList = jsonList.map((jsonStr) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      return CategoryHistoryModel.fromJson(jsonMap);
    }).toList();

    // Remove duplicates by category ID
    final Map<String, CategoryHistoryModel> uniqueMap = {};
    for (var item in rawList) {
      final categoryId = item.category?.slug ?? ''; // You can use name instead
      if (categoryId.isNotEmpty) {
        uniqueMap[categoryId] = item; // overwrite to keep the latest
      }
    }

    return uniqueMap.values.toList();
  }

  /// Optional: Clear the stored list
  static Future<void> clearCategoryHistoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
