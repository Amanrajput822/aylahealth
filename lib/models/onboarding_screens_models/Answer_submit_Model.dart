class Answer_submit_Model {
  int? status;
  String? message;

  Answer_submit_Model({this.status, this.message});

  Answer_submit_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}