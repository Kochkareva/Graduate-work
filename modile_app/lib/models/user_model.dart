import 'dart:convert';
import 'package:modile_app/contracts/enums/race_enum.dart';

class UserModel {

  int? id;
  String email;
  String userName;
  String password;
  String rePassword;
  DateTime dateOfBirth;
  String gender;
  Race race;

  /*
      "email": "rat_73dima@mail.ru",
    "username": "bobobule",
    "password": "qwerty-1234",
    "re_password": "qwerty-1234",
    "date_of_birth": "2002-06-24",
    "gender": "Male",
    "race": "European"
   */
  UserModel(this.id, {
    required this.email,
    required this.userName,
    required this.password,
    required this.rePassword,
    required this.dateOfBirth,
    required this.gender,
    required this.race
  });

/*
  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
      id: json['id'],
      name: json['name'],
      intensivity: json['intensivity'],
      maxTrainingPeriod: json['maxTrainingPeriod'],
      userId: json['userId']
  );*/
}