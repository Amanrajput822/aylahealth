
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/styles/const.dart';
import '../../../../models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';
import 'RecipeData_Provider.dart';

class MyBottomSheetWidget extends StatefulWidget {
  @override
  _MyBottomSheetWidgetState createState() => _MyBottomSheetWidgetState();
}

class _MyBottomSheetWidgetState extends State<MyBottomSheetWidget> {


  List<Widget> choiceChips_eatingPattern({List<EatingPattern>? eatingPattern, required RecipeData_Provider recipeModel}) {

    List<Widget> chips = [];

    for (int i = 0; i < eatingPattern!.length; i++) {

      Widget item = Container(
        height: 30,
        child: ChoiceChip(
          padding: EdgeInsets.only(bottom: 3),
          label: Text(eatingPattern[i].eatName??""),
          labelStyle: TextStyle(
              color: recipeModel.selectedIndex_eatingPattern_index == i?colorWhite:colorBluePigment,
              fontSize: 14,
              fontFamily: fontFamilyText,
              fontWeight: fontWeight400
          ),
          backgroundColor: colorWhite,
          selected: (recipeModel.selectedIndex_eatingPattern_index == i),

          selectedColor: colorBluePigment,
          shape: StadiumBorder(side: BorderSide(color: colorBluePigment)),
          onSelected: (bool value) {
            setState(() {
              if(i== recipeModel.selectedIndex_eatingPattern_index){
                recipeModel.addListener(() { });
                recipeModel.updateeatingPattern_is(null);
                recipeModel.updateselectedeatingPattern_index(null);
              }
              else{
                recipeModel.updateeatingPattern_is(eatingPattern[i].eatId!);
                recipeModel.updateselectedeatingPattern_index(i);
              }
              (context as Element).reassemble();
              print(recipeModel.selectedIndex_eatingPattern_index);
              print(recipeModel.selectedeatingPattern_id);
            });

          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final recipeModel = Provider.of<RecipeData_Provider>(context);
    return Container(
      // Your bottom sheet content
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8,
        direction: Axis.horizontal,
        children: choiceChips_eatingPattern(eatingPattern:recipeModel.filter_list_data!.eatingPattern,recipeModel:recipeModel),
      ),
    );
  }
}