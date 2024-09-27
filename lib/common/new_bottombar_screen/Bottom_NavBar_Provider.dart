
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';

import '../../screens/subscription_screens/subscriptionProvider.dart';
import '../SharedPrefHelper.dart';

class Bottom_NavBar_Provider extends ChangeNotifier {

  /// navigation controller //
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  PersistentTabController? get controller => _controller;

  void setcontrollervalue(value,context) {
    print('setcontrollervalue');
    _controller.index = value;
    setStatus("Offline");
  //  notifyListeners();
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);

    subscriptionProvider.checkSubscriptionAPI(context,'LoginScreen');
  }

  int _unreadMessages = 0;
  int get unreadMessages => _unreadMessages;
  void unreadMessagesFunction(value) {
    print('setcontrollervalue: $value');
    _unreadMessages = value;
     notifyListeners();
  }

  bool _chatMessages = false;
  bool get chatMessages => _chatMessages;
  void chatMessagesFunction(value) {
    print('notification screen status: $value');
    _chatMessages = value;
  //  notifyListeners();
  }


  void setStatus(String status) async {
    try {
      // Get the document reference
      var docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(SharedPrefHelper.userId.toString());

      // Check if the document exists
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Update the document if it exists
        await docRef.update({
          "status": status,
        });
      } else {
        // Handle case where document doesn't exist (e.g., create the document)
        await docRef.set({
          "status": status,
        });
      }
    } catch (e) {
      print("Error updating status: $e");
      // You can show a Cupertino dialog here if needed
    }
  }


  bool _barHideScreen = true;
  bool get barHideScreen => _barHideScreen;
  void barHideScreenFunction(value) {
    print('bar hide screen function : $value');
    _barHideScreen = value;
     notifyListeners();
  }


  bool _applyScreen = false;
  bool get applyScreen => _applyScreen;
  void applyScreenFunction(value) {
    print('apply screen function : $value');
    _applyScreen = value;
    notifyListeners();
  }
}