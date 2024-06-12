import 'dart:convert';

import 'package:intl/intl.dart';

/// Преобразует json-строку [str] в список [TrainingPerformanceModel] объектов.
List<TrainingPerformanceModel> trainingPerformanceModelFromJson(String str) {
  List<dynamic> data = jsonDecode(str);
  List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(data);
  return dataList.map((x) => TrainingPerformanceModel.fromJson(x)).toList();
}

/// Модель для представления информации о тренировке и физическом состоянии.
class TrainingPerformanceModel {

  /// Уникальный идентификатор тренировки.
  String slug;
  /// Список значений пульса во время тренировки.
  List<double> pulse;
  /// Флаг для обозначения наличия усталости.
  bool midFatigue;
  /// Флаг для обозначения наличия одышки.
  bool shortBreath;
  /// Флаг для обозначения наличия учащенного сердцебиения.
  bool heartAce;
  /// Тренировочная группа риска, полученная после выполнения тренировки.
  double trainingRiskG;

  DateTime createdAt;

  /// Конструктор класса [TrainingPerformanceModel].
  TrainingPerformanceModel({
    required this.slug,
    required this.pulse,
    required this.midFatigue,
    required this.shortBreath,
    required this.heartAce,
    required this.trainingRiskG,
    required this.createdAt
  });

  /// Фабричный метод для создания экземпляра [TrainingPerformanceModel] из JSON-данных.
  factory TrainingPerformanceModel.fromJson(Map<String, dynamic> json) =>
      TrainingPerformanceModel(
          slug: json['slug'],
          pulse: (json['pulse'] as List<dynamic>).map((e) => e.toDouble() as double).toList(),
          midFatigue: json['mid_fatigue'] as bool,
          shortBreath: json['short_breath'] as bool,
          heartAce: json['heart_ace'] as bool,
          trainingRiskG: json['training_risk_g'] as double,
          createdAt: DateFormat('dd.MM.yyyy HH:mm:ss').parse(json['created_at'] as String)
      );

  @override
  bool operator ==(Object other) {
    TrainingPerformanceModel? training = other as TrainingPerformanceModel?;
    if (training?.pulse.length != pulse.length) return false;
    for (int i = 0; i < training!.pulse.length; i++) {
      if (training.pulse[i] != pulse[i]) {
        return false;
      }
    }
    return (other is TrainingPerformanceModel) && other.slug == slug &&
        other.midFatigue == midFatigue
        && other.shortBreath == shortBreath
        && other.heartAce == heartAce
        && other.trainingRiskG == trainingRiskG;
  }
}