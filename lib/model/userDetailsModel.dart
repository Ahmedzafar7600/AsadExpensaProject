// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

UserDetailsModel userFromJson(String str) => UserDetailsModel.fromJson(json.decode(str));

String userToJson(UserDetailsModel data) => json.encode(data.toJson());

class UserDetailsModel {
  int id;
  String name;
  String surname;
  BigInt phone;
  String email;
  String system;
  int state;
  String api_token;
  int company_id;
  int property_id;
  int typecontact_id;
  String created_at;
  String updated_at;

  UserDetailsModel({
    this.id,
    this.name,
    this.surname,
    this.phone,
    this.email,
    this.system,
    this.state,
    this.api_token,
    this.company_id,
    this.property_id,
    this.typecontact_id,
    this.created_at,
    this.updated_at,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => new UserDetailsModel(
    id: json["result"]["id"],
    name: json["result"]["nombre"],
    surname: json["result"]["apellido"],
    phone: BigInt.from(json["result"]["nro_movil"]),
    email: json["result"]["email"],
    system: json["result"]["sistema"],
    state: json["result"]["estado"],
    api_token: json["result"]["api_token"],
    company_id: json["result"]["company_id"],
    property_id: json["result"]["property_id"],
    typecontact_id: json["result"]["typecontact_id"],
    created_at: json["result"]["created_at"],
    updated_at: json["result"]["updated_at"]

  );

  Map<String, dynamic> toJson() => {
    "result": {
      "id":id,
      "nombre":name,
      "apellido":surname,
      "nro_movil":phone,
      "email":email,
      "sistema":system,
      "estado":state,
      "api_token":api_token,
      "company_id":company_id,
      "property_id":property_id,
      "typecontact_id":typecontact_id,
      "created_at":created_at,
      "updated_at":updated_at,
    }
  };
}