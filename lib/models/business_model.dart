import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yelpify/models/category_model.dart';
import 'package:yelpify/models/service_model.dart';
import 'package:yelpify/models/sponsored_request_model.dart';

class BusinessModel {
  String? id;
  String? createdBy;
  String? ownerId;
  String? countryCode;
  String? countryISOCode;
  String? countryName;
  String? businessName;
  String? description;
  String? coverPhoto;
  List<dynamic>? searchKeyword;
  String? phoneNumber;
  String? website;
  String? noteForYelpTeam;
  String? zipCode;
  Positions? position;
  LatLngModel? location;
  AddressModel? address;
  List<CategoryModel>? category;
  List<dynamic>? services;
  List<dynamic>? recommendUserId;
  List<dynamic>? bookmarkUserId;
  List<dynamic>? suggestedBusinessRemovedUserId;
  bool? asCustomerOrWorkAtBusiness;
  bool? isVerified;
  bool? isPermanentClosed;
  bool? publish;
  bool? showWorkingHours;
  String? recommendYesCount;
  String? reviewCount;
  String? reviewSum;
  BusinessHours? businessHours;
  SponsoredRequestModel? sponsored;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  List<dynamic>? highLights;
  String? slug;
  List<dynamic>? metaKeywords;
  String? fbLink;
  String? instaLink;

  BusinessModel(
      {this.id,
      this.createdBy,
      this.ownerId,
      this.countryCode,
      this.countryISOCode,
      this.countryName,
      this.businessName,
      this.description,
      this.coverPhoto,
      this.searchKeyword,
      this.phoneNumber,
      this.website,
      this.noteForYelpTeam,
      this.zipCode,
      this.position,
      this.location,
      this.address,
      this.category,
      this.asCustomerOrWorkAtBusiness,
      this.isVerified,
      this.publish,
      this.showWorkingHours,
      this.isPermanentClosed,
      this.services,
      this.recommendUserId,
      this.bookmarkUserId,
      this.suggestedBusinessRemovedUserId,
      this.recommendYesCount,
      this.reviewCount,
      this.reviewSum,
      this.businessHours,
      this.sponsored,
      this.highLights,
      this.slug,
      this.metaKeywords,
      this.fbLink,
      this.instaLink});

  BusinessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdBy = json['createdBy'];
    ownerId = json['ownerId'];
    countryCode = json['countryCode'];
    countryISOCode = json['countryISOCode'];
    countryName = json['countryName'];
    businessName = json['businessName'];
    description = json['description'];
    coverPhoto = json['coverPhoto'];
    searchKeyword = json['searchKeyword'];
    phoneNumber = json['phoneNumber'] ?? '';
    website = json['website'] ?? '';
    noteForYelpTeam = json['noteForYelpTeam'];
    zipCode = json['zipCode'];
    position = json['position'] != null ? Positions.fromJson(json['position']) : Positions();
    location = json['location'] != null ? LatLngModel.fromJson(json['location']) : LatLngModel();
    address = json['address'] != null ? AddressModel.fromJson(json['address']) : AddressModel();
    if (json['category'] != null) {
      category = <CategoryModel>[];
      json['category'].forEach((v) {
        category!.add(CategoryModel.fromJson(v));
      });
    }
    asCustomerOrWorkAtBusiness = json['asCustomerOrWorkAtBusiness'];
    isVerified = json['isVerified'];
    publish = json['publish'];
    showWorkingHours = json['showWorkingHours'];
    isPermanentClosed = json['isPermanentClosed'];
    services = json['services'];
    recommendUserId = json['recommendUserId'] ?? [];
    bookmarkUserId = json['bookmarkUserId'] ?? [];
    suggestedBusinessRemovedUserId = json['suggestedBusinessRemovedUserId'] ?? [];
    recommendYesCount = json['recommendYesCount'] ?? "0.0";
    reviewCount = json['reviewCount'] ?? "0.0";
    reviewSum = json['reviewSum'] ?? "0";
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    businessHours = json['businessHours'] != null ? BusinessHours.fromJson(json['businessHours']) : null;
    sponsored = json['sponsored'] != null ? SponsoredRequestModel.fromJson(json['sponsored']) : null;
    highLights = json['highLights'] ?? [];
    slug = json['slug'];
    metaKeywords = json['metaKeywords'];
    fbLink = json['fbLink'];
    instaLink = json['instaLink'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdBy'] = createdBy;
    data['ownerId'] = ownerId;
    data['countryCode'] = countryCode;
    data['countryISOCode'] = countryISOCode;
    data['countryName'] = countryName;
    data['businessName'] = businessName;
    data['description'] = description;
    data['coverPhoto'] = coverPhoto;
    data['searchKeyword'] = searchKeyword;
    data['phoneNumber'] = phoneNumber;
    data['website'] = website;
    data['noteForYelpTeam'] = noteForYelpTeam;
    data['zipCode'] = zipCode;
    data['recommendUserId'] = recommendUserId;
    data['bookmarkUserId'] = bookmarkUserId;
    data['suggestedBusinessRemovedUserId'] = suggestedBusinessRemovedUserId;
    if (position != null) {
      data['position'] = position!.toJson();
    }
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    data['asCustomerOrWorkAtBusiness'] = asCustomerOrWorkAtBusiness;
    data['isVerified'] = isVerified;
    data['publish'] = publish;
    data['showWorkingHours'] = showWorkingHours;
    data['isPermanentClosed'] = isPermanentClosed;
    data['services'] = services;
    data['bookmarkUserId'] = bookmarkUserId;
    data['recommendYesCount'] = recommendYesCount ?? "0.0";
    data['reviewCount'] = reviewCount ?? "0.0";
    data['reviewSum'] = reviewSum ?? "0.0";
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    if (businessHours != null) {
      data['businessHours'] = businessHours!.toJson();
    }
    if (sponsored != null) {
      data['sponsored'] = sponsored!.toJson();
    }
    data['highLights'] = highLights;
    data['slug'] = slug;
    data['metaKeywords'] = metaKeywords;
    data['fbLink'] = fbLink;
    data['instaLink'] = instaLink;
    return data;
  }

  Map<String, dynamic> toJsonRecent() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ownerId'] = ownerId;
    data['countryCode'] = countryCode;
    data['countryISOCode'] = countryISOCode;
    data['countryName'] = countryName;
    data['businessName'] = businessName;
    data['description'] = description;
    data['coverPhoto'] = coverPhoto;
    data['searchKeyword'] = searchKeyword;
    data['phoneNumber'] = phoneNumber;
    data['website'] = website;
    data['noteForYelpTeam'] = noteForYelpTeam;
    data['zipCode'] = zipCode;
    data['recommendUserId'] = recommendUserId;
    data['bookmarkUserId'] = bookmarkUserId;
    data['suggestedBusinessRemovedUserId'] = suggestedBusinessRemovedUserId;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    if (category != null) {
      data['category'] = category!.map((v) => v.toJson()).toList();
    }
    data['asCustomerOrWorkAtBusiness'] = asCustomerOrWorkAtBusiness;
    data['isVerified'] = isVerified;
    data['publish'] = publish;
    data['showWorkingHours'] = showWorkingHours;
    data['isPermanentClosed'] = isPermanentClosed;
    data['services'] = services;
    data['bookmarkUserId'] = bookmarkUserId;
    data['recommendYesCount'] = recommendYesCount ?? "0.0";
    data['reviewCount'] = reviewCount ?? "0.0";
    data['reviewSum'] = reviewSum ?? "0.0";
    if (businessHours != null) {
      data['businessHours'] = businessHours!.toJson();
    }
    data['highLights'] = highLights;
    data['slug'] = slug;
    data['metaKeywords'] = metaKeywords;
    data['fbLink'] = fbLink;
    data['instaLink'] = instaLink;
    return data;
  }

  List<Map<String, dynamic>> convertForUpload(List<dynamic> services) {
    return services.map((entry) {
      final Map<String, List<OptionModel>> map = Map<String, List<OptionModel>>.from(entry);
      return map.map((key, value) {
        return MapEntry(key, value.map((e) => e.toJson()).toList());
      });
    }).toList();
  }

  List<Map<String, List<OptionModel>>> decodeFromFirebase(List<dynamic> jsonList) {
    return jsonList.map((entry) {
      final map = Map<String, dynamic>.from(entry);
      return map.map((key, value) {
        List<OptionModel> options = (value as List).map((e) {
          if (e is OptionModel) return e;
          return OptionModel.fromJson(Map<String, dynamic>.from(e));
        }).toList();
        return MapEntry(key, options);
      });
    }).toList();
  }
}

class LatLngModel {
  String? latitude;
  String? longitude;

  LatLngModel({this.latitude, this.longitude});

  LatLngModel.fromJson(Map<String, dynamic> json) {
    latitude = '${json['latitude'] ?? '0.0'}';
    longitude = '${json['longitude'] ?? '0.0'}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class AddressModel {
  String? name;
  String? street;
  String? isoCountryCode;
  String? country;
  String? postalCode;
  String? administrativeArea;
  String? subAdministrativeArea;
  String? locality;
  String? subLocality;
  String? thoroughfare;
  String? subThoroughfare;
  String? formattedAddress;

  AddressModel(
      {this.name,
      this.street,
      this.isoCountryCode,
      this.country,
      this.postalCode,
      this.administrativeArea,
      this.subAdministrativeArea,
      this.locality,
      this.subLocality,
      this.thoroughfare,
      this.subThoroughfare,
      this.formattedAddress});

  AddressModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    street = json['street'];
    isoCountryCode = json['isoCountryCode'];
    country = json['country'];
    postalCode = json['postalCode'];
    administrativeArea = json['administrativeArea'];
    subAdministrativeArea = json['subAdministrativeArea'];
    locality = json['locality'];
    subLocality = json['subLocality'];
    thoroughfare = json['thoroughfare'];
    subThoroughfare = json['subThoroughfare'];
    formattedAddress = json['formattedAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['street'] = street;
    data['isoCountryCode'] = isoCountryCode;
    data['country'] = country;
    data['postalCode'] = postalCode;
    data['administrativeArea'] = administrativeArea;
    data['subAdministrativeArea'] = subAdministrativeArea;
    data['locality'] = locality;
    data['subLocality'] = subLocality;
    data['thoroughfare'] = thoroughfare;
    data['subThoroughfare'] = subThoroughfare;
    data['formattedAddress'] = formattedAddress;
    return data;
  }
}

class Positions {
  String? geoHash;
  GeoPoint? geoPoint;

  Positions({this.geoHash, this.geoPoint});

  Positions.fromJson(Map<String, dynamic> json) {
    geoHash = json['geohash'];
    geoPoint = json['geopoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['geohash'] = geoHash;
    data['geopoint'] = geoPoint;
    return data;
  }
}

class BusinessHours {
  List<dynamic>? monday;
  List<dynamic>? tuesday;
  List<dynamic>? wednesday;
  List<dynamic>? thursday;
  List<dynamic>? friday;
  List<dynamic>? saturday;
  List<dynamic>? sunday;

  BusinessHours({this.monday, this.tuesday, this.wednesday, this.thursday, this.friday, this.saturday, this.sunday});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    monday = json['monday'] ?? [];
    tuesday = json['tuesday'] ?? [];
    wednesday = json['wednesday'] ?? [];
    thursday = json['thursday'] ?? [];
    friday = json['friday'] ?? [];
    saturday = json['saturday'] ?? [];
    sunday = json['sunday'] ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['monday'] = monday;
    data['tuesday'] = tuesday;
    data['wednesday'] = wednesday;
    data['thursday'] = thursday;
    data['friday'] = friday;
    data['saturday'] = saturday;
    data['sunday'] = sunday;
    return data;
  }
}

class TimeRange {
  TimeOfDay open;
  TimeOfDay close;

  TimeRange({required this.open, required this.close});

  String toRangeString() {
    final openStr = open.format24h();
    final closeStr = close.format24h();
    return "$openStr-$closeStr";
  }
}

extension TimeFormatExt on TimeOfDay {
  String format24h() => '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}

class DayHours {
  bool isOpen;
  List<TimeRange> timeRanges;

  DayHours({required this.isOpen, required this.timeRanges});
}
