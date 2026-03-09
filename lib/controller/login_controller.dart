import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:allubmarket/app/auth_screen/otp_screen.dart';
import 'package:allubmarket/app/auth_screen/singup_screen.dart';
import 'package:allubmarket/app/dashboard_screen/dashboard_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';

class LoginController extends GetxController {
  RxBool isEmailSelected = true.obs;
  Rx<TextEditingController> phoneNumberTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> countryCodeController =
      TextEditingController(text: Constant.defaultCountryCode).obs;
  Rx<TextEditingController> countryISOCodeController =
      TextEditingController(text: Constant.defaultCountryCode).obs;
  Rx<TextEditingController> emailTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> passwordTextFieldController =
      TextEditingController().obs;

  RxBool passwordVisible = true.obs;

  Future<void> signInWithEmailPassword() async {
    try {
      if (emailTextFieldController.value.text.isEmpty) {
        ShowToastDialog.showToast("Please enter a valid email'id.".tr);
        return;
      } else if (passwordTextFieldController.value.text.isEmpty) {
        ShowToastDialog.showToast("Please enter a valid password.".tr);
        return;
      } else {
        ShowToastDialog.showLoader("Please wait".tr);
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextFieldController.value.text.trim(),
          password: passwordTextFieldController.value.text.trim(),
        );
        if (credential.user != null) {
          FireStoreUtils.userExistOrNot(credential.user!.uid)
              .then((userExit) async {
            ShowToastDialog.closeLoader();

            if (userExit == true) {
              UserModel? userModel =
                  await FireStoreUtils.getUserProfile(credential.user!.uid);
              if (userModel != null) {
                print(userModel.toJson().toString());
                if (userModel.isActive == true) {
                  Get.offAll(const DashBoardScreen());
                } else {
                  await FirebaseAuth.instance.signOut();
                  ShowToastDialog.showToast(
                      "This user is disable please contact administrator".tr);
                }
              }
            } else {
              ShowToastDialog.showToast("This user is not available.".tr);
            }
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      ShowToastDialog.closeLoader();
      if (e.code == 'weak-password') {
        ShowToastDialog.showToast("The password provided is too weak.".tr);
      } else if (e.code == 'email-already-in-use') {
        ShowToastDialog.showToast(
            "The account already exists for that email.".tr);
      } else if (e.code == 'invalid-email') {
        ShowToastDialog.showToast("Enter email is Invalid".tr);
      } else if (e.code == 'invalid-email') {
        ShowToastDialog.showToast("${e.message}".tr);
      } else if (e.code == 'invalid-credential') {
        ShowToastDialog.showToast("Invalid credential".tr);
      } else {
        ShowToastDialog.showToast("${e.message}".tr);
      }
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
  }

  Future<void> sendCode() async {
    ShowToastDialog.showLoader("Please wait".tr);
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: countryCodeController.value.text +
          phoneNumberTextFieldController.value.text,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        debugPrint("FirebaseAuthException--->${e.message}");
        ShowToastDialog.closeLoader();
        if (e.code == 'invalid-phone-number') {
          ShowToastDialog.showToast("Enter valid phone number".tr);
        } else {
          ShowToastDialog.showToast(e.code);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        ShowToastDialog.closeLoader();
        Get.to(const OtpScreen(), arguments: {
          "countryCode": countryCodeController.value.text,
          'countryISOCode': countryISOCodeController.value.text,
          "phoneNumber": phoneNumberTextFieldController.value.text,
          "verificationId": verificationId,
          "resendToken": resendToken
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((error) {
      debugPrint("catchError--->$error");
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast("multiple_time_request".tr);
    });
  }

  // Future<UserCredential?> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn().catchError((error) {
  //       ShowToastDialog.closeLoader();
  //       ShowToastDialog.showToast("something_went_wrong".tr);
  //       return null;
  //     });

  //     final email = googleUser?.email;

  //     UserModel? userModel = await FireStoreUtils.getUserProfile(email!);

  //     if (userModel?.loginType == "google" || userModel?.loginType == "apple") {
  //       ShowToastDialog.closeLoader();
  //       ShowToastDialog.showToast("The account already exists for that email.".tr);
  //       return null;
  //     }

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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize();

      final GoogleSignInAccount googleUser =
          await googleSignIn.authenticate().catchError((error) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("something_went_wrong".tr);
        // ignore: invalid_return_type_for_catch_error
        return null;
      });

      if (googleUser.id.isEmpty) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast("Google sign-in was cancelled.".tr);
        return null;
      }

      final email = googleUser.email;

      // Fetch user profile from Firestore
      UserModel? userModel = await FireStoreUtils.getUserProfile(email);

      // Check if user already exists with Google or Apple login
      if (userModel != null &&
          (userModel.loginType == "google" || userModel.loginType == "apple")) {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            "The account already exists for that email.".tr);
        return null;
      }

      // Obtain the authentication tokens
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential;
    } catch (e) {
      ShowToastDialog.closeLoader();
      debugPrint("Google Sign-In Error: $e");
      ShowToastDialog.showToast("something_went_wrong".tr);
      return null;
    }
  }

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
}
