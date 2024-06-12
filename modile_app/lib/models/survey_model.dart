
/// Модель для представления данных опроса пользователя.
class SurveyModel {

  /// Согласие на использование данных опроса для обучения модели НС.
  bool isUsingDataAgreed;
  /// Рост.
  int height;
  /// Наличие ССЗ.
  bool? isHeartDiseased;
  /// Наличие диабета.
  bool? isDiabetic;
  /// Наличие диабета с болезнями при наличии диабета.
  bool? isDiabeticWithDiseases;
  /// Продолжительность диабета при наличии диабета.
  int? diabeticPeriod;
  /// Наличие регулярной физической активности.
  bool isPhysicalActivity;
  /// Наличие заболевание почек.
  bool? isKidneyDiseased;
  /// Наличие хронического типа заболевания почек при их наличии.
  bool? isKidneyDiseaseChronic;
  /// Наличие повышенного холестерина.
  bool? isCholesterol;
  /// Наличие инсульта.
  bool? isStroked;
  /// Наличие регулярного повышенного кровяного давления.
  bool? isBloodPressure;
  /// Наличие зависимости от курения.
  bool isSmoker;
  /// Наличие регулярного употребления алкоголя.
  bool isAlcoholic;
  /// Наличие астмы.
  bool isAsthmatic;
  /// Наличие рака кожи.
  bool isSkinCancer;
  /// Вес.
  double weight;
  /// Длительность физических недомоганий за последний месяц в днях.
  int physicalHealth;
  /// Длительность ментальных недомоганий за последний месяц в днях.
  int mentalHealth;
  /// Наличие трудностей при ходьбе.
  bool isDifficultToWalk;
  /// Оценка своего здоровья пользователем.
  String generalHealth;
  /// Обычная длительность сна в часах.
  int sleepTime;

  /// Конструктор класса [SurveyModel].
  SurveyModel({
    required this.isUsingDataAgreed,
    required this.height,
    required this.isHeartDiseased,
    required this.isDiabetic,
    required this.isDiabeticWithDiseases,
    required this.diabeticPeriod,
    required this.isPhysicalActivity,
    required this.isKidneyDiseased,
    required this.isKidneyDiseaseChronic,
    required this.isCholesterol,
    required this.isStroked,
    required this.isBloodPressure,
    required this.isSmoker,
    required this.isAlcoholic,
    required this.isAsthmatic,
    required this.isSkinCancer,
    required this.weight,
    required this.physicalHealth,
    required this.mentalHealth,
    required this.isDifficultToWalk,
    required this.generalHealth,
    required this.sleepTime,
  });

}