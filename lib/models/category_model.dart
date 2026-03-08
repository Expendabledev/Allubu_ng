class CategoryModel {
  bool? menuPhotos;
  List<dynamic>? children;
  List<dynamic>? services;
  bool? publish;
  String? name;
  String? icon;
  String? parentCategory;
  bool? getPricingForm;
  String? getPricingFormTitle;
  bool? uploadItems;
  String? slug;

  CategoryModel(
      {this.menuPhotos,
        this.children,
        this.publish,
        this.name,
        this.icon,
        this.parentCategory,
        this.getPricingForm,
        this.getPricingFormTitle,
        this.uploadItems,
        this.slug,this.services});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    menuPhotos = json['menuPhotos'];
    children = json['children'];
    publish = json['publish'];
    name = json['name'];
    icon = json['icon'];
    parentCategory = json['parentCategory'];
    getPricingForm = json['getPricingForm'];
    getPricingFormTitle = json['getPricingFormTitle'] ?? 'Get Pricing & availability';
    uploadItems = json['uploadItems'];
    slug = json['slug'];
    services = json['services'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['menuPhotos'] = menuPhotos;
    data['children'] = children;
    data['publish'] = publish;
    data['name'] = name;
    data['icon'] = icon;
    data['parentCategory'] = parentCategory;
    data['getPricingForm'] = getPricingForm;
    data['getPricingFormTitle'] = getPricingFormTitle;
    data['uploadItems'] = uploadItems;
    data['slug'] = slug;
    data['services'] = services;
    return data;
  }
}
