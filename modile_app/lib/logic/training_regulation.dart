
import 'dart:developer';

import 'package:modile_app/logic/regulator.dart';
import 'package:modile_app/logic/google_connect.dart';

import '../storages/jwt_token_storage.dart';

class TrainingRegulation {

  /// Группа риска (Х)
  double riskGroup;

  /// Критическая точка контроля (КТК)
  // double pointControl;

  /// Монитор тренировки (А)
  // double workoutMonitor;

  /// Тренировочный корректировщик риска (ТКР)
  // double riskCorrector;

  // /// Тренировочная группа риска
  // double trainingGroupRisk;

  /// Максимальная ЧСС
  // int maxHeartRate;


  TrainingRegulation({
    required this.riskGroup,
    // required this.pointControl,
    // required this.workoutMonitor,
    // required this.riskCorrector,
    // required this.trainingGroupRisk,
    // required this.maxHeartRate
  });

  double mapValue(double value, double minEx, double maxEx, double minReq,
      double maxReq) {
    return ((value - minEx) / (maxEx - minEx)) * (maxReq - minReq) + minReq;
  }

  /// Регулирование тренировки
  Regulator regulator(Regulator currentRegulator) {
    double pointControl = (1 - riskGroup) * 250;
    List<double> rangeIntensity = [0.5, 0.9];
    currentRegulator.workoutMonitor += 100 * riskGroup;
    if (currentRegulator.workoutMonitor < pointControl) {
      currentRegulator.restTime = currentRegulator.workoutMonitor.toInt();
      currentRegulator.intensity = (currentRegulator.intensity * mapValue(
          (100 - currentRegulator.workoutMonitor), 1, 100, rangeIntensity[0],
          rangeIntensity[1]));
      return Regulator(restTime: currentRegulator.restTime,
          intensity: currentRegulator.intensity,
          workoutMonitor: currentRegulator.workoutMonitor);
    } else {
      return Regulator(restTime: 0, intensity: 0, workoutMonitor: 0);
    }
  }

  bool checkHeartRate(int trainingHeartRate) {
    GoogleConnect().getHeartRate().then((result) {
      if (result > trainingHeartRate) {
        return true;
      } else {
        return false;
      }
    }).catchError((error) {
      log(error.toString());
      throw Exception(
          'Ошибка при вычислении тренировочной ЧСС: ${error.toString()}');
    });
    return true;
  }

  Future<double> getHeartRate() async {
    double heartRate = 0.0;
    try {
      double result = await GoogleConnect().getHeartRate();
      heartRate = result;
      return heartRate;
    } catch (error) {
      log(error.toString());
      throw Exception('Ошибка при вычислении тренировочной ЧСС: ${error.toString()}');
    }
  }

  Future<int> getTrainingHeartRate() async {
    try {
      var middleHeartRate = await GoogleConnect().getHeartRate();
      DateTime userDateOfBirth = getDateOfBirth()!;
      DateTime now = DateTime.now();
      Duration difference = now.difference(userDateOfBirth);
      int ageUser = (difference.inDays ~/ 365.25).toInt();
      int maxHeartRate = 220 - ageUser;
      int trainingHeartRate = (middleHeartRate + ((maxHeartRate - middleHeartRate) * ( riskGroup * 100)) / 100).toInt();
      return trainingHeartRate;
    } catch (error) {
      log('Ошибка при вычислении тренировочной ЧСС: $error');
      throw Exception('Ошибка при вычислении тренировочной ЧСС: $error');
    }
  }
}