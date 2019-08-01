// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  String result;

  Welcome({
    this.result,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => new Welcome(
    result: json["result"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
  };
}