import 'package:flutter/foundation.dart';

class PushNotificationNotifier with ChangeNotifier {
  int _messageCount = 0;

  int get messageCount => _messageCount;

  void incrementMessageCount() {
    _messageCount++;
    notifyListeners();
  }
}
