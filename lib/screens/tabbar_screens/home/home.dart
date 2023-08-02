import 'package:aylahealth/common/styles/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Profile_screens/Profile_screen.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  ScrollController? _scrollController;
  bool lastStatus = true;


  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (deviceheight(context,0.2) - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    todayDate();
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  String? formattedTime;
  todayDate() {
    var now = new DateTime.now();
     formattedTime = DateFormat('EEEE d MMM yyyy').format(now);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              elevation: 0,
              backgroundColor: colorBlizzardBluedark,
              pinned: true,
              expandedHeight: deviceheight(context,0.28),

              leading: _isShrink
                  ? Padding(
                    padding: const EdgeInsets.only(top: 16.5,bottom: 16.5,left: 5),
                    child: SvgPicture.asset('assets/image/a icon.svg',height: 20,width: 20,),
                  )
                  : null,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.none,
                background: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      sizedboxheight(deviceheight(context,0.005)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/image/a icon.svg'),
                            IconButton(onPressed: (){
                              Get.to(() => Profile_screen());
                            }, icon: SvgPicture.asset('assets/image/profile.svg')),

                          ],
                        ),
                      ),
                      sizedboxheight(deviceheight(context,0.1)),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                        child: Text(formattedTime.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorPrimaryColor,
                            fontWeight: fontWeight400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
                        child: Text('Welcome aboard!',
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: fontFamilyText,
                            color: colorPrimaryColor,
                            fontWeight: fontWeight700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: _isShrink
                  ? [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(onPressed: (){
                    Get.to(() => Profile_screen());
                  }, icon: SvgPicture.asset('assets/image/profile.svg')),
                ),

              ]
                  : null,
            ),
          ];
        },
        body: Container(
          width: deviceWidth(context),
          height: deviceheight(context),
          color: colorBlizzardBluedark,

          child: Container(
            width: deviceWidth(context),
            height: deviceheight(context),
            decoration: BoxDecoration(
                color: colorWhite,

                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
            ),
            padding: EdgeInsets.only(left: 15,right: 15,bottom: 1),
            margin: EdgeInsets.only(bottom: 55),
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedboxheight(25.0),
                  hedingtile('Start Learning'),
                  sizedboxheight(15.0),
                  startlearningcard(),

                  sizedboxheight(15.0),
                  hedingtile('Recipes'),
                  sizedboxheight(15.0),
                  recipescard(),

                  sizedboxheight(15.0),
                  hedingtile('My Meals'),
                  sizedboxheight(15.0),
                  mymealscard(),

                  sizedboxheight(15.0),
                  benarcard('Favourites','A place for your favourite recipes.',
                      'assets/banera_favouritesimage.png', HexColor('#E9ECF1')),
                  sizedboxheight(15.0),
                  hedingtile('Featured'),
                  sizedboxheight(15.0),
                  featuredcard(),
                  sizedboxheight(15.0),
                  benarcard('Shopping list','Shopping list text.',
                      'assets/baneraApple.png', HexColor('#FFFFE1')),

                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget hedingtile(hedingtext){
    return Container(
      width: deviceWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: deviceWidth(context,0.7),
            child: Text(hedingtext,
              maxLines: 1,
              style: TextStyle(
              fontSize: 18,
              fontFamily: fontFamilyText,
              color: colorRichblack,
              fontWeight: fontWeight600,
                overflow: TextOverflow.ellipsis
            ),),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,size: 18,)
        ],
      ),

    );
  }

  Widget startlearningcard(){
    return  Container(
      height: 170,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 1,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right:10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),

                ),
                width: deviceWidth(context,0.65),
                height: 155,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/Screen Shot 2022-12-16 at 9.39 2.png')
                        ),

                      ),
                      width: deviceWidth(context,0.65),
                      height: 155,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient:  LinearGradient(
                              colors: [
                                HexColor('#3B4250').withOpacity(0.6),
                                HexColor('#3B4250').withOpacity(0.0),
                              ],
                              begin: FractionalOffset.bottomCenter,
                              end: FractionalOffset.topCenter,
                              tileMode: TileMode.repeated
                          )
                      ),
                      width: deviceWidth(context,0.65),
                      height: 155,
                      padding: EdgeInsets.only(bottom: 10,left: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Get Started',style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorWhite,
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            );

          }),
    );



  }

  Widget recipescard(){
    return Container(
      height: 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                width: deviceWidth(context,0.42),
                color: colorWhite,
                child: Column(
                  children: [
                    Image.asset('assets/Rectangle 1794.png',width:deviceWidth(context,0.42) ,height: 110,fit: BoxFit.fill,),
                    sizedboxheight(8.0),
                    Container(
                      width: deviceWidth(context,0.42),
                      child: Text('Roast Lamb & Vegetables',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                           // height: 1.3,
                            fontFamily: fontFamilyText,
                            color: HexColor('#3B4250'),
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),),
                    ),
                    sizedboxheight(8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.add_circle_outline,size: 18,color: colorShadowBlue,),
                        sizedboxwidth(5.0),
                        Container(
                          width: deviceWidth(context,0.35),
                          child: Text('Add to my meals',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: fontFamilyText,
                                color: HexColor('#79879C'),
                                fontWeight: fontWeight600,
                                overflow: TextOverflow.ellipsis
                            ),),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );

          }),
    );
  }

  Widget mymealscard(){
    return Container(
      height: 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                width: deviceWidth(context,0.42),
                color: colorWhite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: deviceWidth(context,0.35),
                      child: Text('Lunch',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: fontFamilyText,
                            color: HexColor('#79879C'),
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),),
                    ),
                    sizedboxheight(8.0),
                    Image.asset('assets/Rectangle 1794.png',width:deviceWidth(context,0.42) ,
                      height: 110,
                      fit: BoxFit.fill,
                    ),
                    sizedboxheight(8.0),
                    Container(
                      width: deviceWidth(context,0.42),
                      child: Text('Roast Lamb & Vegetables',
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: HexColor('#3B4250'),
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),),
                    ),

                  ],
                ),
              ),
            );

          }),
    );
  }

  Widget featuredcard(){
    return Container(
      height: 150,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),

                ),
                width: deviceWidth(context,0.35),
                height: 140,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/Screen Shot 2022-12-16 at 9.39 2.png')
                        ),

                      ),
                      width: deviceWidth(context,0.35),
                      height: 140,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          gradient:  LinearGradient(
                              colors: [
                                HexColor('#3B4250').withOpacity(0.6),
                                HexColor('#3B4250').withOpacity(0.0),
                              ],
                              begin: FractionalOffset.bottomCenter,
                              end: FractionalOffset.topCenter,
                              tileMode: TileMode.repeated
                          )
                      ),
                      width: deviceWidth(context,0.35),
                      height: 140,
                      padding: EdgeInsets.only(bottom: 10,left: 20),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text('Get Started',style: TextStyle(
                            fontSize: 16,
                            fontFamily: fontFamilyText,
                            color: colorWhite,
                            fontWeight: fontWeight600,
                            overflow: TextOverflow.ellipsis
                        ),),
                      ),
                    )
                  ],
                ),
              ),
            );

          }),
    );
  }

  Widget benarcard(hedingtext, lebletext,image, color){
    return Container(
      width: deviceWidth(context),
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: deviceWidth(context,0.6),
            padding: EdgeInsets.only(left: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hedingtext,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: fontFamilyText,
                    color: colorPrimaryColor,
                    fontWeight: fontWeight700,
                    overflow: TextOverflow.ellipsis
                ),),
                Text(lebletext,
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: fontFamilyText,
                      color: colorPrimaryColor,
                      fontWeight: fontWeight400,
                      overflow: TextOverflow.ellipsis
                  ),)
              ],
            ),
          ),
          Container(
            width: deviceWidth(context,0.3),
            child: Image.asset(image),
          ),
        ],
      ),
    );
  }
}
