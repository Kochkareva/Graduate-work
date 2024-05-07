
import 'dart:convert';

List<ExerciseModel> listExerciseModelFromJson(String str) {
  List<Map<String, dynamic>> jsonList = List<Map<String, dynamic>>.from(json.decode(str));
  return jsonList.map((x) => ExerciseModel.fromJson(x)).toList();
}

class ExerciseModel {
  String slug;
  String name;
  String description;
  int? time;
  int? amount;
  int restTime;
  String picture;

  ExerciseModel({
    required this.slug,
    required this.name,
    required this.description,
    required this.time,
    required this.amount,
    required this.restTime,
    required this.picture
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      ExerciseModel(
          slug: json['slug'],
          name: utf8.decode(json['name'].toString().codeUnits),
          description: utf8.decode(json['description'].toString().codeUnits),
          time: json['time'] as int?,
          amount: json['amount'] as int?,
          restTime: json['rest_time'] as int,
          picture: json['picture']
      );
}