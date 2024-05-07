import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:modile_app/contracts/enums/intensity_enum.dart';

List<PlanModel> listRecommendedPlanModelFromJson(String str) {
  Map<String, dynamic> data = jsonDecode(str);
  List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(data['recommended']);
  return results.map((x) => PlanModel.fromJsonForList(x)).toList();
}

List<PlanModel> listFollowedPlanModelFromJson(String str) {
  Map<String, dynamic> data = jsonDecode(str);
  List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(data['following']);
  return results.map((x) => PlanModel.fromJsonForList(x)).toList();
}

PlanModel planModelFromJson(String str) {
  Map<String, dynamic> jsonMap = json.decode(str);
  return PlanModel.fromJsonForObject(jsonMap);
}

class PlanModel {

  String slug;
  // DateTime createdAt;
  String name;
  String picture;
  Intensity intensity;
  int healthGroup;
  int trainingAmount;
  bool isFilled;
  String equipment;
  bool iFollow;

  PlanModel({
    required this.slug,
    // required this.createdAt,
    required this.name,
    required this.picture,
    required this.intensity,
    required this.healthGroup,
    required this.trainingAmount,
    required this.isFilled,
    required this.equipment,
    required this.iFollow,
  });

  factory PlanModel.fromJsonForList(Map<String, dynamic> json) =>
      PlanModel(
          slug: json['slug'],
          // createdAt: DateFormat("dd.MM.yyyy").parse(json['created_at']),
          name: utf8.decode(json['name'].toString().codeUnits),
          intensity: intensityFromString(json['intensity']),
          picture: json['picture'],
          healthGroup: json['health_group'] as int,
          trainingAmount: json['training_amount'] as int,
          isFilled: json['is_filled'] as bool,
          equipment: json['equipment'],
          iFollow: false
      );

  factory PlanModel.fromJsonForObject(Map<String, dynamic> json) =>
      PlanModel(
          slug: json['slug'],
          // createdAt: DateFormat("dd.MM.yyyy").parse(json['created_at']),
          name: utf8.decode(json['name'].toString().codeUnits),
          intensity: intensityFromString(json['intensity']),
          picture: json['picture'],
          healthGroup: json['health_group'] as int,
          trainingAmount: json['training_amount'] as int,
          isFilled: json['is_filled'] as bool,
          equipment: json['equipment'],
          iFollow: json['i_follow'] as bool
      );

  static Intensity intensityFromString(String str) {
    Intensity intensity;
    switch (str) {
      case 'Low':
        intensity = Intensity.Low;
        return intensity;
      case 'Medium':
        intensity = Intensity.Medium;
        return intensity;
      case 'High':
        intensity = Intensity.High;
        return intensity;
      default:
        intensity = Intensity.Low;
        return intensity;
    }
  }
}