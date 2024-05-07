import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:health/health.dart';

class GoogleConnectLogic{

  // void requestBluetoothScanPermission() async {
  //   var status = await Permission.bluetoothScan.status;
  //   print('Статус разрешения на сканирование Bluetooth: $status');
  //
  //   if (!status.isGranted) {
  //     print('Запрос разрешения на сканирование Bluetooth...');
  //     await Permission.bluetoothScan.request();
  //     print('Разрешение на сканирование Bluetooth запрошено');
  //   }
  // }

  void getData() async {
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

    // define the types to get
    var types = [
      HealthDataType.HEART_RATE,
    ];

    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(Duration(days: 1)), now, types);

    // request permissions to write steps and blood glucose
    types = [ HealthDataType.HEART_RATE];
    var permissions = [
      HealthDataAccess.READ_WRITE,
    ];
    await health.requestAuthorization(types, permissions: permissions);

    var midnight = DateTime(now.year, now.month, now.day);

    List<HealthDataPoint> heartRateData = [];
    try {
      heartRateData = await health.getHealthDataFromTypes(midnight, now, [HealthDataType.HEART_RATE]);

      for (HealthDataPoint dataPoint in heartRateData) {
        // Обработка данных о пульсе
        print('Heart Rate: ${dataPoint.value}');
      }
    } catch (e) {
      print('Error fetching heart rate data: $e');
    }
  }


}