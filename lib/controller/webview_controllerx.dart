import 'dart:developer';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewControllerX extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    getArgument();
    super.onInit();
  }

  RxBool isLoading = true.obs;
  Rx<WebViewController> webcontroller = WebViewController().obs;
  RxString url = ''.obs;

  void getArgument() {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      url.value = argumentData['url'];
      webcontroller.value = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              // Update loading bar.
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) {},
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            // onNavigationRequest: (NavigationRequest request) {
            //   if (request.url.startsWith('https://www.youtube.com/')) {
            //     return NavigationDecision.prevent;
            //   }
            //   return NavigationDecision.navigate;
            // },
          ),
        )
        ..loadRequest(Uri.parse(url.value));
    }
    isLoading.value = false;
    update();
    log("Url.value :: ${url.value}");
  }
}
