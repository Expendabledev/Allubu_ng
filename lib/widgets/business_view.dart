import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/controller/business_view_controller.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';

class BusinessView extends StatelessWidget {
  final String businessId;
  final BusinessViewController businessViewController = Get.put(BusinessViewController());

  BusinessView({super.key, required this.businessId});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    businessViewController.fetchUser(businessId); // Fetch user only if not already in cache
    return Obx(() {
      if (!businessViewController.businessMap.containsKey(businessId)) {
        return Center(child: CircularProgressIndicator());
      }
      BusinessModel userModel = businessViewController.businessMap[businessId]!;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userModel.businessName.toString(),
            textAlign: TextAlign.start,
            style: TextStyle(
              color: themeChange.getThem()?AppThemeData.greyDark02:AppThemeData.grey02,
              fontSize: 16,
              fontFamily: AppThemeData.boldOpenSans,
            ),
          ),
        ],
      );
    });
  }
}
