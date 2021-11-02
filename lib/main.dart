import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jimpitan/view/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'jimpitan',
      home: SplashScreen()));
}
