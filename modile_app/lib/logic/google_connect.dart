import 'dart:developer';

import 'package:health/health.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleConnect {

  Future<bool> checkingPermission() async {
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
    // define the types to get
    var types = [
      HealthDataType.HEART_RATE,
      HealthDataType.STEPS,
    ];
    bool requested = await health.requestAuthorization(types);
    if(!requested){
      _connectGoogleFit().then((result) {
        return true;
      }).catchError((error) {
        log(error.toString());
        throw Exception('Ошибка при авторизации Google Аккаунта ${error.toString()}');
      });
    }else{
      return true;
    }
    return false;
  }

  Future<void> _connectGoogleFit() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [FitnessApi.fitnessActivityReadScope]);
    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) {
      // Пользователь не вошел в учетную запись Google
      throw Exception('Пожалуйста, зайдите в учетную запись Google');
    } else {
      print('Пользователь успешно вошел в учетную запись Google, получаем данные из Google Fit API');
      var authHeaders = await account.authHeaders;
      var client = http.Client();
      var fitnessApi = FitnessApi(client);
    }
  }

  Future<int> getHeartRate() async {
    checkingPermission().then((result) async {
      HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
      var types = [
        HealthDataType.HEART_RATE,
      ];
      var now = DateTime.now();
      // fetch health data from the last 24 hours
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
          now.subtract(const Duration(days: 1)), now, types);
      types = [ HealthDataType.HEART_RATE];

      var midnight = DateTime(now.year, now.month, now.day);

      List<HealthDataPoint> heartRateData = [];
      try {
        heartRateData = await health.getHealthDataFromTypes(midnight, now, [HealthDataType.HEART_RATE]);
        for (HealthDataPoint dataPoint in heartRateData) {
          print('Heart Rate: ${dataPoint.value}');
        }
        return heartRateData.last;
      } catch (e) {
        throw Exception('Ошибка при получении данных о пульсе: $e');
      }
    }).catchError((error) {
      log(error.toString());
      throw Exception('Ошибка при авторизации Google Аккаунта ${error.toString()}');
    });
    return 0;
  }

}