
import 'dart:developer';

import 'package:modile_app/logic/regulator.dart';
import 'package:modile_app/logic/google_connect.dart';

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

  double mapValue(double value, double minEx, double maxEx, double minReq, double maxReq) {
    return ((value - minEx) / (maxEx - minEx)) * (maxReq - minReq) + minReq;
  }

  /// Регулирование тренировки
  Regulator regulator(Regulator currentRegulator) {
    // А += 10 * КТР (если КТР = null, то X)
    // Регулятор: Время перерыва = 10 секунд * А И Снижение интенсивности на % = А
    double pointControl = (1-riskGroup)*250;
    List<double> rangeIntensity = [0.5, 0.9];
    print('pointControl');
    print(pointControl.toString());
    // currentRegulator.workoutMonitor += 10 * riskCorrector;
    currentRegulator.workoutMonitor += 100 * riskGroup;
    print('currentRegulator.workoutMonitor');
    print(currentRegulator.workoutMonitor.toString());
    if (currentRegulator.workoutMonitor < pointControl) {
      currentRegulator.restTime = currentRegulator.workoutMonitor.toInt();
      // currentRegulator.intensity = (currentRegulator.intensity * (1/currentRegulator.workoutMonitor)) * 10;
      currentRegulator.intensity = (currentRegulator.intensity * mapValue((100 - currentRegulator.workoutMonitor), 1, 100, rangeIntensity[0], rangeIntensity[1]));

      print('currentRegulator.restTime');
      print(currentRegulator.restTime.toString());
      print('currentRegulator.intensity');
      print(currentRegulator.intensity.toString());
      return Regulator(restTime: currentRegulator.restTime, intensity: currentRegulator.intensity, workoutMonitor: currentRegulator.workoutMonitor);
    } else {
      return Regulator(restTime: 0, intensity: 0, workoutMonitor: 0);
    }
  }

  int trainingHeartRate(int maxHeartRate, currentHeartRate) {
    int value;
    GoogleConnect().getHeartRate().then((result) {
      value = (result + ((maxHeartRate + result) * riskGroup) / 100).toInt();
      return value;
    }).catchError((error) {
      log(error.toString());
      throw Exception(
          'Ошибка при вычислении тренировочной ЧСС: ${error.toString()}');
    });
    return 0;
  }
}