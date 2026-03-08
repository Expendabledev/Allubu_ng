class ItemModel {
  String? id;
  String? name;
  String? description;
  String? price;
  List<dynamic>? images;

  ItemModel({this.id, this.name, this.description, this.price, this.images});

  ItemModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['images'] = images;
    return data;
  }
}
