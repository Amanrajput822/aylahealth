import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/recipelist/filtter_list_models/Recipe_Filtter_model.dart';

class MultiSelectChip extends StatefulWidget {
  final List<FilterTag> items;
  final List<FilterTag> selectedItems;
  final List<FilterTag>? saveItems;
  final Function(List<FilterTag>) onSelectionChanged;
  final bool? listtype;
  final double? titlefont;
   bool? usetime;

  MultiSelectChip({required this.items, required this.selectedItems, this.saveItems, required this.onSelectionChanged, this.listtype, this.titlefont,this.usetime});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {

  @override
  Widget build(BuildContext context) {

    return Wrap(
      spacing: 8.0,
      runSpacing: 8,
      children: widget.items.map((item) {
        var isSelected = widget.selectedItems.contains(item);
        return Container(
          height: 30,
          child: FilterChip(

            shape: StadiumBorder(side: BorderSide(color: colorBluePigment)),
            backgroundColor: colorWhite,
            showCheckmark: false,
            selectedColor: colorBluePigment,
            disabledColor: colorWhite,
            padding: EdgeInsets.only(bottom: 3),
            label: Text(item.tagName??""),
            labelStyle: TextStyle(
                color: isSelected?colorWhite:colorBluePigment,
                fontSize: 14,
                fontFamily: fontFamilyText,
                fontWeight: fontWeight400
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  widget.selectedItems.add(item);
                  widget.usetime = true;
                } else {
                  widget.selectedItems.remove(item);
                  widget.usetime = true;
                }
                widget.onSelectionChanged(widget.selectedItems);
              });
            },
          ),
        );
      }).toList(),
    );
  }
}
//
// /////////////// MultiSelectChip1 /////////////////////////
//
// class MultiSelectChip1 extends StatefulWidget {
//   final List<RecipeCategoryList_Response> items;
//   final List<RecipeCategoryList_Response> selectedItems;
//   final Function(List<RecipeCategoryList_Response>) onSelectionChanged;
//   final double? titlefont;
//
//   MultiSelectChip1({required this.items, required this.selectedItems, required this.onSelectionChanged, this.titlefont});
//
//   @override
//   _MultiSelectChip1State createState() => _MultiSelectChip1State();
// }
//
// class _MultiSelectChip1State extends State<MultiSelectChip1> {
//
//   List<FilterTag> selectedChoices = [];
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       scrollDirection: Axis.horizontal,
//       children: widget.items.map((item) {
//         final isSelected = widget.selectedItems.contains(item);
//         return Padding(
//           padding: const EdgeInsets.only(right: 5.0),
//           child: Container(
//             height: 30,
//             child: FilterChip(
//               shape: StadiumBorder(side: BorderSide(color: colorBluePigment)),
//               backgroundColor: colorWhite,
//               showCheckmark: false,
//               selectedColor: colorBluePigment,
//               disabledColor: colorWhite,
//               padding: const EdgeInsets.only(bottom: 3.0),
//               label: Text(item.catName??""),
//               labelStyle: TextStyle(
//                   color: isSelected?colorWhite:colorBluePigment,
//                   fontSize: 14,
//                   fontFamily: fontFamilyText,
//                   fontWeight: fontWeight400
//               ),
//               selected: isSelected,
//               onSelected: (selected) {
//                 setState(() {
//                   if (selected) {
//                     widget.selectedItems.add(item);
//                   } else {
//                     widget.selectedItems.remove(item);
//                   }
//                   widget.onSelectionChanged(widget.selectedItems);
//                 });
//               },
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }