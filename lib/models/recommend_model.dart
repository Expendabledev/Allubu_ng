class RecommendModel {
  String? id;
  String? businessId;
  String? userId;
  String? vote;

  RecommendModel({this.id, this.businessId, this.userId, this.vote});

  RecommendModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['businessId'];
    userId = json['userId'];
    vote = json['vote'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['businessId'] = businessId;
    data['userId'] = userId;
    data['vote'] = vote;
    return data;
  }
}
