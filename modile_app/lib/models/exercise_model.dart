
import 'dart:convert';

/// Преобразует json-строку [str] в список [ExerciseModel] объектов.
List<ExerciseModel> listExerciseModelFromJson(String str) {
  List<Map<String, dynamic>> jsonList = List<Map<String, dynamic>>.from(json.decode(str));
  return jsonList.map((x) => ExerciseModel.fromJson(x)).toList();
}

/// Модель для представления информации об упражнении.
class ExerciseModel {
  /// Уникальный идентификатор.
  String slug;

  /// Название.
  String name;

  /// Описание.
  String description;

  /// Длительность выполнения.
  int? time;

  /// Количество выполнений.
  int? amount;

  /// Время отдыха.
  int restTime;

  /// Адрес изображения.
  String picture;

  /// Конструктор класса [ExerciseModel].
  ExerciseModel({
    required this.slug,
    required this.name,
    required this.description,
    required this.time,
    required this.amount,
    required this.restTime,
    required this.picture
  });

  /// Фабричный метод для создания экземпляра [ExerciseModel] из JSON-данных.
  factory ExerciseModel.fromJson(Map<String, dynamic> json) =>
      ExerciseModel(
          slug: json['slug'],
          name: utf8.decode(json['name']
              .toString()
              .codeUnits),
          description: utf8.decode(json['description']
              .toString()
              .codeUnits),
          time: json['time'] as int?,
          amount: json['amount'] as int?,
          restTime: json['rest_time'] as int,
          picture: json['picture']
      );

  @override
  bool operator ==(Object other) {
    return (other is ExerciseModel) && other.slug == slug && utf8.decode(other.name.replaceAll(RegExp(r'[^\d,]'), '')
        .split(',')
        .where((element) => element.isNotEmpty)
        .map((code) => int.parse(code))
        .toList()) == name &&
        utf8.decode(other.description.replaceAll(RegExp(r'[^\d,]'), '')
        .split(',')
        .where((element) => element.isNotEmpty)
        .map((code) => int.parse(code))
        .toList()) == description && other.time == time && other.amount == amount &&
        other.restTime == restTime && other.picture == picture;
  }
}