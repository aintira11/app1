import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/Internal%20Configuration.dart';
import 'package:flutter_application_1/models/request/customer_login_post_req.dart';
import 'package:flutter_application_1/models/request/customer_post_req.dart';

// import 'package:flutter_application_1/models/request/customer_login_post_req.dart';
import 'package:flutter_application_1/models/response/customer_login_post_res.dart';
import 'package:flutter_application_1/pages/login.dart';

import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String text = '';
  int num = 0;
  String phoneNo = '';
  TextEditingController nameNoCtl = TextEditingController();
  TextEditingController phoneNoCtl = TextEditingController();
  TextEditingController emailNoCtl = TextEditingController();
  TextEditingController passwordNoCtl = TextEditingController();
  TextEditingController AgpasswordNoCtl = TextEditingController();
  String url = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิกใหม่'),
      ),
      body: SingleChildScrollView(
        child: Column(
          //  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'ชื่อ-นามสกุล',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  child: TextField(
                    controller: nameNoCtl,
                    // onChanged: (value) {
                    //   log(value);
                    // },

                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                ),
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
                    'อีเมล์',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  child: TextField(
                    controller: emailNoCtl,
                    // onChanged: (value) {
                    //   log(value);
                    // },

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
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    'ยืนยันรหัสผ่าน',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10),
                  child: TextField(
                    controller: AgpasswordNoCtl,
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
                  FilledButton(
                      onPressed: register, child: const Text('สมัครสมาชิก')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('หากมีบัญชีอยู่แล้ว?'),
                  TextButton(
                      onPressed: login, child: const Text('เข้าสู่ระบบ')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register() {
    // log('this is register button');
    //  text = 'hello word ';
    // var data = CustomerLoginPostResponse();
    if (passwordNoCtl.text == AgpasswordNoCtl.text &&
        nameNoCtl.text.isNotEmpty &&
        phoneNoCtl.text.isNotEmpty &&
        emailNoCtl.text.isNotEmpty &&
        passwordNoCtl.text.isNotEmpty &&
        AgpasswordNoCtl.text.isNotEmpty) {
      CustomersRequest req = CustomersRequest(
          fullname: nameNoCtl.text,
          phone: phoneNoCtl.text,
          email: emailNoCtl.text,
          image: "",
          password: passwordNoCtl.text);

      http
          // .post(Uri.parse("$url/customers"),
          .post(Uri.parse("$API_ENDPOINT/customers"),
              // .post(Uri.parse("http://192.168.196.72:3000/customers/login"),
              headers: {"Content-Type": "application/json; charset=utf-8"},
              // body: jsonEncode(data))
              body: customersRequestToJson(req))
          .then(
        (value) {
          // var jsonRes = jsonDecode(value.body);
          // log(jsonRes['customer']['email']);
          log(value.body);

          Navigator.push(
              context,
              MaterialPageRoute(
                //Navigator.of(context).popUntil((route) => route.isFirst);
                builder: (context) => LoginPage(),
              ));

          CustomersRequest customersRequest =
              customersRequestFromJson(value.body);
          log(customersRequest.fullname);
          log(customersRequest.email);
        },
      ).catchError((error) {
        // log('Error $error');
      });
    }
  }

  void login() {
    Navigator.push(
        context,
        MaterialPageRoute(
          //Navigator.of(context).popUntil((route) => route.isFirst);
          builder: (context) => LoginPage(),
        ));
  }
}
