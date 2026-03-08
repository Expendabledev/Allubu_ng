import 'package:get/get.dart';
import 'package:yelpify/models/business_model.dart';
import 'package:yelpify/models/service_model.dart';
import 'package:yelpify/utils/fire_store_utils.dart';

class AddServiceController extends GetxController {
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getArgument();
    // TODO: implement onInit
    super.onInit();
  }

  Rx<BusinessModel> businessModel = BusinessModel().obs;

  RxList<ServiceModel> serviceList = <ServiceModel>[].obs;

  RxList<SelectedServiceModel> selectedServiceModel = <SelectedServiceModel>[].obs;
  RxList<Map<String, List<OptionModel>>> services = <Map<String, List<OptionModel>>>[].obs;

  Future<void> getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      businessModel.value = argumentData['businessModel'];
      services.value = BusinessModel().decodeFromFirebase(businessModel.value.services ?? []);
      await getSpecification();
    }
    isLoading.value = false;
    update();
  }

  Future<void> getSpecification() async {
    for (var element in businessModel.value.category!) {
      if (element.services != null) {
        for (var element0 in element.services!) {
          await FireStoreUtils.getServiceById(element0.toString()).then(
            (value) {
              if (value != null) {
                serviceList.add(value);
              }
            },
          );
        }
      }
    }

    selectedServiceModel.clear();
    for (var element in services) {
      element.forEach((key, value) {
        selectedServiceModel.add(SelectedServiceModel(id: key, options: value));
      });
    }
    update();
  }

  void toggleOption(ServiceModel serviceModel, OptionModel option, bool selected) {
    int indexOfModel = selectedServiceModel.indexWhere((e) => e.id == serviceModel.id);

    if (selected) {
      if (indexOfModel == -1) {
        selectedServiceModel.add(SelectedServiceModel(id: serviceModel.id, options: [option]));
      } else {
        List<OptionModel> list = selectedServiceModel[indexOfModel].options ?? [];
        if (!list.any((e) => e.name == option.name)) {
          list.add(option);
          selectedServiceModel[indexOfModel].options = list;
        }
      }
    } else {
      if (indexOfModel != -1) {
        List<OptionModel> list = selectedServiceModel[indexOfModel].options ?? [];
        list.removeWhere((e) => e.name == option.name);
        if (list.isEmpty) {
          selectedServiceModel.removeAt(indexOfModel);
        } else {
          selectedServiceModel[indexOfModel].options = list;
        }
      }
    }

    selectedServiceModel.refresh(); // Trigger rebuild
  }

  Future<void> saveDetails() async {
    services.clear();
    for (var element in selectedServiceModel) {
      if (element.options!.isNotEmpty) {
        if (services.where((p0) => p0.keys.toString() == element.id.toString()).isEmpty) {
          services.add({element.id.toString(): element.options!});
        }
      }
    }

    businessModel.value.services = BusinessModel().convertForUpload(services);

    await FireStoreUtils.addBusiness(businessModel.value).then(
      (value) {
        Get.back(result: true);
      },
    );
  }
}

class SelectedServiceModel {
  String? id;
  List<OptionModel>? options;

  SelectedServiceModel({this.id, this.options});

  SelectedServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['options'] != null) {
      options = <OptionModel>[];
      json['options'].forEach((v) {
        options!.add(OptionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
