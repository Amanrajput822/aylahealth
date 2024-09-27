class checkSubscriptionApiModel {
  int? status;
  int? isActive;
  int? isExpired;
  String? expiresDate;
  int? isCanceled;

  checkSubscriptionApiModel(
      {this.status,
        this.isActive,
        this.isExpired,
        this.expiresDate,
        this.isCanceled});

  checkSubscriptionApiModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    isActive = json['isActive'];
    isExpired = json['isExpired'];
    expiresDate = json['expiresDate'];
    isCanceled = json['isCanceled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['isActive'] = this.isActive;
    data['isExpired'] = this.isExpired;
    data['expiresDate'] = this.expiresDate;
    data['isCanceled'] = this.isCanceled;
    return data;
  }
}