class RecipeCollectionListModel {
  int? status;
  List<RecipeCollectionListResponse>? data;

  RecipeCollectionListModel({this.status, this.data});

  RecipeCollectionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <RecipeCollectionListResponse>[];
      json['data'].forEach((v) {
        data!.add(new RecipeCollectionListResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecipeCollectionListResponse {
  int? collId;
  String? collName;
  String? image;

  RecipeCollectionListResponse({this.collId, this.collName, this.image});

  RecipeCollectionListResponse.fromJson(Map<String, dynamic> json) {
    collId = json['coll_id'];
    collName = json['coll_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coll_id'] = this.collId;
    data['coll_name'] = this.collName;
    data['image'] = this.image;
    return data;
  }
}