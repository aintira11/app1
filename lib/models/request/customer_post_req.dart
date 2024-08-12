// To parse this JSON data, do
//
//     final customersRequest = customersRequestFromJson(jsonString);

import 'dart:convert';

CustomersRequest customersRequestFromJson(String str) => CustomersRequest.fromJson(json.decode(str));

String customersRequestToJson(CustomersRequest data) => json.encode(data.toJson());

class CustomersRequest {
    String fullname;
    String phone;
    String email;
    String image;
    String password;

    CustomersRequest({
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
        required this.password,
    });

    factory CustomersRequest.fromJson(Map<String, dynamic> json) => CustomersRequest(
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
        "password": password,
    };
}
