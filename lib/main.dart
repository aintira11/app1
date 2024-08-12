import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
  //     theme: ThemeData(
  //   scaffoldBackgroundColor: Colors.black, // ตั้งค่าพื้นหลังสีดำ
  //   brightness: Brightness.dark, // ตั้งค่าเป็นธีมโทนมืด
  // ),
      // theme: ThemeData.dark(),  ใส่แค่นี้ก็ได้
      title: 'Flutter Demo', 
      home: LoginPage(),
    );
  }
}
