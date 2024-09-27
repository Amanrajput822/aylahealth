class searchModuleModel {
  int? status;
  List<searchModuleResponse>? data;

  searchModuleModel({this.status, this.data});

  searchModuleModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <searchModuleResponse>[];
      json['data'].forEach((v) {
        data!.add(new searchModuleResponse.fromJson(v));
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

class searchModuleResponse {
  int? mdId;
  int? mcId;
  int? mscId;
  String? mdTitle;
  String? mdSummary;
  String? image;
  String? mscName;
  String? mcName;

  searchModuleResponse(
      {this.mdId,
        this.mcId,
        this.mscId,
        this.mdTitle,
        this.mdSummary,
        this.image,
        this.mscName,
        this.mcName});

  searchModuleResponse.fromJson(Map<String, dynamic> json) {
    mdId = json['md_id'];
    mcId = json['mc_id'];
    mscId = json['msc_id'];
    mdTitle = json['md_title'];
    mdSummary = json['md_summary'];
    image = json['image'];
    mscName = json['msc_name'];
    mcName = json['mc_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['md_id'] = this.mdId;
    data['mc_id'] = this.mcId;
    data['msc_id'] = this.mscId;
    data['md_title'] = this.mdTitle;
    data['md_summary'] = this.mdSummary;
    data['image'] = this.image;
    data['msc_name'] = this.mscName;
    data['mc_name'] = this.mcName;
    return data;
  }
}