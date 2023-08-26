class FAQsQuestionAnswerModal {
  int? status;
  List<FAQsQuestionAnswerResponse>? data;

  FAQsQuestionAnswerModal({this.status, this.data});

  FAQsQuestionAnswerModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <FAQsQuestionAnswerResponse>[];
      json['data'].forEach((v) {
        data!.add( FAQsQuestionAnswerResponse.fromJson(v));
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

class FAQsQuestionAnswerResponse {
  int? faqId;
  String? faqHeading;
  List<QuestionData>? questionData;

  FAQsQuestionAnswerResponse({this.faqId, this.faqHeading, this.questionData});

  FAQsQuestionAnswerResponse.fromJson(Map<String, dynamic> json) {
    faqId = json['faq_id'];
    faqHeading = json['faq_heading'];
    if (json['questionData'] != null) {
      questionData = <QuestionData>[];
      json['questionData'].forEach((v) {
        questionData!.add(new QuestionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['faq_id'] = this.faqId;
    data['faq_heading'] = this.faqHeading;
    if (this.questionData != null) {
      data['questionData'] = this.questionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class QuestionData {
  int? fqueId;
  String? fqueText;
  AnswerData? answerData;

  QuestionData({this.fqueId, this.fqueText, this.answerData});

  QuestionData.fromJson(Map<String, dynamic> json) {
    fqueId = json['fque_id'];
    fqueText = json['fque_text'];
    answerData = json['answerData'] != null
        ? new AnswerData.fromJson(json['answerData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fque_id'] = this.fqueId;
    data['fque_text'] = this.fqueText;
    if (this.answerData != null) {
      data['answerData'] = this.answerData!.toJson();
    }
    return data;
  }
}

class AnswerData {
  String? fansText;

  AnswerData({this.fansText});

  AnswerData.fromJson(Map<String, dynamic> json) {
    fansText = json['fans_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fans_text'] = this.fansText;
    return data;
  }
}