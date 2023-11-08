import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../common/SharedPrefHelper.dart';
import 'model/MessageModel.dart';

class FirebaseData {
  FirebaseData._privateConstructor();

  static final FirebaseData instance = FirebaseData._privateConstructor();

  List<Message> messages = [];
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection("users");

  //Run When User Register On App
  void userRegister() async {
    var id = await SharedPrefHelper.userId;
    var name = await SharedPrefHelper.name;
    var email = await SharedPrefHelper.email;
    var profile = await SharedPrefHelper.profile;

    _userCollection.doc(SharedPrefHelper.userId.toString()).set({
      "id": id,
      "name": name,
      "email": email,
      "profile": profile,
      "created": FieldValue.serverTimestamp()
    });
    print(
        "shjbcxjscjusgcjubcghbjk${_userCollection}${id}${name}${email}${profile}");
  }

  //Run When User Login And Update Their Profile on app
  void userUpdate() async {
    var id = await SharedPrefHelper.userId;
    var name = await SharedPrefHelper.name;
    var email = await SharedPrefHelper.email;
    var profile = await SharedPrefHelper.profile;
    print("check udpated data here ${id}, ${name} ${email} ${profile}");
    _userCollection.doc(SharedPrefHelper.userId.toString()).update({
      "id": id,
      "name": name,
      "email": email,
      "profile": profile,
    });
    print("shjbcxjscjusgcjubcghbjk${_userCollection}${id}${name}${email}${profile}");
  }

  Future<void> sendMessage(Message message) async {

    await _userCollection
        .doc(SharedPrefHelper.userId.toString())
        .collection("messages")
        .doc()
        .set({
      "created": message.created,
      "text": message.text,
      "receiverId": message.receiverId,
      "senderId": message.senderId
    });
  }

  Future<void> userUpdateTime() async {
    var id = await SharedPrefHelper.userId;
    var name = await SharedPrefHelper.name;
    var email = await SharedPrefHelper.email;
    var profile = await SharedPrefHelper.profile;
    print("check udpated data here ${id}, ${name} ${email} ${profile}");
    _userCollection
        .doc(SharedPrefHelper.userId.toString())
        .update({"created": FieldValue.serverTimestamp()});
    print(
        "shjbcxjscjusgcjubcghbjk$_userCollection$id$name$email${profile}");
  }
}
