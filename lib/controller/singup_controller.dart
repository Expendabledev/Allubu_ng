import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:allubmarket/app/create_bussiness_screen/create_business_screen.dart';
import 'package:allubmarket/constant/constant.dart';
import 'package:allubmarket/constant/show_toast_dialog.dart';
import 'package:allubmarket/models/bookmarks_model.dart';
import 'package:allubmarket/models/business_model.dart';
import 'package:allubmarket/models/user_model.dart';
import 'package:allubmarket/utils/fire_store_utils.dart';
import 'package:allubmarket/utils/notification_service.dart';

import '../app/dashboard_screen/dashboard_screen.dart';

class SignupController extends GetxController {
  Rx<TextEditingController> firstNameTextFieldController =
      TextEditingController().obs;
  Rx<TextEditingController> lastNameTextFieldController =
      TextEditingController().obs;
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

  RxString profileImage = "".obs;
  RxBool passwordVisible = true.obs;

  RxString loginType = Constant.emailLoginType.obs;

  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<UserModel> userModel = UserModel().obs;
  RxBool isAddAbusinessBtn = false.obs;

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      if (argumentData['userModel'] != null) {
        userModel.value = argumentData['userModel'];
        loginType.value = userModel.value.loginType.toString();
        if (loginType.value == Constant.phoneLoginType) {
          phoneNumberTextFieldController.value.text =
              userModel.value.phoneNumber.toString();
          countryCodeController.value.text =
              userModel.value.countryCode.toString();
          countryISOCodeController.value.text =
              userModel.value.countryISOCode.toString();
        } else {
          emailTextFieldController.value.text =
              userModel.value.email.toString();
          firstNameTextFieldController.value.text =
              userModel.value.firstName ?? '';
        }
      } else if (argumentData['type'] == 'Add a business') {
        isAddAbusinessBtn.value = true;
      }
    }
    update();
  }

  Future<void> signUpWithEmailPassword() async {
    try {
      ShowToastDialog.showLoader("Please wait".tr);
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextFieldController.value.text.trim(),
        password: passwordTextFieldController.value.text.trim(),
      );
      if (credential.user != null) {
        userModel.value.id = credential.user!.uid;
        userModel.value.loginType = Constant.emailLoginType;
        await createAccount();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowToastDialog.showToast("The password provided is too weak.".tr);
      } else if (e.code == 'email-already-in-use') {
        ShowToastDialog.showToast(
            "The account already exists for that email.".tr);
      } else if (e.code == 'invalid-email') {
        ShowToastDialog.showToast("Enter email is Invalid".tr);
      }
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
  }

  Future<void> createAccount() async {
    try {
      String fcmToken = await NotificationService.getToken();
      ShowToastDialog.showLoader("Please wait".tr);
      UserModel userModelData = userModel.value;
      userModelData.firstName = firstNameTextFieldController.value.text;
      userModelData.lastName = lastNameTextFieldController.value.text;
      userModelData.email = emailTextFieldController.value.text;
      userModelData.countryCode = countryCodeController.value.text;
      userModelData.countryISOCode = countryISOCodeController.value.text;
      userModelData.phoneNumber = phoneNumberTextFieldController.value.text;
      userModelData.loginType =
          userModel.value.loginType ?? Constant.emailLoginType;
      userModelData.profilePic = profileImage.value;
      userModelData.fcmToken = fcmToken;
      userModelData.createdAt = Timestamp.now();
      userModelData.isActive = true;
      await FireStoreUtils.updateUser(userModelData).then((value) async {
        await createDefaultBookmark();
        ShowToastDialog.closeLoader();
        if (value == true) {
          if (isAddAbusinessBtn.value == true) {
            ShowToastDialog.showToast("Account is created");
            Get.to(CreateBusinessScreen(),
                    arguments: {"asCustomerOrWorkAtBusiness": false})
                ?.then((value) {
              Get.offAll(const DashBoardScreen());
            });
          } else {
            ShowToastDialog.showToast("Account is created");
            Get.offAll(const DashBoardScreen());
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loginWithGoogle() async {
    ShowToastDialog.showLoader("Please wait".tr);
    await signInWithGoogle().then((value) async {
      if (value != null) {
        if (value.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel();
          userModel.id = value.user!.uid;
          userModel.email = value.user!.email;
          userModel.firstName = value.user!.displayName;
          userModel.lastName = '';
          userModel.profilePic = value.user!.photoURL;
          userModel.loginType = Constant.googleLoginType;
          userModel.fcmToken = await NotificationService.getToken();
          userModel.createdAt = Timestamp.now();
          userModel.isActive = true;
          await FireStoreUtils.updateUser(userModel).then((value) async {
            await createDefaultBookmark();
            ShowToastDialog.closeLoader();
            if (value == true) {
              ShowToastDialog.showToast("Account is created");
              if (isAddAbusinessBtn.value == true) {
                Get.to(CreateBusinessScreen(),
                        arguments: {"asCustomerOrWorkAtBusiness": false})
                    ?.then((value) {
                  Get.offAll(const DashBoardScreen());
                });
              } else {
                Get.offAll(const DashBoardScreen());
              }
            }
          });
          ShowToastDialog.closeLoader();
        } else {
          await FireStoreUtils.userExistOrNot(value.user!.uid)
              .then((userExit) async {
            if (userExit == true) {
              UserModel? userModel =
                  await FireStoreUtils.getUserProfile(value.user!.uid);
              ShowToastDialog.closeLoader();
              if (userModel != null) {
                if (userModel.isActive == true) {
                  if (isAddAbusinessBtn.value == true) {
                    Get.to(CreateBusinessScreen(),
                            arguments: {"asCustomerOrWorkAtBusiness": false})
                        ?.then((value) {
                      Get.offAll(const DashBoardScreen());
                    });
                  } else {
                    Get.offAll(const DashBoardScreen());
                  }
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
              userModel.lastName = '';
              userModel.profilePic = value.user!.photoURL;
              userModel.loginType = Constant.googleLoginType;
              userModel.fcmToken = await NotificationService.getToken();
              userModel.createdAt = Timestamp.now();
              userModel.isActive = true;

              await FireStoreUtils.updateUser(userModel).then((value) async {
                await createDefaultBookmark();
                ShowToastDialog.closeLoader();
                if (value == true) {
                  ShowToastDialog.showToast("Account is created");
                  if (isAddAbusinessBtn.value == true) {
                    Get.to(CreateBusinessScreen(),
                            arguments: {"asCustomerOrWorkAtBusiness": false})
                        ?.then((value) {
                      Get.offAll(const DashBoardScreen());
                    });
                  } else {
                    Get.offAll(const DashBoardScreen());
                  }
                }
              });
            }
          });
        }
      }
      ShowToastDialog.closeLoader();
    });
  }

  Future<void> loginWithApple() async {
    ShowToastDialog.showLoader("Please wait".tr);
    await signInWithApple().then((value) async {
      if (value != null) {
        Map<String, dynamic> map = value;
        AuthorizationCredentialAppleID appleCredential = map['appleCredential'];
        UserCredential userCredential = map['userCredential'];
        if (userCredential.additionalUserInfo!.isNewUser) {
          UserModel userModel = UserModel();
          userModel.id = userCredential.user!.uid;
          userModel.email = userCredential.user!.email;
          userModel.profilePic = userCredential.user!.photoURL;
          userModel.loginType = Constant.appleLoginType;
          userModel.firstName = appleCredential.givenName ?? '';
          userModel.lastName = appleCredential.familyName ?? '';
          userModel.fcmToken = await NotificationService.getToken();
          userModel.createdAt = Timestamp.now();
          userModel.isActive = true;

          await FireStoreUtils.updateUser(userModel).then((value) async {
            await createDefaultBookmark();
            ShowToastDialog.closeLoader();
            if (value == true) {
              ShowToastDialog.showToast("Account is created");
              if (isAddAbusinessBtn.value == true) {
                Get.to(CreateBusinessScreen(),
                        arguments: {"asCustomerOrWorkAtBusiness": false})
                    ?.then((value) {
                  Get.offAll(const DashBoardScreen());
                });
              } else {
                Get.offAll(const DashBoardScreen());
              }
            }
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
                  if (isAddAbusinessBtn.value == true) {
                    Get.to(CreateBusinessScreen(),
                            arguments: {"asCustomerOrWorkAtBusiness": false})
                        ?.then((value) {
                      Get.offAll(const DashBoardScreen());
                    });
                  } else {
                    Get.offAll(const DashBoardScreen());
                  }
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
              userModel.firstName = appleCredential.givenName ?? '';
              userModel.lastName = appleCredential.familyName ?? '';
              userModel.fcmToken = await NotificationService.getToken();
              userModel.createdAt = Timestamp.now();
              userModel.isActive = true;
              await FireStoreUtils.updateUser(userModel).then((value) async {
                await createDefaultBookmark();
                ShowToastDialog.closeLoader();
                if (value == true) {
                  ShowToastDialog.showToast("Account is created");
                  if (isAddAbusinessBtn.value == true) {
                    Get.to(CreateBusinessScreen(),
                            arguments: {"asCustomerOrWorkAtBusiness": false})
                        ?.then((value) {
                      Get.offAll(const DashBoardScreen());
                    });
                  } else {
                    Get.offAll(const DashBoardScreen());
                  }
                }
              });
            }
          });
        }
      }
      ShowToastDialog.closeLoader();
    });
  }

  Future<void> createDefaultBookmark() async {
    BookmarksModel bookmarksModel = BookmarksModel();
    bookmarksModel.id = Constant.getUuid();
    bookmarksModel.name = "My Bookmark";
    bookmarksModel.description = null;
    bookmarksModel.ownerId = FireStoreUtils.getCurrentUid();
    bookmarksModel.isDefault = true;
    bookmarksModel.isPrivate = true;
    bookmarksModel.createdAt = Timestamp.now();
    bookmarksModel.updatedAt = Timestamp.now();
    bookmarksModel.location = LatLngModel(latitude: null, longitude: null);
    bookmarksModel.position = Positions(geoPoint: null, geoHash: null);
    bookmarksModel.shareLinkCode = null;
    await FireStoreUtils.createBookmarks(bookmarksModel);
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
