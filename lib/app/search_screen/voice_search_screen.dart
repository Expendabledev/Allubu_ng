import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:yelpify/controller/voice_search_controller.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/utils/dark_theme_provider.dart';

class VoiceSearchScreen extends StatelessWidget {
  const VoiceSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: VoiceSearchController(),
        builder: (controller) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  controller.status.value == 'done'
                      ? Text(
                          "Tap the mic to start voice recognition".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: themeChange.getThem() ? AppThemeData.surfaceDark50 : AppThemeData.surface50,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : Text(
                          "Speak now".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: themeChange.getThem() ? AppThemeData.surfaceDark50 : AppThemeData.surface50,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                  const SizedBox(height: 20),
                  controller.status.value == 'done'
                      ? InkWell(
                          onTap: () {
                            controller.startListening();
                          },
                          child: Container(
                            height: controller.micSize.value + 40.0,
                            width: controller.micSize.value + 40,
                            decoration: BoxDecoration(
                              color: AppThemeData.greyDark04.withOpacity(0.8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppThemeData.greyDark04.withOpacity(0.6),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mic,
                              size: 50,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            controller.stopListening(duration: 1);
                          },
                          child: Container(
                            height: controller.micSize.value + 40.0,
                            width: controller.micSize.value + 40,
                            decoration: BoxDecoration(
                              color: AppThemeData.red02.withOpacity(0.8),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppThemeData.red02.withOpacity(0.6),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mic,
                              size: 50,
                            ),
                          ),
                        ),
                  const SizedBox(height: 30),
                  const SizedBox(height: 40),
                  if (controller.status.value != 'done')
                    Image.asset(
                      'assets/images/voice_wave.gif',
                      height: 100,
                    ),
                  const SizedBox(height: 20),
                  if (controller.status.value == 'listening' || controller.recognizedText.value != 'Listening...')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        controller.recognizedText.value.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      controller.stopListening(duration: 0);
                    },
                    child: Text(
                      "Click to Back".tr,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppThemeData.red02,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
