class Recipe_details_data_model {
  int? status;
  Recipe_details_data_recponse? data;

  Recipe_details_data_model({this.status, this.data});

  Recipe_details_data_model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Recipe_details_data_recponse.fromJson(json['data']) : null;
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

class Recipe_details_data_recponse {
  int? recId;
  String? recTitle;
  String? recDescription;
  int? recServes;
  String? recNote;
  String? eatName;
  int? eatId;
  String? image;
  int? favStatus;
  int? recipeNutritionExists;
  List<RecipeCategory>? recipeCategory;
 // List<EatingPattern>? eatingPattern;
  List<RecipeTag>? recipeTag;
  List<RecipeIngredient>? recipeIngredient;
  List<RecipeNutrition>? recipeNutrition;
  List<RecipeMethod>? recipeMethod;

  Recipe_details_data_recponse(
      {this.recId,
        this.recTitle,
        this.recDescription,
        this.recServes,
        this.recNote,
        this.eatName,
        this.eatId,
        this.image,
        this.favStatus,
        this.recipeNutritionExists,
        this.recipeCategory,
       // this.eatingPattern,
        this.recipeTag,
        this.recipeIngredient,
        this.recipeNutrition,
        this.recipeMethod});

  Recipe_details_data_recponse.fromJson(Map<String, dynamic> json) {
    recId = json['rec_id'];
    recTitle = json['rec_title'];
    recDescription = json['rec_description'];
    recServes = json['rec_serves'];
    recNote = json['rec_note'];
    eatName = json['eat_name'];
    eatId = json['eat_id'];
    image = json['image'];
    favStatus = json['fav_status'];
    recipeNutritionExists = json['recipeNutritionExists'];
    if (json['recipeCategory'] != null) {
      recipeCategory = <RecipeCategory>[];
      json['recipeCategory'].forEach((v) {
        recipeCategory!.add( RecipeCategory.fromJson(v));
      });
    }
    // if (json['eatingPattern'] != null) {
    //   eatingPattern = <EatingPattern>[];
    //   json['eatingPattern'].forEach((v) {
    //     eatingPattern!.add( EatingPattern.fromJson(v));
    //   });
    // }
    if (json['recipeTag'] != null) {
      recipeTag = <RecipeTag>[];
      json['recipeTag'].forEach((v) {
        recipeTag!.add( RecipeTag.fromJson(v));
      });
    }
    if (json['recipeIngredient'] != null) {
      recipeIngredient = <RecipeIngredient>[];
      json['recipeIngredient'].forEach((v) {
        recipeIngredient!.add( RecipeIngredient.fromJson(v));
      });
    }
    if (json['recipeNutrition'] != null) {
      recipeNutrition = <RecipeNutrition>[];
      json['recipeNutrition'].forEach((v) {
        recipeNutrition!.add( RecipeNutrition.fromJson(v));
      });
    }
    if (json['recipeMethod'] != null) {
      recipeMethod = <RecipeMethod>[];
      json['recipeMethod'].forEach((v) {
        recipeMethod!.add( RecipeMethod.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['rec_id'] = this.recId;
    data['rec_title'] = this.recTitle;
    data['rec_description'] = this.recDescription;
    data['rec_serves'] = this.recServes;
    data['rec_note'] = this.recNote;
    data['eat_name'] = this.eatName;
    data['eat_id'] = this.eatId;
    data['image'] = this.image;
    data['fav_status'] = this.favStatus;
    data['recipeNutritionExists'] = this.recipeNutritionExists;
    if (this.recipeCategory != null) {
      data['recipeCategory'] =
          this.recipeCategory!.map((v) => v.toJson()).toList();
    }
    // if (this.eatingPattern != null) {
    //   data['eatingPattern'] =
    //       this.eatingPattern!.map((v) => v.toJson()).toList();
    // }
    if (this.recipeTag != null) {
      data['recipeTag'] = this.recipeTag!.map((v) => v.toJson()).toList();
    }
    if (this.recipeIngredient != null) {
      data['recipeIngredient'] =
          this.recipeIngredient!.map((v) => v.toJson()).toList();
    }
    if (this.recipeNutrition != null) {
      data['recipeNutrition'] =
          this.recipeNutrition!.map((v) => v.toJson()).toList();
    }
    if (this.recipeMethod != null) {
      data['recipeMethod'] = this.recipeMethod!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
// class EatingPattern {
//   String? eatName;
//
//   EatingPattern({this.eatName});
//
//   EatingPattern.fromJson(Map<String, dynamic> json) {
//     eatName = json['eat_name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['eat_name'] = this.eatName;
//     return data;
//   }
// }
class RecipeCategory {
  String? catName;

  RecipeCategory({this.catName});

  RecipeCategory.fromJson(Map<String, dynamic> json) {
    catName = json['cat_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['cat_name'] = this.catName;
    return data;
  }
}

class RecipeTag {
  String? tagName;

  RecipeTag({this.tagName});

  RecipeTag.fromJson(Map<String, dynamic> json) {
    tagName = json['tag_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tag_name'] = this.tagName;
    return data;
  }
}

class RecipeIngredient {
  String? ingredientRecipeQuantity;
  String? ingredientRecipeDescription;
  String? ingName;
  String? varName;
  String? ingUnit;
  String? fgName;
  String? scName;

  RecipeIngredient(
      {this.ingredientRecipeQuantity,
        this.ingredientRecipeDescription,
        this.ingName,
        this.varName,
        this.ingUnit,
        this.fgName,
        this.scName});

  RecipeIngredient.fromJson(Map<String, dynamic> json) {
    ingredientRecipeQuantity = json['ingredient_recipe_quantity'];
    ingredientRecipeDescription = json['ingredient_recipe_description'];
    ingName = json['ing_name'];
    varName = json['var_name'];
    ingUnit = json['ing_unit'];
    fgName = json['fg_name'];
    scName = json['sc_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ingredient_recipe_quantity'] = this.ingredientRecipeQuantity;
    data['ingredient_recipe_description'] = this.ingredientRecipeDescription;
    data['ing_name'] = this.ingName;
    data['var_name'] = this.varName;
    data['ing_unit'] = this.ingUnit;
    data['fg_name'] = this.fgName;
    data['sc_name'] = this.scName;
    return data;
  }
}

class RecipeNutrition {
  String? nutName;
  String? nutUnit;
  var recNutQuantity;

  RecipeNutrition({this.nutName, this.nutUnit, this.recNutQuantity});

  RecipeNutrition.fromJson(Map<String, dynamic> json) {
    nutName = json['nut_name'];
    nutUnit = json['nut_unit'];
    recNutQuantity = json['rec_nut_quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nut_name'] = this.nutName;
    data['nut_unit'] = this.nutUnit;
    data['rec_nut_quantity'] = this.recNutQuantity;
    return data;
  }
}

class RecipeMethod {
  String? rmStep;

  RecipeMethod({this.rmStep});

  RecipeMethod.fromJson(Map<String, dynamic> json) {
    rmStep = json['rm_step'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rm_step'] = this.rmStep;
    return data;
  }
}