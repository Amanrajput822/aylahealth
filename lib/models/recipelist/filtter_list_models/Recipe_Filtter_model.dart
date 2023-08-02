class Recipe_Filtter_model {
  int? status;
  Recipe_Filtter_Response? data;

  Recipe_Filtter_model({this.status, this.data});

  Recipe_Filtter_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Recipe_Filtter_Response.fromJson(json['data']) : null;
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

class Recipe_Filtter_Response {
  List<EatingPattern>? eatingPattern;

  List<FilterTag>? filterTag;

  Recipe_Filtter_Response({this.eatingPattern, this.filterTag});

  Recipe_Filtter_Response.fromJson(Map<String, dynamic> json) {
    if (json['eatingPattern'] != null) {
      eatingPattern = <EatingPattern>[];
      json['eatingPattern'].forEach((v) {
        eatingPattern!.add(new EatingPattern.fromJson(v));
      });
    }

    if (json['filterTag'] != null) {
      filterTag = <FilterTag>[];
      json['filterTag'].forEach((v) {
        filterTag!.add(new FilterTag.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eatingPattern != null) {
      data['eatingPattern'] =
          this.eatingPattern!.map((v) => v.toJson()).toList();
    }

    if (this.filterTag != null) {
      data['filterTag'] = this.filterTag!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EatingPattern {
  int? eatId;
  String? eatName;

  EatingPattern({this.eatId, this.eatName});

  EatingPattern.fromJson(Map<String, dynamic> json) {
    eatId = json['eat_id'];
    eatName = json['eat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eat_id'] = this.eatId;
    data['eat_name'] = this.eatName;
    return data;
  }
}

class RecipeCategory {
  int? catId;
  String? catName;

  RecipeCategory({this.catId, this.catName});

  RecipeCategory.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'];
    catName = json['cat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_id'] = this.catId;
    data['cat_name'] = this.catName;
    return data;
  }
}

class FilterTag {
  int? tagId;
  String? tagName;
  bool isSelect =true; // Add isSelect property

  FilterTag({this.tagId, this.tagName, this.isSelect = false}); // Add default value for isSelect

  FilterTag.fromJson(Map<String, dynamic> json) {
    tagId = json['tag_id'];
    tagName = json['tag_name'];
    isSelect = json['is_select'] ?? false; // Optional: handle null value in JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_id'] = this.tagId;
    data['tag_name'] = this.tagName;
    data['is_select'] = this.isSelect;
    return data;
  }

  // Getter for isSelect
  bool get selected {
    return isSelect;
  }

  // Setter for isSelect
  set selected(bool selected) {
    isSelect = selected;
  }
}