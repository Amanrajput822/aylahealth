class qution_list_model {
  int? status;
  List<qution_list_responce>? data;

  qution_list_model({this.status, this.data});

  qution_list_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <qution_list_responce>[];
      json['data'].forEach((v) {
        data!.add(new qution_list_responce.fromJson(v));
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

class qution_list_responce {
  int? queId;
  String? queText;
  String? queSubtext;
  int? queIndex;
  String? queType;
  String? queAnswerSource;
  List<OptionData>? optionData;

  qution_list_responce(
      {this.queId,
        this.queText,
        this.queSubtext,
        this.queIndex,
        this.queType,
        this.queAnswerSource,
        this.optionData});

  qution_list_responce.fromJson(Map<String, dynamic> json) {
    queId = json['que_id'];
    queText = json['que_text'];
    queSubtext = json['que_subtext'];
    queIndex = json['que_index'];
    queType = json['que_type'];
    queAnswerSource = json['que_answer_source'];
    if (json['optionData'] != null) {
      optionData = <OptionData>[];
      json['optionData'].forEach((v) {
        optionData!.add(new OptionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['que_id'] = this.queId;
    data['que_text'] = this.queText;
    data['que_subtext'] = this.queSubtext;
    data['que_index'] = this.queIndex;
    data['que_type'] = this.queType;
    data['que_answer_source'] = this.queAnswerSource;
    if (this.optionData != null) {
      data['optionData'] = this.optionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OptionData {
  int? opsId;
  String? opsText;
  bool? isSelected;

  OptionData({this.opsId, this.opsText, this.isSelected});

  OptionData.fromJson(Map<String, dynamic> json) {
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