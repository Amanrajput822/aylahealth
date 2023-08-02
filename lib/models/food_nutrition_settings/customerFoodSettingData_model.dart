class customerFoodSettingData_model {
  int? status;
  customerFoodSettingData_response? data;

  customerFoodSettingData_model({this.status, this.data});

  customerFoodSettingData_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new customerFoodSettingData_response.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class customerFoodSettingData_response {
  List<Options>? options;
  List<CustomerAnswer1>? customerAnswer;

  customerFoodSettingData_response({this.options, this.customerAnswer});

  customerFoodSettingData_response.fromJson(Map<String, dynamic> json) {
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
    if (json['customerAnswer'] != null) {
      customerAnswer = <CustomerAnswer1>[];
      json['customerAnswer'].forEach((v) {
        customerAnswer!.add(new CustomerAnswer1.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    if (this.customerAnswer != null) {
      data['customerAnswer'] =
          this.customerAnswer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  int? opsId;
  String? opsText;
  bool? isSelected;

  Options({this.opsId, this.opsText, this.isSelected});

  Options.fromJson(Map<String, dynamic> json) {
    opsId = json['ops_id'];
    opsText = json['ops_text'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ops_id'] = this.opsId;
    data['ops_text'] = this.opsText;
    data['isSelected'] = this.isSelected;
    return data;
  }
}


class CustomerAnswer1 {
  int? opsId;
  String? opsText;
  int? ingId;
  int? isAnswer;

  CustomerAnswer1({this.opsId, this.opsText, this.ingId,this.isAnswer});

  CustomerAnswer1.fromJson(Map<String, dynamic> json) {
    opsId = json['ops_id'];
    opsText = json['ops_text'];
    ingId = json['ing_id'];
    isAnswer = json['isAnswer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ops_id'] = this.opsId;
    data['ops_text'] = this.opsText;
    data['ing_id'] = this.ingId;
    data['isAnswer'] = this.isAnswer;
    return data;
  }
}



