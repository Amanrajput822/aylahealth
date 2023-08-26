
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'myapp.dart';


void main() {

  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  runApp(const MyApp(),);
}



