class LanguageModel {
  String? image;
  String? slug;
  bool? isDeleted;
  bool? publish;
  String? title;
  String? id;
  bool? isRtl;

  LanguageModel({this.image, this.slug, this.isDeleted, this.publish, this.title, this.id, this.isRtl});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    slug = json['slug'];
    isDeleted = json['isDeleted'];
    publish = json['publish'];
    title = json['title'];
    id = json['id'];
    isRtl = json['isRtl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['slug'] = slug;
    data['isDeleted'] = isDeleted;
    data['publish'] = publish;
    data['title'] = title;
    data['id'] = id;
    data['isRtl'] = isRtl;
    return data;
  }
}
