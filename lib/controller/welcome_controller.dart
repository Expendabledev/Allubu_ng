import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:allubmarket/app/auth_screen/singup_screen.dart';
import 'package:allubmarket/app/dashboard_screen/dashboard_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class WelcomeController extends GetxController {
  Future<void> loginWithGoogle() async {
    ShowToastDialog.showLoader("Please wait".tr);
    await signInWithGoogle().then((value) async {
      ShowToastDialog.closeLoader();
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel();
          userModel.id = value.user!.uid;
          userModel.email = value.user!.email;
          userModel.firstName = value.user!.displayName;
          userModel.profilePic = value.user!.photoURL;
          userModel.loginType = Constant.googleLoginType;

          ShowToastDialog.closeLoader();
          Get.to(const SingUpScreen(), arguments: {
            "userModel": userModel,
          });
        } else {
          await FireStoreUtils.userExistOrNot(value.user!.uid)
              .then((userExit) async {
            ShowToastDialog.closeLoader();
            if (userExit == true) {
              UserModel? userModel =
                  await FireStoreUtils.getUserProfile(value.user!.uid);
              if (userModel != null) {
                if (userModel.isActive == true) {
                  Get.offAll(const DashBoardScreen());
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast(
                      "This user is disable please contact administrator".tr);
                }
              }
            } else {
              UserModel userModel = UserModel();
              userModel.id = value.user!.uid;
              userModel.email = value.user!.email;
              userModel.firstName = value.user!.displayName;
              userModel.profilePic = value.user!.photoURL;
              userModel.loginType = Constant.googleLoginType;

              Get.to(const SingUpScreen(), arguments: {
                "userModel": userModel,
              });
            }
          });
        }
      }
    });
  }

  Future<void> loginWithApple() async {
    ShowToastDialog.showLoader("Please wait".tr);
    await signInWithApple().then((value) {
      ShowToastDialog.closeLoader();
      if (value != null) {
        Map<String, dynamic> map = value;
        // AuthorizationCredentialAppleID appleCredential = map['appleCredential'];
        UserCredential userCredential = map['userCredential'];
        if (userCredential.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel();
          userModel.id = userCredential.user!.uid;
          userModel.email = userCredential.user!.email;
          userModel.profilePic = userCredential.user!.photoURL;
          userModel.loginType = Constant.appleLoginType;

          ShowToastDialog.closeLoader();
          Get.to(const SingUpScreen(), arguments: {
            "userModel": userModel,
          });
        } else {
          FireStoreUtils.userExistOrNot(userCredential.user!.uid)
              .then((userExit) async {
            ShowToastDialog.closeLoader();

            if (userExit == true) {
              UserModel? userModel =
                  await FireStoreUtils.getUserProfile(userCredential.user!.uid);
              if (userModel != null) {
                if (userModel.isActive == true) {
                  Get.offAll(const DashBoardScreen());
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast(
                      "This user is disable please contact administrator".tr);
                }
              }
            } else {
              UserModel userModel = UserModel();
              userModel.id = userCredential.user!.uid;
              userModel.email = userCredential.user!.email;
              userModel.profilePic = userCredential.user!.photoURL;
              userModel.loginType = Constant.googleLoginType;
              Get.to(const SingUpScreen(), arguments: {
                "userModel": userModel,
              });
            }
          });
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      if (googleUser.id.isEmpty) return null;

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }
  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().catchError((error) {
  //       ShowToastDialog.closeLoader();
  //       ShowToastDialog.showToast("something_went_wrong".tr);
  //       return null;
  //     });

  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  //     // Once signed in, return the UserCredential
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } catch (e) {
  //     debugPrint("signInWithGoogle :: $e");
  //   }
  //   return null;
  //   // Trigger the authentication flow
  // }

  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
        // webAuthenticationOptions: WebAuthenticationOptions(clientId: clientID, redirectUri: Uri.parse(redirectURL)),
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      return {
        "appleCredential": appleCredential,
        "userCredential": userCredential
      };
    } catch (e) {
      debugPrint("signInWithApple :: $e");
    }
    return null;
  }

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
