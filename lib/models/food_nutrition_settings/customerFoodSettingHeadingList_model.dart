class customerFoodSettingHeadingList_model {
  int? status;
  List<customerFoodSettingHeadingList_responce>? data;

  customerFoodSettingHeadingList_model({this.status, this.data});

  customerFoodSettingHeadingList_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <customerFoodSettingHeadingList_responce>[];
      json['data'].forEach((v) {
        data!.add(new customerFoodSettingHeadingList_responce.fromJson(v));
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

class customerFoodSettingHeadingList_responce {
  int? queId;
  String? fshText;
  String? fshDescription;
  int? fshIndex;
  String? queType;
  String? queAnswerSource;
  List<CustomerAnswer>? customerAnswer;

  customerFoodSettingHeadingList_responce(
      {this.queId,
        this.fshText,
        this.fshDescription,
        this.fshIndex,
        this.queType,
        this.queAnswerSource,
        this.customerAnswer});

  customerFoodSettingHeadingList_responce.fromJson(Map<String, dynamic> json) {
    queId = json['que_id'];
    fshText = json['fsh_text'];
    fshDescription = json['fsh_description'];
    fshIndex = json['fsh_index'];
    queType = json['que_type'];
    queAnswerSource = json['que_answer_source'];
    if (json['customerAnswer'] != null) {
      customerAnswer = <CustomerAnswer>[];
      json['customerAnswer'].forEach((v) {
        customerAnswer!.add(new CustomerAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['que_id'] = this.queId;
    data['fsh_text'] = this.fshText;
    data['fsh_description'] = this.fshDescription;
    data['fsh_index'] = this.fshIndex;
    data['que_type'] = this.queType;
    data['que_answer_source'] = this.queAnswerSource;
    if (this.customerAnswer != null) {
      data['customerAnswer'] =
          this.customerAnswer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerAnswer {
  String? opsText;
  String? ingName;

  CustomerAnswer({this.opsText, this.ingName});

  CustomerAnswer.fromJson(Map<String, dynamic> json) {
    opsText = json['ops_text'];
    ingName = json['ing_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ops_text'] = this.opsText;
    data['ing_name'] = this.ingName;
    return data;
  }
}