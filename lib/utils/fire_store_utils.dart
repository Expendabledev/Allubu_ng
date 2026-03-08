import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:yelpify/constant/collection_name.dart';
import 'package:yelpify/constant/constant.dart';
import 'package:yelpify/firebase_options.dart';
import 'package:yelpify/models/ad_setup_model.dart';
import 'package:yelpify/models/bookmarks_model.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/categiry_plan_model.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/models/check_in_model.dart';
import 'package:yelpify/models/compliment_model.dart';
import 'package:yelpify/models/conversation_model.dart';
import 'package:yelpify/models/email_template_model.dart';
import 'package:yelpify/models/highlight_model.dart';
import 'package:yelpify/models/item_model.dart';
import 'package:yelpify/models/language_model.dart';
import 'package:yelpify/models/mail_setting.dart';
import 'package:yelpify/models/photo_model.dart';
import 'package:yelpify/models/pricing_request_model.dart';
import 'package:yelpify/models/recommend_model.dart';
import 'package:yelpify/models/report_model.dart';
import 'package:yelpify/models/review_model.dart';
import 'package:yelpify/models/service_model.dart';
import 'package:yelpify/models/sponsored_request_model.dart';
import 'package:yelpify/models/subscription_ads_history.dart';
import 'package:yelpify/models/subscription_ads_model.dart';
import 'package:yelpify/models/user_model.dart';
import 'package:yelpify/themes/app_them_data.dart';
import 'package:yelpify/widgets/geoflutterfire/src/geoflutterfire.dart';
import 'package:yelpify/widgets/geoflutterfire/src/models/point.dart';

enum FirebaseEnv { defaultDb, staging }

/// Change this to switch between default / staging
const FirebaseEnv currentEnv = FirebaseEnv.defaultDb;

class FireStoreUtils {
  FireStoreUtils._privateConstructor();

  static final FireStoreUtils instance = FireStoreUtils._privateConstructor();

  static late FirebaseFirestore fireStore;

  /// Initialize Firestore with a FirebaseApp and optional databaseId
  void init(FirebaseApp app, {String? databaseId}) {
    fireStore = FirebaseFirestore.instanceFor(app: app, databaseId: databaseId);
  }

  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  static Future<bool> isLogin() async {
    bool isLogin = false;
    if (FirebaseAuth.instance.currentUser != null) {
      isLogin = await userExistOrNot(FirebaseAuth.instance.currentUser!.uid);
    } else {
      isLogin = false;
    }
    return isLogin;
  }

  static Future<bool> isMaintenanceMode() async {
    bool isMaintenance = false;
    await fireStore.collection(CollectionName.settings).doc('global').get().then((value) async {
      isMaintenance = value.data()?['isMaintenanceMode'] == true;
      log("isMaintenance :: $isMaintenance");
    });
    return isMaintenance;
  }

  static Future<bool> userExistOrNot(String uid) async {
    bool isExist = false;

    await fireStore.collection(CollectionName.users).doc(uid).get().then(
      (value) {
        if (value.exists) {
          isExist = true;
        } else {
          isExist = false;
        }
      },
    ).catchError((error) {
      log("Failed to check user exist: $error");
      isExist = false;
    });
    return isExist;
  }

  static Future<bool> updateUser(UserModel userModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.users).doc(userModel.id).set(userModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<UserModel?> getCurrentUserModel() async {
    UserModel? userModel;
    await fireStore.collection(CollectionName.users).doc(getCurrentUid()).get().then((value) {
      if (value.exists) {
        userModel = UserModel.fromJson(value.data()!);
        Constant.userModel = userModel;
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      userModel = null;
    });
    return userModel;
  }

  static Future<List<LanguageModel>?> getLanguage() async {
    List<LanguageModel> languageList = [];

    await fireStore.collection(CollectionName.languages).where("publish", isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        LanguageModel taxModel = LanguageModel.fromJson(element.data());
        languageList.add(taxModel);
      }
    }).catchError((error) {
      log(error.toString());
    });
    return languageList;
  }

  static Future<UserModel?> getUserProfile(String uuid) async {
    UserModel? userModel;
    await fireStore.collection(CollectionName.users).doc(uuid).get().then((value) {
      if (value.exists) {
        userModel = UserModel.fromJson(value.data()!);
      }
    }).catchError((error) {
      log("Failed to update user: $error");
      userModel = null;
    });
    return userModel;
  }

  static Future<UserModel?> getUserByEmail(String email) async {
    UserModel? userModel;
    try {
      QuerySnapshot snapshot = await fireStore.collection(CollectionName.users).where('email', isEqualTo: email).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        userModel = UserModel.fromJson(snapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        userModel = null; // No user found
      }
    } catch (error) {
      log("Failed to get user by email: $error");
      userModel = null;
    }

    return userModel;
  }

  static Future<List<UserModel>> getFollowing(String model) async {
    List<UserModel> userModel = [];
    await fireStore.collection(CollectionName.users).where('followers', arrayContains: model).get().then((value) {
      for (var element in value.docs) {
        try {
          // Try to create the BookmarksModel from Firestore document data
          UserModel taxModel = UserModel.fromJson(element.data());
          userModel.add(taxModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return userModel;
  }

  static Future<void> getSettings() async {
    fireStore.collection(CollectionName.settings).doc("global").snapshots().listen((event) {
      if (event.exists) {
        Constant.mapAPIKey = event.data()!["googleApiKey"] ?? '';
        Constant.radios = event.data()!["radius"] ?? '';
        Constant.mapType = event.data()!["mapType"] ?? '';
        Constant.appColor = event.data()!["appColor"] ?? '';
        Constant.appLogo = event.data()!["appLogo"] ?? '';
        Constant.appVersion = event.data()!["appVersion"] ?? '';
        Constant.maxBusinessCategory = event.data()!["maxBusinessCategory"];
        Constant.applicationName = event.data()!["applicationName"];
        Constant.checkInRadius = event.data()!["checkInRadius"];
        Constant.youMightAlsoConsider = event.data()!["youMightAlsoConsider"];
        Constant.sponsoredMarker = event.data()!["sponsoredMarker"];
        Constant.claimBusinessURL = event.data()!["claimBusinessURL"];
        Constant.deepLinkUrl = event.data()!["deepLinkUrl"];
        Constant.defaultCountryCode = event.data()!["defaultCountryCode"];

        Constant.apiBaseUrl = event.data()!["apiBaseUrl"];
        Constant.apiSecureKey = event.data()!["apiSecureKey"];

        AppThemeData.red02 = Color(int.parse(Constant.appColor.replaceFirst("#", "0xff")));
      }
    });

    fireStore.collection(CollectionName.settings).doc("placeHolderImage").snapshots().listen((event) {
      if (event.exists) {
        Constant.placeHolderImage = event.data()!["image"] ?? '';
      }
    });

    fireStore.collection(CollectionName.settings).doc("privacyTermsLinks").snapshots().listen((event) {
      if (event.exists) {
        Constant.termsAndConditions = event.data()!["termsAndConditions"];
        Constant.privacyPolicy = event.data()!["privacyPolicy"];
      }
    });

    fireStore.collection(CollectionName.settings).doc("contactUs").snapshots().listen((event) {
      if (event.exists) {
        Constant.adminEmail = event.data()!["email"] ?? '';
      }
    });

    fireStore.collection(CollectionName.settings).doc("ad_setup").snapshots().listen((event) {
      if (event.exists) {
        Constant.adSetupModel = AdSetupModel.fromJson(event.data()!);
      }
    });

    fireStore.collection(CollectionName.settings).doc("emailSetting").get().then((value) {
      if (value.exists) {
        Constant.mailSettings = MailSettings.fromJson(value.data()!);
      }
    });

    fireStore.collection(CollectionName.settings).doc("notificationSettings").snapshots().listen((event) {
      if (event.exists) {
        Constant.senderId = event.data()!["senderId"] ?? '';
        Constant.jsonNotificationFileURL = event.data()!["serviceJson"] ?? '';
      }
    });
  }

  static Future<List<CategoryModel>> categoryParentListHome() async {
    List<CategoryModel> categoryList = [];
    await fireStore.collection(CollectionName.categories).where('showInHomePage', isEqualTo: true).where('parentCategory', isNull: true).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        try {
          // Try to create the BookmarksModel from Firestore document data
          CategoryModel taxModel = CategoryModel.fromJson(element.data());
          categoryList.add(taxModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return categoryList;
  }

  static Future<List<CategoryModel>> categoryParentList() async {
    List<CategoryModel> categoryList = [];
    await fireStore.collection(CollectionName.categories).where('parentCategory', isNull: true).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        try {
          // Try to create the BookmarksModel from Firestore document data
          CategoryModel taxModel = CategoryModel.fromJson(element.data());
          categoryList.add(taxModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return categoryList;
  }

  static Future<List<CategoryModel>> subCategoryParentList(CategoryModel model) async {
    List<CategoryModel> categoryList = [];
    await fireStore.collection(CollectionName.categories).where('parentCategory', isEqualTo: model.slug).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        try {
          // Try to create the BookmarksModel from Firestore document data
          CategoryModel taxModel = CategoryModel.fromJson(element.data());
          categoryList.add(taxModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return categoryList;
  }

  static Future<List<CategoryModel>> getProjectCategory() async {
    List<CategoryModel> categoryList = [];
    await fireStore.collection(CollectionName.categories).where('parentCategory', isNull: true).where('getPricingForm', isEqualTo: true).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        try {
          // Try to create the BookmarksModel from Firestore document data
          CategoryModel taxModel = CategoryModel.fromJson(element.data());
          categoryList.add(taxModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return categoryList;
  }

  static Future<List<CategoryModel>> getCategory(String query) async {
    List<CategoryModel> categoryList = [];
    log("query :: ${query}");
    await fireStore.collection(CollectionName.categories).where('searchKeyword', arrayContains: query).where('publish', isEqualTo: true).get().then((value) {
      for (var element in value.docs) {
        try {
          // Try to create the BookmarksModel from Firestore document data
          CategoryModel taxModel = CategoryModel.fromJson(element.data());
          categoryList.add(taxModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });

    return categoryList;
  }

  static Future<CategoryModel?> getCategoryById(String parentId) async {
    CategoryModel? category;
    await fireStore.collection(CollectionName.categories).doc(parentId).get().then((value) {
      if (value.exists) {
        category = CategoryModel.fromJson(value.data()!);
      } else {
        return null;
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });

    return category;
  }

  static Future<ServiceModel?> getServiceById(String serviceId) async {
    ServiceModel? category;
    await fireStore.collection(CollectionName.services).doc(serviceId).get().then((value) {
      if (value.exists) {
        category = ServiceModel.fromJson(value.data()!);
      } else {
        return null;
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });

    return category;
  }

  /// **Fetch parent categories recursively**
  static Future<List<CategoryModel>> getCategoryHierarchy(CategoryModel category) async {
    List<CategoryModel> hierarchy = [];

    while (category.parentCategory != null) {
      hierarchy.insert(0, category); // Insert at the beginning
      var parentSnapshot = await fireStore.collection(CollectionName.categories).doc(category.parentCategory).get();

      if (parentSnapshot.exists) {
        try {
          // Try to create the BookmarksModel from Firestore document data
          category = CategoryModel.fromJson(parentSnapshot.data()!);
          category.slug = parentSnapshot.id;
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${parentSnapshot.id}: $e");
        }
      } else {
        break;
      }
    }

    hierarchy.insert(0, category); // Ensure root category is added
    return hierarchy;
  }

  static Future<bool> addBusiness(BusinessModel businessModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.business).doc(businessModel.id).set(businessModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Stream<List<BusinessModel>> getAllNearestRestaurantByCategoryId(LatLng latLng, CategoryModel category) {
    try {
      Query<Map<String, dynamic>> query = fireStore.collection(CollectionName.business).where('publish', isEqualTo: true).where('isPermanentClosed', isEqualTo: false);

      GeoFirePoint center = Geoflutterfire().point(
        latitude: latLng.latitude,
        longitude: latLng.longitude,
      );

      String field = 'position';

      return Geoflutterfire().collection(collectionRef: query).within(center: center, radius: double.parse(Constant.radios), field: field, strictMode: true).map((documentList) {
        List<BusinessModel> businesses = [];

        for (var doc in documentList) {
          try {
            BusinessModel business = BusinessModel.fromJson(doc.data() as Map<String, dynamic>);
            if (business.category != null && business.category!.any((element) => element.slug == category.slug)) {
              businesses.add(business);
            }
          } catch (e) {
            // If an error occurs, log it and skip the current document
            log("####### Error parsing document with ID ${doc.id}: $e");
          }
        }

        return businesses;
      });
    } catch (e) {
      print("Error in getAllNearestRestaurantByCategoryId: $e");
      return Stream.value([]); // Return empty list on error instead of crashing
    }
  }

  static Future<List<BusinessModel>> getNearestBusinessByCategoryId(LatLng latLng, CategoryModel category) async {
    try {
      GeoFirePoint center = Geoflutterfire().point(latitude: latLng.latitude, longitude: latLng.longitude);

      Query<Map<String, dynamic>> baseQuery = fireStore.collection(CollectionName.business).where('publish', isEqualTo: true).where('isPermanentClosed', isEqualTo: false);

      List<DocumentSnapshot> documents = await Geoflutterfire()
          .collection(collectionRef: baseQuery)
          .within(
            center: center,
            radius: double.parse(Constant.radios),
            field: 'position',
            strictMode: true,
          )
          .first; // get the first snapshot only (one-time fetch)

      List<BusinessModel> allBusinesses =
          documents.map((doc) => BusinessModel.fromJson(doc.data() as Map<String, dynamic>)).where((business) => business.category?.any((c) => c.slug == category.slug) ?? false).toList();

      // Separate sponsored and non-sponsored
      List<BusinessModel> sponsored = allBusinesses.where((b) => b.sponsored != null && b.sponsored!.status == "Running").toList();
      List<BusinessModel> others = allBusinesses.where((b) => b.sponsored == null || b.sponsored!.status == "Expired" || b.sponsored!.status == "Cancelled").toList();

      // Combine with priority and limit to 5
      List<BusinessModel> finalList = [...sponsored, ...others].take(int.parse(Constant.youMightAlsoConsider.toString())).toList();

      return finalList;
    } catch (e) {
      print("Error in getNearestRestaurantsByCategoryId: $e");
      return [];
    }
  }

  static Stream<List<BusinessModel>> getAllSuggestedBusiness(LatLng latLng) {
    try {
      Query<Map<String, dynamic>> query = fireStore.collection(CollectionName.business).where('publish', isEqualTo: true).where('isPermanentClosed', isEqualTo: false);

      GeoFirePoint center = Geoflutterfire().point(latitude: latLng.latitude, longitude: latLng.longitude);
      String field = 'position';

      return Geoflutterfire().collection(collectionRef: query).within(center: center, radius: double.parse(Constant.radios), field: field, strictMode: true).map((documentList) {
        return documentList
            .map((doc) => BusinessModel.fromJson(doc.data() as Map<String, dynamic>))
            .where(
              (element) => !element.suggestedBusinessRemovedUserId!.contains(getCurrentUid()),
            )
            .toList();
      });
    } catch (e) {
      print("Error in getAllNearestRestaurantByCategoryId: $e");
      return Stream.value([]); // Return empty list on error instead of crashing
    }
  }

  static Future<List<BusinessModel>> getMyBusiness() async {
    List<BusinessModel> categoryList = [];
    await fireStore.collection(CollectionName.business).where('createdBy', isEqualTo: getCurrentUid()).get().then((value) {
      for (var element in value.docs) {
        try {
          BusinessModel businessModel = BusinessModel.fromJson(element.data());
          categoryList.add(businessModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return categoryList;
  }

  static Future<List<BusinessModel>> getBusinessListById(String uid) async {
    List<BusinessModel> categoryList = [];
    await fireStore.collection(CollectionName.business).where('createdBy', isEqualTo: uid).get().then((value) {
      for (var element in value.docs) {
        try {
          BusinessModel businessModel = BusinessModel.fromJson(element.data());
          categoryList.add(businessModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return categoryList;
  }

  static Future<List<BusinessModel>> getOwnerBusinessListById(String uid) async {
    List<BusinessModel> categoryList = [];
    await fireStore.collection(CollectionName.business).where('ownerId', isEqualTo: uid).get().then((value) {
      for (var element in value.docs) {
        try {
          BusinessModel businessModel = BusinessModel.fromJson(element.data());
          categoryList.add(businessModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return categoryList;
  }

  static Future<BusinessModel?> getBusinessById(String businessId) async {
    BusinessModel? businessModel;
    await fireStore.collection(CollectionName.business).doc(businessId).get().then((value) {
      if (value.exists) {
        businessModel = BusinessModel.fromJson(value.data()!);
      } else {
        return null;
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });

    return businessModel;
  }

  static Future<List<ItemModel>> getItemList(String businessId) async {
    List<ItemModel> list = [];
    await fireStore.collection(CollectionName.business).doc(businessId).collection(CollectionName.items).get().then((value) {
      for (var element in value.docs) {
        try {
          ItemModel uploadMenuModel = ItemModel.fromJson(element.data());
          list.add(uploadMenuModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<bool> uploadItem(String businessId, ItemModel itemModel) async {
    print(itemModel.toJson());
    bool isUpdate = false;
    await fireStore.collection(CollectionName.business).doc(businessId).collection(CollectionName.items).doc(itemModel.id).set(itemModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> deleteItem(String businessId, ItemModel uploadMenuModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.business).doc(businessId).collection(CollectionName.items).doc(uploadMenuModel.id).delete().whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> addReview(ReviewModel reviewModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.reviews).doc(reviewModel.id).set(reviewModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> addPhotos(PhotoModel photoModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.photos).doc(photoModel.id).set(photoModel.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<ReviewModel>> getReviews(String businessId) async {
    List<ReviewModel> list = [];
    await fireStore.collection(CollectionName.reviews).where("businessId", isEqualTo: businessId).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          ReviewModel model = ReviewModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<bool> updateReview(ReviewModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.reviews).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<PhotoModel>> getReviewImage(String reviewId) async {
    List<PhotoModel> list = [];
    await fireStore.collection(CollectionName.photos).where("type", isEqualTo: "review").where("reviewId", isEqualTo: reviewId).get().then((value) {
      for (var element in value.docs) {
        try {
          PhotoModel uploadMenuModel = PhotoModel.fromJson(element.data());
          list.add(uploadMenuModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });

    return list;
  }

  static Future<List<PhotoModel>> getAllPhotos(String id, String type) async {
    List<PhotoModel> list = [];
    await fireStore.collection(CollectionName.photos).where("businessId", isEqualTo: id).where("type", isNotEqualTo: type).get().then((value) {
      for (var element in value.docs) {
        try {
          PhotoModel uploadMenuModel = PhotoModel.fromJson(element.data());
          list.add(uploadMenuModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<List<PhotoModel>> getAllPhotosByType(String id, String type) async {
    List<PhotoModel> list = [];
    await fireStore.collection(CollectionName.photos).where("businessId", isEqualTo: id).where("type", isEqualTo: type).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          PhotoModel uploadMenuModel = PhotoModel.fromJson(element.data());
          list.add(uploadMenuModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<bool> removePhoto(PhotoModel uploadMenuModel) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.photos).doc(uploadMenuModel.id).delete().whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<PhotoModel>> getAllPhotosByUserId(String id) async {
    List<PhotoModel> list = [];
    await fireStore.collection(CollectionName.photos).where("userId", isEqualTo: id).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          PhotoModel uploadMenuModel = PhotoModel.fromJson(element.data());
          list.add(uploadMenuModel);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<List<ReviewModel>> getReviewsNyUserId(String id) async {
    List<ReviewModel> list = [];
    await fireStore.collection(CollectionName.reviews).where("userId", isEqualTo: id).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          ReviewModel model = ReviewModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<bool> addRecommended(RecommendModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.recommendBusiness).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<CategoryPlanModel>> getCategoryPlaned() async {
    List<CategoryPlanModel> list = [];
    await fireStore.collection(CollectionName.categoryAddToPlan).where("userId", isEqualTo: getCurrentUid()).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          CategoryPlanModel model = CategoryPlanModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<bool> setCategoryPlaned(CategoryPlanModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.categoryAddToPlan).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> removeCategoryPlaned(CategoryPlanModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.categoryAddToPlan).doc(model.id).delete().whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> createBookmarks(BookmarksModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.bookmarks).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<BookmarksModel>> getBookmarks(String id) async {
    List<BookmarksModel> list = [];
    await fireStore.collection(CollectionName.bookmarks).where("ownerId", isEqualTo: id).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          BookmarksModel model = BookmarksModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<List<BookmarksModel>> getFollowingBookmarks() async {
    List<BookmarksModel> list = [];
    await fireStore.collection(CollectionName.bookmarks).where("followers", arrayContains: getCurrentUid()).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          // Try to create the BookmarksModel from Firestore document data
          BookmarksModel model = BookmarksModel.fromJson(element.data());
          list.add(model); // Add to the list if no error occurs
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });
    return list;
  }

  static Stream<List<BookmarksModel>> getAllNearestBookMark(LatLng latLng) {
    try {
      Query<Map<String, dynamic>> query = fireStore.collection(CollectionName.bookmarks).where('isDefault', isEqualTo: false).where('isPrivate', isEqualTo: false);

      GeoFirePoint center = Geoflutterfire().point(latitude: latLng.latitude, longitude: latLng.longitude);
      String field = 'position';

      return Geoflutterfire().collection(collectionRef: query).within(center: center, radius: double.parse(Constant.radios), field: field, strictMode: true).map((documentList) {
        // Use .where() to filter out null values
        return documentList
            .map((doc) {
              try {
                // Try parsing the document data into BookmarksModel
                return BookmarksModel.fromJson(doc.data() as Map<String, dynamic>);
              } catch (e) {
                // If an error occurs, log it and return null
                print("####### Error parsing document with ID ${doc.id}: $e");
                return null; // Return null for problematic documents
              }
            })
            .where((item) => item != null) // Filter out null values (error-prone documents)
            .cast<BookmarksModel>() // Ensure the final list is of type List<BookmarksModel>
            .toList();
      });
    } catch (e) {
      print("Error in getAllNearestBookMark: $e");
      return Stream.value([]); // Return an empty list on error instead of crashing
    }
  }

  static Future<bool> deleteBookmark(String id) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.bookmarks).doc(id).delete().whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<BookmarksModel?> getBookmarksById(String id) async {
    BookmarksModel? model;
    await fireStore.collection(CollectionName.bookmarks).doc(id).get().then((value) {
      if (value.exists) {
        model = BookmarksModel.fromJson(value.data()!);
      } else {
        return null;
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });

    return model;
  }

  static Future<BusinessModel?> getBusinessByCollection(BookmarksModel bookMarkModel) async {
    return Future.wait(bookMarkModel.businessIds!.map((id) async {
      DocumentSnapshot value = await fireStore.collection(CollectionName.business).doc(id).get();
      if (value.exists) {
        BusinessModel model = BusinessModel.fromJson(value.data() as Map<String, dynamic>);
        if (model.coverPhoto != null && model.coverPhoto!.isNotEmpty) {
          return model;
        }
      }
      return null;
    })).then((list) => list.firstWhere((element) => element != null, orElse: () => null));
  }

  static Future<bool> setPricingRequest(PricingRequestModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.projectRequest).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<PricingRequestModel?> getPricingRequestById(String id) async {
    PricingRequestModel? model;
    await fireStore.collection(CollectionName.projectRequest).doc(id).get().then((value) {
      if (value.exists) {
        model = PricingRequestModel.fromJson(value.data()!);
      } else {
        return null;
      }
    }).catchError((error) {
      log("Failed to update user: $error");
    });

    return model;
  }

  static Future<List<PricingRequestModel>> getPricingActiveList() async {
    List<PricingRequestModel> list = [];
    await fireStore
        .collection(CollectionName.projectRequest)
        .where("userId", isEqualTo: getCurrentUid())
        .where("status", isEqualTo: "active")
        .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        try {
          PricingRequestModel model = PricingRequestModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<List<PricingRequestModel>> getProjectList(BusinessModel model) async {
    List<PricingRequestModel> list = [];
    await fireStore
        .collection(CollectionName.projectRequest)
        .where("businessIds", arrayContains: model.id)
        .where("status", isEqualTo: "active")
        .orderBy("createdAt", descending: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        try {
          PricingRequestModel model = PricingRequestModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<bool> setProjectChat(ConversationModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.projectRequest).doc(model.projectId).collection("chat").doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> setCompliment(ComplimentModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.compliment).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<ComplimentModel>> getComplimentList(String userId) async {
    List<ComplimentModel> list = [];
    await fireStore.collection(CollectionName.compliment).where("to", isEqualTo: userId).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          ComplimentModel model = ComplimentModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<bool> setComplain(ReportModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.complainAndReport).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<bool> setCheckIn(CheckInModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.checkIn).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<CheckInModel>> getCheckIn(String userId) async {
    List<CheckInModel> list = [];
    await fireStore.collection(CollectionName.checkIn).where("userId", isEqualTo: userId).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          CheckInModel model = CheckInModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<List<SubscriptionAdsModel>> getSubscriptionAds() async {
    List<SubscriptionAdsModel> list = [];
    await fireStore.collection(CollectionName.subscriptionAds).get().then((value) {
      for (var element in value.docs) {
        try {
          SubscriptionAdsModel model = SubscriptionAdsModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<bool> setSubscriptionAdsHistory(SubscriptionAdsHistory model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.subscriptionAdsHistory).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<SubscriptionAdsHistory>> getSubscriptionAdsHistory() async {
    List<SubscriptionAdsHistory> list = [];
    await fireStore.collection(CollectionName.subscriptionAdsHistory).where("userId", isEqualTo: getCurrentUid()).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          SubscriptionAdsHistory model = SubscriptionAdsHistory.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<bool> addSponsoredRequest(SponsoredRequestModel model) async {
    bool isUpdate = false;
    await fireStore.collection(CollectionName.sponsoredRequest).doc(model.id).set(model.toJson()).whenComplete(() {
      isUpdate = true;
    }).catchError((error) {
      log("Failed to update user: $error");
      isUpdate = false;
    });
    return isUpdate;
  }

  static Future<List<SponsoredRequestModel>> getSponsoredRequest(String businessId) async {
    List<SponsoredRequestModel> list = [];
    await fireStore.collection(CollectionName.sponsoredRequest).where("businessId", isEqualTo: businessId).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          SponsoredRequestModel model = SponsoredRequestModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<List<HighlightModel>> getBusinessHighLight() async {
    List<HighlightModel> list = [];
    await fireStore.collection(CollectionName.businessHighlightOptions).where("publish", isEqualTo: true).orderBy("createdAt", descending: true).get().then((value) {
      for (var element in value.docs) {
        try {
          HighlightModel model = HighlightModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<List<HighlightModel>> getBusinessHighLightById(List<dynamic> businessHighLightIds) async {
    List<HighlightModel> list = [];
    await fireStore.collection(CollectionName.businessHighlightOptions).where("id", whereIn: businessHighLightIds).get().then((value) {
      for (var element in value.docs) {
        try {
          HighlightModel model = HighlightModel.fromJson(element.data());
          list.add(model);
        } catch (e) {
          // If an error occurs, log it and skip the current document
          log("####### Error parsing document with ID ${element.id}: $e");
        }
      }
    });
    return list;
  }

  static Future<EmailTemplateModel?> getEmailTemplates(String type) async {
    EmailTemplateModel? emailTemplateModel;
    await fireStore.collection(CollectionName.emailTemplates).where('type', isEqualTo: type).get().then((value) {
      if (value.docs.isNotEmpty) {
        emailTemplateModel = EmailTemplateModel.fromJson(value.docs.first.data());
      }
    });
    return emailTemplateModel;
  }

  static Future<bool?> deleteUser() async {
    bool? isDelete;
    try {
      await fireStore.collection(CollectionName.users).doc(FireStoreUtils.getCurrentUid()).delete();

      // delete user  from firebase auth
      await deleteAuthUser(FireStoreUtils.getCurrentUid()).then((value) {
        isDelete = true;
      });
    } catch (e, s) {
      log('FireStoreUtils.firebaseCreateNewUser $e $s');
      return false;
    }
    return isDelete;
  }

  static Future<bool> deleteAuthUser(String uid) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ No user is logged in.");
        return false;
      }

      final idToken = await user.getIdToken();
      final projectId = DefaultFirebaseOptions.currentPlatform.projectId;
      final url = Uri.parse('https://us-central1-$projectId.cloudfunctions.net/deleteUser');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'data': {'uid': uid}, // 👈 matches your Cloud Function structure
        }),
      );

      print("Response [${response.statusCode}]: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return decoded['result']?['success'] == true || decoded['success'] == true;
      } else {
        print("⚠️ Cloud Function failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error deleting driver: $e");
      return false;
    }
  }
}
