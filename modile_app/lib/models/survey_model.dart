
class SurveyModel {
  bool isUsingDataAgreed;
  int height;
  bool? isHeartDiseased;
  bool? isDiabetic;
  bool? isDiabeticWithDiseases;
  int? diabeticPeriod;
  bool isPhysicalActivity;
  bool? isKidneyDiseased;
  bool? isKidneyDiseaseChronic;
  bool? isCholesterol;
  bool? isStroked;
  bool? isBloodPressure;
  bool isSmoker;
  bool isAlcoholic;
  bool isAsthmatic;
  bool isSkinCancer;
  double weight;
  int physicalHealth;
  int mentalHealth;
  bool isDifficultToWalk;
  String generalHealth;
  int sleepTime;

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