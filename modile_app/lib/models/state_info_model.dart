
class StateInfoModel {

  int id;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  int isHeartDiseased;
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
    required this.userId,
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
}