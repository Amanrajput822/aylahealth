class moduleDetailsForAppDataModel {
  int? status;
  moduleDetailsForAppDataResponse? data;

  moduleDetailsForAppDataModel({this.status, this.data});

  moduleDetailsForAppDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new moduleDetailsForAppDataResponse.fromJson(json['data']) : null;
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

class moduleDetailsForAppDataResponse {
  int? mdId;
  int? mcId;
  int? mscId;
  String? mdTitle;
  String? mdSummary;
  String? mcName;
  String? mscName;
  String? image;

  moduleDetailsForAppDataResponse(
      {this.mdId,
        this.mcId,
        this.mscId,
        this.mdTitle,
        this.mdSummary,
        this.mcName,
        this.mscName,
        this.image});

  moduleDetailsForAppDataResponse.fromJson(Map<String, dynamic> json) {
    mdId = json['md_id'];
    mcId = json['mc_id'];
    mscId = json['msc_id'];
    mdTitle = json['md_title'];
    mdSummary = json['md_summary'];
    mcName = json['mc_name'];
    mscName = json['msc_name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['md_id'] = this.mdId;
    data['mc_id'] = this.mcId;
    data['msc_id'] = this.mscId;
    data['md_title'] = this.mdTitle;
    data['md_summary'] = this.mdSummary;
    data['mc_name'] = this.mcName;
    data['msc_name'] = this.mscName;
    data['image'] = this.image;
    return data;
  }
}