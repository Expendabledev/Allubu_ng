import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:allubmarket/models/business_history_model.dart';

class BusinessHistoryStorage {
  static const String _key = 'business_history_list';

  /// Add a single BusinessHistoryModel to the existing list
  static Future<void> addCategoryHistoryItem(
      BusinessHistoryModel newItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load existing list
    List<String> jsonList = prefs.getStringList(_key) ?? [];

    // Convert to models
    List<BusinessHistoryModel> rawList = jsonList.map((jsonStr) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      return BusinessHistoryModel.fromJson(jsonMap);
    }).toList();

    // Remove any existing item with the same slug
    rawList.removeWhere((item) => item.business!.id == newItem.business?.id);

    // Add new item
    rawList.add(newItem);

    // Convert back to string list
    List<String> updatedJsonList =
        rawList.map((item) => jsonEncode(item.toJson())).toList();

    // Save
    await prefs.setStringList(_key, updatedJsonList);
  }

  /// Get the full list
  static Future<List<BusinessHistoryModel>> getCategoryHistoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(_key);

    if (jsonList == null) return [];

    // Parse list
    List<BusinessHistoryModel> rawList = jsonList.map((jsonStr) {
      Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
      return BusinessHistoryModel.fromJson(jsonMap);
    }).toList();

    // Remove duplicates by category ID
    final Map<String, BusinessHistoryModel> uniqueMap = {};
    for (var item in rawList) {
      final categoryId = item.business!.id ?? ''; // You can use name instead
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
