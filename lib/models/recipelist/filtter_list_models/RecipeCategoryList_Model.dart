class RecipeCategoryList_Model {
  int? status;
  List<RecipeCategoryList_Response>? data;

  RecipeCategoryList_Model({this.status, this.data});

  RecipeCategoryList_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <RecipeCategoryList_Response>[];
      json['data'].forEach((v) {
        data!.add(new RecipeCategoryList_Response.fromJson(v));
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

class RecipeCategoryList_Response {
  int? catId;
  String? catName;

  RecipeCategoryList_Response({this.catId, this.catName});

  RecipeCategoryList_Response.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    catName = json['cat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_id'] = this.catId;
    data['cat_name'] = this.catName;
    return data;
  }
}