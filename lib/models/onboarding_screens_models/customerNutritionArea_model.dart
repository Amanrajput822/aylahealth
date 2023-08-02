class customerNutritionArea_model {
  int? status;
  List<customerNutritionArea_recponce>? data;

  customerNutritionArea_model({this.status, this.data});

  customerNutritionArea_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <customerNutritionArea_recponce>[];
      json['data'].forEach((v) {
        data!.add(new customerNutritionArea_recponce.fromJson(v));
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

class customerNutritionArea_recponce {
  int? opsId;
  String? opsText;

  customerNutritionArea_recponce({this.opsId, this.opsText});

  customerNutritionArea_recponce.fromJson(Map<String, dynamic> json) {
    opsId = json['ops_id'];
    opsText = json['ops_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ops_id'] = this.opsId;
    data['ops_text'] = this.opsText;
    return data;
  }
}