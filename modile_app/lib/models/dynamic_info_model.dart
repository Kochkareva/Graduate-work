
import 'dart:convert';

import 'package:intl/intl.dart';

DynamicInfoModel dynamicInfoModelFromJson(String str) {
  Map<String, dynamic> jsonMap = json.decode(str);
  return DynamicInfoModel.fromJson(jsonMap);
}

class DynamicInfoModel {
  int id;
  DateTime createdAt;
  double riskGroupKp;
  double weight;
  int physicalHealth;
  int mentalHealth;
  bool isDifficultToWalk;
  bool isBloodPressure;
  String generalHealth;
  int sleepTime;

  /*
    general_health = models.CharField(choices=HEALTH_CONDITIONS_MULTIPLE_CHOICE)
   */


  DynamicInfoModel({
    required this.id,
    required this.createdAt,
    required this.riskGroupKp,
    required this.weight,
    required this.physicalHealth,
    required this.mentalHealth,
    required this.isDifficultToWalk,
    required this.isBloodPressure,
    required this.generalHealth,
    required this.sleepTime,
  });

  /*
  {
  
    "general_health": "Very good"
}
   */

  factory DynamicInfoModel.fromJson(Map<String, dynamic> json) =>
      DynamicInfoModel(
          id: json['id'] as int,
          weight: json['weight'].toDouble(),
          physicalHealth: json['physical_health'] as int,
          mentalHealth: json['mental_health'] as int,
          sleepTime: json['sleep_time'] as int,
          createdAt: DateFormat("dd.MM.yyyy").parse(json['created_at']),
          riskGroupKp: json['risk_group_kp'].toDouble(),
          isDifficultToWalk: json['is_difficult_to_walk'] as bool,
          isBloodPressure: json['is_blood_pressure'] as bool,
          generalHealth: json['general_health']
      );
}