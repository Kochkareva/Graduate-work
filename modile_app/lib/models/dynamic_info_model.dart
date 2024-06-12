import 'dart:convert';
import 'package:intl/intl.dart';

/// Метод для преобразования JSON-строки в объект [DynamicInfoModel].
///
/// [str] - входная строка
DynamicInfoModel dynamicInfoModelFromJson(String str) {
  Map<String, dynamic> jsonMap = json.decode(str);
  return DynamicInfoModel.fromJson(jsonMap);
}

List<DynamicInfoModel> dynamicInfoModelListFromJson(String str) {
  List<dynamic> data = jsonDecode(str);
  List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(data);
  return dataList.map((x) => DynamicInfoModel.fromJson(x)).toList();
}

/// Модель для представления данных динамической информации пользователя.
class DynamicInfoModel {
  /// Уникальный идентификатор.
  int id;

  /// Дата создания.
  DateTime createdAt;

  /// Группа риска пользователя.
  double riskGroupKp;

  /// Вес.
  double weight;

  /// Длительность физических недомоганий за последний месяц в днях.
  int physicalHealth;

  /// Длительность ментальных недомоганий за последний месяц в днях.
  int mentalHealth;

  /// Наличие трудностей при ходьбе.
  bool isDifficultToWalk;

  /// Наличие регулярного повышенного кровяного давления.
  bool isBloodPressure;

  /// Оценка своего здоровья пользователем.
  String generalHealth;

  /// Обычная длительность сна в часах.
  int sleepTime;

  /// Конструктор класса [DynamicInfoModel].
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

  /// Фабричный метод для создания экземпляра [DynamicInfoModel] из JSON-данных.
  factory DynamicInfoModel.fromJson(Map<String, dynamic> json) =>
      DynamicInfoModel(
          id: json['id'] as int,
          weight: json['weight'].toDouble(),
          physicalHealth: json['physical_health'] as int,
          mentalHealth: json['mental_health'] as int,
          sleepTime: json['sleep_time'] as int,
          createdAt: DateFormat("dd.MM.yyyy").parse(json['created_at']),
          riskGroupKp: json['risk_group_kp'].toDouble(),
          isDifficultToWalk: json['is_difficult_to_walk'] != null ? json['is_difficult_to_walk'] as bool : false,
          isBloodPressure: json['is_blood_pressure'] != null ? json['is_blood_pressure'] as bool : false,
          generalHealth: json['general_health']
      );

  @override
  bool operator ==(Object other) {
    return (other is DynamicInfoModel) && other.id == id && other.createdAt == createdAt &&
        other.riskGroupKp == riskGroupKp && other.weight == weight && other.physicalHealth == physicalHealth &&
        other.mentalHealth == mentalHealth && other.isDifficultToWalk == isDifficultToWalk &&
        other.isBloodPressure == isBloodPressure && other.generalHealth == generalHealth &&
        other.sleepTime == sleepTime;
  }
}