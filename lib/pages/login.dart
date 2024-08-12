import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/Internal%20Configuration.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/models/request/customer_login_post_req.dart';
import 'package:flutter_application_1/models/response/customer_login_post_res.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  String text = '';
  int num = 0;
  String phoneNo = '';
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController passwordNoCtl = TextEditingController();

  String url = '';
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
     (config) {
	     url = config['apiEndpoint'];
      },
    ).catchError((err) {
      log(err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          //  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onDoubleTap: () {
                      log('Image Double Tap');
                    },
                    child: Image.asset('assets/images/logo.png')),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'หมายเลขโทรศัพท์',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  child: TextField(
                    controller: phoneNoCtl,
                    // onChanged: (value) {
                    //   log(value);
                    // },
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'รหัสผ่าน',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                  child: TextField(
                    controller: passwordNoCtl,
                    obscureText: true, // ซ่อนข้อความที่พิมพ์
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: register, child: const Text('ลงทะเบียนใหม่')),
                  FilledButton(
                      onPressed: login, child: const Text('เข้าสู่ระบบ')),
                ],
              ),
            ),
            Text(text)
          ],
        ),
      ),

      // 03-Widgets and Layout---------------------------------------------------------------------------------------------
      // body: SizedBox(
      //     width: MediaQuery.of(context).size.width,
      //     child: Container(
      //       color: Colors.amber,
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.spaceAround,
      //         children: [
      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               SizedBox(
      //                 width: 100,
      //                 height: 100,
      //                 child: Container(
      //                   color: Colors.blue,
      //                 ),
      //               ),
      //             ],
      //           ),

      //           Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [

      //               SizedBox(
      //                 width: 100,
      //                 height: 100,
      //                 child: Container(
      //                   color: Colors.purple,
      //                 ),
      //               ),
      //               Row(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.all(8.0),
      //                     child: SizedBox(
      //                       width: 100,
      //                       height: 100,
      //                       child: Container(
      //                         color: Colors.red,
      //                       ),
      //                     ),
      //                   ),
      //                    SizedBox(
      //                 width: 100,
      //                 height: 100,
      //                 child: Container(
      //                   color: Colors.green,
      //                 ),
      //               ),
      //                 ],
      //               ),

      //             ],
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
    );
  }

  void register() {
    // log('this is register button');
    //  text = 'hello word ';
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }

  void login() async{
    // log('this is login'); customer_login_post_res.dart
    // setState(() {
    //    num += 1 ;
    //    text = 'Login time : $num' ;
    //  });
    // log(passwordNoCtl.text);
    // log(phoneNoCtl.text);
    // if (phoneNoCtl.text == '0812345678' && passwordNoCtl.text == '1234') {
    // Navigator.push(context, MaterialPageRoute(builder: (context)=> const ShowTropPage()
    // )
    // );
    // }

    // var data = {"phone": phoneNoCtl.text, "password": passwordNoCtl.text};
    CustomerLoginPostRequest req = CustomerLoginPostRequest(
        phone: phoneNoCtl.text, password: passwordNoCtl.text);

    http
        //  .post(Uri.parse("$url/customers/login"),
        .post(Uri.parse("$API_ENDPOINT/customers/login"),
        // .post(Uri.parse("http://192.168.196.72:3000/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            // body: jsonEncode(data))
            body: customerLoginPostRequestToJson(req))
        .then(
      (value) {
        // var jsonRes = jsonDecode(value.body);
        // log(jsonRes['customer']['email']);
        log(value.body);
        CustomerLoginPostResponse customerLoginPostResponse =
            customerLoginPostResponseFromJson(value.body);
        log(customerLoginPostResponse.customer.fullname);
        log(customerLoginPostResponse.customer.email);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowTropPage(idx: customerLoginPostResponse.customer.idx,),
            ));
      },
    ).catchError((error) {
      log('Error $error');
    });
  }
}
