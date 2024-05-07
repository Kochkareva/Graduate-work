
class UserTrainingModel {

  int userId;
  int trainingId;
  DateTime date;
  int pulse;
  int riskKp;

  UserTrainingModel({
    required this.userId,
    required this.trainingId,
    required this.date,
    required this.pulse,
    required this.riskKp,
  });
}