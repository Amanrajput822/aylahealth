
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SliverWithTabBar extends StatefulWidget {
  @override
  _SliverWithTabBarState createState() => _SliverWithTabBarState();
}

class _SliverWithTabBarState extends State<SliverWithTabBar> with SingleTickerProviderStateMixin {
  final GlobalKey _childKey = GlobalKey();
  bool isHeightCalculated = false;
  double height12 = 0.0;

  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!isHeightCalculated) {
        isHeightCalculated = true;
        setState(() {
          height12 = (_childKey.currentContext!.findRenderObject() as RenderBox)
              .size
              .height;
          print('height12.toString()');
          print(height12.toString());
          print('height12.toString()');
        });
      }
    });
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(

                collapseMode: CollapseMode.pin,
                background: Column(
                  key: _childKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(

                      height: 200.0,
                      width: double.infinity,
                      color: Colors.grey,
                      child: FlutterLogo(),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Business Office',
                        style: TextStyle(fontSize: 25.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Open now\nStreet Address, 299\nCity, State\n',
                        style: TextStyle(fontSize: 15.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const <Widget>[
                          Icon(Icons.share),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Icons.favorite),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              expandedHeight: isHeightCalculated ? height12 : 300.0,
              bottom: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: [
                  Tab(text: 'POSTS'),
                  Tab(text: 'DETAILS'),
                  Tab(text: 'FOLLOWERS'),
                ],
                controller: controller,
              ),
            )
          ];
        },
        body: ListView.builder(
          itemCount: 100,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: index % 2 == 0 ? Colors.blue : Colors.green,
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 100.0,
                child: Text(
                  'Flutter is awesome',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

//
// import 'package:aylahealth/demo/constants.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:multiple_search_selection/helpers/create_options.dart';
// import 'package:multiple_search_selection/multiple_search_selection.dart';
//
// import '../common/styles/const.dart';
//
//
// class MyHomePage11111 extends StatelessWidget {
//   const MyHomePage11111({Key? key}) : super(key: key);
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Multiple Search Selection Example',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       scrollBehavior: ScrollConfiguration.of(context).copyWith(
//         dragDevices: {
//           PointerDeviceKind.touch,
//           PointerDeviceKind.mouse,
//         },
//       ),
//       home: const MyHomePage(title: 'Multiple Search Selection Example'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: MultipleSearchSelection<Country>.creatable(
//         showClearSearchFieldButton: false,
//        // initialPickedItems: countries.toList(),
//
//         onItemAdded: (c) {
//           setState(() {
//            // _itemChange(c.iso.toString(), true);
//           });
//         },
//
//         createOptions: CreateOptions(
//           createItem: (text) {
//             return Country(name: text, iso: int.parse(text));
//           },
//           onItemCreated: (c) => print('Country ${c.name} created'),
//           createItemBuilder: (text) => Align(
//             alignment: Alignment.centerLeft,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('Create "$text"'),
//             ),
//           ),
//           pickCreatedItem: true,
//         ),
//         items: countries, // List<Country>
//         fieldToCheck: (c) {
//           return c.name;
//         },
//         itemBuilder: (country, index) {
//           return Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(6),
//               color: Colors.white,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 10.0,
//                 horizontal: 10,
//               ),
//               child:Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(country.name,style:TextStyle(
//                       color:  colorRichblack,
//                       fontFamily: 'Messina Sans',
//                       fontWeight: FontWeight.w400,
//                       fontSize:  16)),
//                   Divider(thickness: 0.5,color: colorgrey,)
//                 ],
//               ),
//             ),
//           );
//         },
//         pickedItemsContainerMaxHeight: 100,
//         pickedItemsScrollPhysics: ScrollPhysics(),
//         pickedItemBuilder: (country) {
//           return Container(
//             decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.grey[400]!),
//                 borderRadius: BorderRadius.circular(10)
//             ),
//             child: Padding(
//               padding:  EdgeInsets.all(5),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(country.name,style:TextStyle(
//                       color:  colorRichblack,
//                       fontFamily: 'Messina Sans',
//                       fontWeight: FontWeight.w400,
//                       fontSize:  15)),
//                   Icon(Icons.close)
//                 ],
//               ),
//             ),
//           );
//         },
//         searchFieldInputDecoration:InputDecoration(
//           hintText: 'Search',
//           filled: true,
//           focusColor: HexColor('#F6F7FB'),
//           border: InputBorder.none,
//           prefixIcon: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: SvgPicture.asset('assets/Search.svg'),
//           ),
//           suffixIcon: Padding(
//             padding: const EdgeInsets.all(18.0),
//             child: SvgPicture.asset('assets/Stroke 1.svg'),
//           ),
//           enabledBorder: UnderlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: colorWhite),
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: colorWhite),
//           ),
//         ),
//
//         searchFieldTextStyle: TextStyle(
//             color:  colorRichblack,
//             fontFamily: 'Messina Sans',
//             fontWeight: FontWeight.w400,
//             fontSize:  16),
//         searchFieldBoxDecoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//         ),
//
//         onItemRemoved: (item) {
//           setState(() {
//            // _itemChange(item.iso.toString(), false);
//           });
//         },
//         sortShowedItems: true,
//         clearSearchFieldOnSelect: true,
//         sortPickedItems: true,
//         caseSensitiveSearch: false,
//         fuzzySearch: FuzzySearch.none,
//         itemsVisibility: ShowedItemsVisibility.alwaysOn,
//         showSelectAllButton: false,
//         showClearAllButton: false,
//        // maximumShowItemsHeight: 400,
//         showedItemsBoxDecoration: BoxDecoration(color: colorWhite),
//         maxSelectedItems: countries.length,
//         textFieldFocus:  FocusNode(),
//
//
//
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
//
//




// import 'package:flutter/material.dart';
//
//
//
// // Multi Select widget
// // This widget is reusable
// class MultiSelect extends StatefulWidget {
//   final List<String> items;
//   const MultiSelect({Key? key, required this.items}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _MultiSelectState();
// }
//
// class _MultiSelectState extends State<MultiSelect> {
//   // this variable holds the selected items
//   final List<String> _selectedItems = [];
//
// // This function is triggered when a checkbox is checked or unchecked
//   void _itemChange(String itemValue, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(itemValue);
//       } else {
//         _selectedItems.remove(itemValue);
//       }
//     });
//   }
//
//   // this function is called when the Cancel button is pressed
//   void _cancel() {
//     Navigator.pop(context);
//   }
//
// // this function is called when the Submit button is tapped
//   void _submit() {
//     _selectedItems;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//      children: [
//        SingleChildScrollView(
//          child: ListBody(
//            children: widget.items
//                .map((item) =>
//                CheckboxListTile(
//              value: _selectedItems.contains(item),
//              title: Text(item),
//              controlAffinity: ListTileControlAffinity.leading,
//              onChanged: (isChecked) => _itemChange(item, isChecked!),
//            ))
//                .toList(),
//          ),
//        ),
//        TextButton(
//          onPressed: _cancel,
//          child: const Text('Cancel'),
//        ),
//        ElevatedButton(
//          onPressed: _submit,
//          child: const Text('Submit'),
//        ),
//      ],
//
//
//     );
//   }
// }
//
// // Implement a multi select on the Home screen
// class demo extends StatefulWidget {
//   const demo({Key? key}) : super(key: key);
//
//   @override
//   State<demo> createState() => _demoState();
// }
//
// class _demoState extends State<demo> {
//   List<String> _selectedItems = [];
//
//   void _showMultiSelect() async {
//
//     final List<String>? results = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return MultiSelect(items: items);
//       },
//     );
//
//     // Update UI
//     if (results != null) {
//       setState(() {
//         _selectedItems = results;
//       });
//     }
//   }
//   final List<String> items = [
//     'Flutter',
//     'Node.js',
//     'React Native',
//     'Java',
//     'Docker',
//     'MySQL'
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('KindaCode.com'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // use this button to open the multi-select dialog
//             MultiSelect(items: items),
//             const Divider(
//               height: 30,
//             ),
//             // display selected items
//             Wrap(
//               children: _selectedItems
//                   .map((e) => Chip(
//                 label: Text(e),
//               ))
//                   .toList(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }