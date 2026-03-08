import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yelpify/constant/show_toast_dialog.dart';
import 'package:http/http.dart' as http;
import '../constant/constant.dart';

class Utils {
  /// Get Current Location (Latitude & Longitude)
  static Future<Position?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(locationSettings: LocationSettings(accuracy: LocationAccuracy.high));

      return position;
    } catch (e) {
      print("Error getting location: $e");
    }
    return null;
  }

  static Future<void> shareMultipleImages({required List<String> imageUrls, required String description}) async {
    try {
      ShowToastDialog.showLoader("Please wait");

      List<XFile> imageFiles = [];

      final tempDir = await getTemporaryDirectory();

      for (int i = 0; i < imageUrls.length; i++) {
        final imageUrl = imageUrls[i];
        final response = await http.get(Uri.parse(imageUrl));

        if (response.statusCode == 200) {
          final file = File('${tempDir.path}/shared_image_$i.jpg');
          await file.writeAsBytes(response.bodyBytes);
          imageFiles.add(XFile(file.path));
        } else {
          print('Failed to download image: $imageUrl');
        }
      }

      ShowToastDialog.closeLoader();

      if (imageFiles.isNotEmpty) {
        await SharePlus.instance.share(ShareParams(
          files: imageFiles,
          text: Constant.applicationName,
          subject: description,
        ));
      } else {
        print('No images to share');
      }
    } catch (e) {
      ShowToastDialog.closeLoader();
      print('Error sharing multiple images: $e');
    }
  }

  static Future<void> shareBusiness(String description) async {
    try {
      SharePlus.instance.share(ShareParams(text: description));
    } catch (e) {
      print('Error sharing image: $e');
    }
  }

  static Future<void> sendSMS({required String phoneNumber, required String message}) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': message,
      },
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw 'Could not launch SMS';
    }
  }

  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> dialPhoneNumber(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  static Future<void> openMap({required double lat, required double lng, String? label}) async {
    final encodedLabel = Uri.encodeComponent(label ?? "Destination");

    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$encodedLabel';
    String appleUrl = 'http://maps.apple.com/?daddr=$lat,$lng&q=$encodedLabel';

    final Uri url = Uri.parse(Platform.isIOS ? appleUrl : googleUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch map at $url';
    }
  }

  static Future<Uint8List> getBytesFromUrl(String url, {int width = 100}) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load image from $url');
    }

    final codec = await ui.instantiateImageCodec(
      response.bodyBytes,
      targetWidth: width,
    );
    final frame = await codec.getNextFrame();
    final byteData = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
