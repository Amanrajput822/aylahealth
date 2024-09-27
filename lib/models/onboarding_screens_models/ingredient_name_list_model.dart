class Ingredient_Name_List_Model {
  int? status;
  List<Ingredient_Name_List_Risponce>? data;

  Ingredient_Name_List_Model({this.status, this.data});

  Ingredient_Name_List_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Ingredient_Name_List_Risponce>[];
      json['data'].forEach((v) {
        data!.add(new Ingredient_Name_List_Risponce.fromJson(v));
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

class Ingredient_Name_List_Risponce {
  int? ingId;
  String? ingName;
  bool? isSelect;

  Ingredient_Name_List_Risponce({this.ingId, this.ingName, this.isSelect});

  Ingredient_Name_List_Risponce.fromJson(Map<String, dynamic> json) {
    ingId = json['ing_id'];
    ingName = json['ing_name'];
    isSelect = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ing_id'] = this.ingId;
    data['ing_name'] = this.ingName;
    return data;
  }
}