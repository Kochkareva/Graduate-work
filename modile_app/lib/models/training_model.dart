import 'dart:convert';

import 'exercise_model.dart';

TrainingModel trainingModelFromJson(String str){
  Map<String, dynamic> jsonMap = json.decode(str);
  return TrainingModel.fromJson(jsonMap);
}

class TrainingModel {

  String name;
  int number;
  String slug;
  List<ExerciseModel> exercises;

  TrainingModel({
    required this.name,
    required this.number,
    required this.slug,
    required this.exercises,
  });

  factory TrainingModel.fromJson(Map<String, dynamic> json) =>
      TrainingModel(
          name: json['name'],
          number: json['number'] as int,
          slug: 'training-${json['number'] as int}',
          exercises: listExerciseModelFromJson(jsonEncode(json['exercises']))
      );
}