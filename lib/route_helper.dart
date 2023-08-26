

import 'package:aylahealth/splesh.dart';
import 'package:flutter/cupertino.dart';

class RouteHelper{
  static Map<String,WidgetBuilder> createRoutes(){

    return {
      Splesh.route:(_)=> const Splesh()
    };
  }
}