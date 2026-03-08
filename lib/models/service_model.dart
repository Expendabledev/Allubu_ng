class ServiceModel {
  String? name;
  List<OptionModel>? options;
  bool? publish;
  bool? filter;
  String? id;

  ServiceModel({this.name, this.options, this.publish, this.id,this.filter});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['options'] != null) {
      options = <OptionModel>[];
      json['options'].forEach((v) {
        options!.add(OptionModel.fromJson(v));
      });
    }
    publish = json['publish'];
    id = json['id'];
    filter = json['filter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['options'] = options;
    data['publish'] = publish;
    data['id'] = id;
    data['filter'] = filter;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionModel {
  String? icon;
  String? name;

  OptionModel({this.icon, this.name});

  OptionModel.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['name'] = name;
    return data;
  }
}

