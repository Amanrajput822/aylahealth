
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Bottom_NavBar_Provider extends ChangeNotifier {

  /// navigation controller //
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  PersistentTabController? get controller => _controller;

  void setcontrollervalue(value) {
    _controller.index = value;
    notifyListeners();
  }

}