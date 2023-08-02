class Gender_List_Model {
  int? status;
  List<Gender_List_recponse>? data;

  Gender_List_Model({this.status, this.data});

  Gender_List_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Gender_List_recponse>[];
      json['data'].forEach((v) {
        data!.add(new Gender_List_recponse.fromJson(v));
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

class Gender_List_recponse {
  int? genId;
  String? genName;

  Gender_List_recponse({this.genId, this.genName});

  Gender_List_recponse.fromJson(Map<String, dynamic> json) {
    genId = json['gen_id'];
    genName = json['gen_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gen_id'] = this.genId;
    data['gen_name'] = this.genName;
    return data;
  }
}