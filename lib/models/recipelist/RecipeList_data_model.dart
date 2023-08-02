class RecipeList_data_model {
  int? status;
  List<RecipeList_data_Response>? data;
  int? count;

  RecipeList_data_model({this.status, this.data, this.count});

  RecipeList_data_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <RecipeList_data_Response>[];
      json['data'].forEach((v) {
        data!.add(new RecipeList_data_Response.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}

class RecipeList_data_Response {
  int? recId;
  String? recTitle;
  String? image;
  int? favStatus;
  bool? recipes_like;


  RecipeList_data_Response({this.recId, this.recTitle, this.image,this.favStatus,this.recipes_like});

  RecipeList_data_Response.fromJson(Map<String, dynamic> json) {
    recId = json['rec_id'];
    recTitle = json['rec_title'];
    image = json['image'];
    favStatus = json['fav_status'];
    recipes_like = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rec_id'] = this.recId;
    data['rec_title'] = this.recTitle;
    data['image'] = this.image;
    data['fav_status'] = this.favStatus;
    return data;
  }
}