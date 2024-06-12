
import 'dart:convert';

import 'package:intl/intl.dart';

StateInfoModel stateInfoModelFromJson(String str) {
  Map<String, dynamic> jsonMap = json.decode(str);
  return StateInfoModel.fromJson(jsonMap);
}

class StateInfoModel {
  int id;
  DateTime createdAt;
  DateTime updatedAt;
  bool isHeartDiseased;
  bool isDiabetic;
  bool isDiabeticWithDiseases;
  int diabeticPeriod;
  bool isKidneyDiseased;
  bool isKidneyDiseaseChronic;
  bool isCholesterol;
  bool isStroked;
  int height;
  bool isPhysicalActivity;
  bool isSmoker;
  bool isAlcoholic;
  bool isAsthmatic;
  bool isSkinCancer;

  StateInfoModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.isHeartDiseased,
    required this.isDiabetic,
    required this.isDiabeticWithDiseases,
    required this.diabeticPeriod,
    required this.isKidneyDiseased,
    required this.isKidneyDiseaseChronic,
    required this.isCholesterol,
    required this.isStroked,
    required this.height,
    required this.isPhysicalActivity,
    required this.isSmoker,
    required this.isAlcoholic,
    required this.isAsthmatic,
    required this.isSkinCancer
  });

  factory StateInfoModel.fromJson(Map<String, dynamic> json) =>
      StateInfoModel(
          id: json['id'] as int,
          createdAt: DateFormat("dd.MM.yyyy").parse(json['created_at']),
          updatedAt: DateFormat("dd.MM.yyyy").parse(json['updated_at']),
          isHeartDiseased: json['is_heart_diseased'] as bool,
          isDiabetic: json['is_diabetic'] as bool,
          isDiabeticWithDiseases: json['is_diabetic_with_diseases'] as bool,
          diabeticPeriod: json['diabetic_period'] as int,
          isKidneyDiseased: json['is_kidney_diseased'] as bool,
          isKidneyDiseaseChronic: json['is_kidney_disease_chronic'] as bool,
          isCholesterol: json['is_cholesterol'] as bool,
          isStroked: json['is_stroked'] as bool,
          height: json['height'] as int,
          isPhysicalActivity: json['is_physical_activity'] as bool,
          isSmoker: json['is_smoker'] as bool,
          isAlcoholic: json['is_alcoholic'] as bool,
          isAsthmatic: json['is_asthmatic'] as bool,
          isSkinCancer: json['is_skin_cancer'] as bool
      );
}