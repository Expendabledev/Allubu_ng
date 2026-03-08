import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/constant/send_notification.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/models/email_template_model.dart';
import 'package:yelpify/models/pricing_request_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class PricingFormController extends GetxController {
  Rx<BusinessModel> businessModel = BusinessModel().obs;
  Rx<CategoryModel> categoryModel = CategoryModel().obs;
  RxBool isLoading = true.obs;
  Rx<TextEditingController> descriptionTextFieldController = TextEditingController().obs;
  RxList<BusinessModel> allBusinessList = <BusinessModel>[].obs;
  RxList images = <dynamic>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      businessModel.value = argumentData['businessModel'];
      categoryModel.value = argumentData['categoryModel'];
    }

    if (categoryModel.value.slug == null) {
      FireStoreUtils.getAllNearestRestaurantByCategoryId(
          Constant.currentLocation == null
              ? LatLng(Constant.currentLocationLatLng!.latitude, Constant.currentLocationLatLng!.longitude)
              : LatLng(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude),
          businessModel.value.category!.firstWhere(
            (element) => element.getPricingForm == true,
          )).listen((event) async {
        allBusinessList.clear();
        allBusinessList.addAll(event);
      });
    } else {
      FireStoreUtils.getAllNearestRestaurantByCategoryId(
              Constant.currentLocation == null
                  ? LatLng(Constant.currentLocationLatLng!.latitude, Constant.currentLocationLatLng!.longitude)
                  : LatLng(Constant.currentLocation!.latitude, Constant.currentLocation!.longitude),
              categoryModel.value)
          .listen((event) async {
        allBusinessList.clear();
        allBusinessList.addAll(event);
      });
    }

    isLoading.value = false;
    update();
  }

  Future<void> submitRequest() async {
    ShowToastDialog.showLoader("Please wait");
    for (int i = 0; i < images.length; i++) {
      if (images[i].runtimeType == XFile) {
        String url = await Constant.uploadUserImageToFireStorage(
          File(images[i].path),
          "${businessModel.value.id}/${Constant.menuItemPhotos}",
          File(images[i].path).path.split('/').last,
        );
        images.removeAt(i);
        images.insert(i, url);
      }
    }

    PricingRequestModel pricingRequestModel = PricingRequestModel();
    pricingRequestModel.id = Constant.getUuid();
    pricingRequestModel.businessIds = allBusinessList.map((b) => b.id).toList();
    pricingRequestModel.images = images;
    pricingRequestModel.userId = FireStoreUtils.getCurrentUid();
    pricingRequestModel.createdAt = Timestamp.now();
    pricingRequestModel.description = descriptionTextFieldController.value.text;
    pricingRequestModel.status = "active";
    pricingRequestModel.category = categoryModel.value.slug != null ? categoryModel.value : businessModel.value.category!.firstWhere((element) => element.getPricingForm == true);
    await FireStoreUtils.setPricingRequest(pricingRequestModel);

    Set<String> sentTokens = {};

    for (var business in allBusinessList) {
      final ownerId = business.ownerId;
      if (ownerId == null || ownerId.isEmpty) continue;

      final user = await FireStoreUtils.getUserProfile(ownerId);
      if (user == null) continue;

      final fcmToken = user.fcmToken;
      final email = user.email;

      if (fcmToken == null || fcmToken.isEmpty || sentTokens.contains(fcmToken)) continue;

      // Prepare notification payload
      final notificationPayload = {
        "type": "project_request",
        "projectId": pricingRequestModel.id.toString(),
        "businessId": business.id.toString(),
      };

      try {
        // Send FCM Notification
        await SendNotification.sendOneNotification(
          token: fcmToken,
          title: 'New Project Request in Your Area!',
          body: 'Someone nearby is looking for services like yours. Tap to view the details and send a quote before others do.',
          payload: notificationPayload,
        );

        // Send Email
        if (email != null && email.isNotEmpty) {
          await sendReviewEmail(
            recipientEmail: email,
            username: Constant.userModel?.fullName() ?? '',
            businessName: business.businessName ?? '',
            useremail: Constant.userModel?.email ?? '',
            userphone: Constant.userModel?.phoneNumber ?? '',
            date: Constant.formatTimestampToDateTime(pricingRequestModel.createdAt!),
          );
        }

        // Mark token as notified
        sentTokens.add(fcmToken);
      } catch (e) {
        print("Failed to notify or email user with ID $ownerId: $e");
        // You may also log this to Firebase Crashlytics or monitoring tool
      }
    }
    ShowToastDialog.closeLoader();
    Get.back();
  }

  Future<void> sendReviewEmail(
      {required String recipientEmail, required String username, required String businessName, required String useremail, required String userphone, required String date}) async {
    // Replace the placeholders in the HTML
    EmailTemplateModel? emailTemplateModel = await FireStoreUtils.getEmailTemplates('new_project_request');

    final emailBody = Constant.replacePlaceholders(emailTemplateModel!.message.toString(), {
      'username': username,
      'businessName': businessName,
      'useremail': useremail,
      'userphone': userphone,
      'date': date,
    });

    // Configure SMTP server
    final smtpServer = SmtpServer(
      '${Constant.mailSettings!.host}',
      username: '${Constant.mailSettings!.userName}',
      password: '${Constant.mailSettings!.password}', // Use App Password if 2FA is enabled
      port: int.parse(Constant.mailSettings!.port.toString()),
      ssl: true,
    );

    // Create the email message
    final message = Message()
      ..from = Address('${Constant.mailSettings!.userName}', 'Yelpify')
      ..recipients = emailTemplateModel.isSendToAdmin == true && emailTemplateModel.isSendToBusiness == true
          ? [recipientEmail, Constant.adminEmail]
          : emailTemplateModel.isSendToAdmin == true
              ? [Constant.adminEmail]
              : [recipientEmail]
      ..subject = '${emailTemplateModel.subject}'
      ..html = emailBody;

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
    } catch (e) {
      print('Email failed: $e');
    }
  }

  final ImagePicker _imagePicker = ImagePicker();

  Future pickFile({required ImageSource source}) async {
    try {
      XFile? image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      images.add(image);
      Get.back();
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("Failed to Pick : \n $e");
    }
  }
}
