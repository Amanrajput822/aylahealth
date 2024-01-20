import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String text, receiverId, senderId;
  var created;

  Message(
      {required this.text,
      required this.created,
      required this.receiverId,
      required this.senderId});

 Map<String,dynamic> toMap (){
    return {
      "created":created,
      "text":text,
      "receiverId":receiverId,
      "senderId":senderId
    };
  }

  factory Message.fromJson(var json) {
    Timestamp timestamp;
    String receiverId;
    if(json["created"].runtimeType==Timestamp){
      timestamp=json["created"];
    }else{
      timestamp=Timestamp.now();
    }
    if(json["receiverId"].runtimeType==String||json["receiverId"].runtimeType==int){
      receiverId=json["receiverId"].toString();
    }else{
      receiverId="33";
    }
    return Message(
        text: json["text"],
        created: timestamp,
        receiverId: json["receiverId"].toString(),
        senderId: json["senderId"].toString());
  }
}
