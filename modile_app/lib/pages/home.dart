import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:googleapis/fitness/v1.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:health/health.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothScreen(),
    );
  }
}

class BluetoothScreen extends StatefulWidget {
  @override
  _BluetoothScreenState createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

    // define the types to get
    var types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
    ];

    bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();

    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(Duration(days: 1)), now, types);

    // request permissions to write steps and blood glucose
    types = [HealthDataType.STEPS, HealthDataType.HEART_RATE];
    var permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE
    ];
    await health.requestAuthorization(types, permissions: permissions);

    // write steps and blood glucose
    // bool success = await health.writeHealthData(
    //     10, HealthDataType.STEPS, now, now);
    // success = await health.writeHealthData(
    //     3.1, HealthDataType.BLOOD_GLUCOSE, now, now);

    // get the number of steps for today
    var midnight = DateTime(now.year, now.month, now.day);
    int? steps = await health.getTotalStepsInInterval(midnight, now);
    print('Количество шагов: $steps');
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


  void _startBluetoothScan() {
    _connectGoogleFit();
  }

  void _connectGoogleFit() async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [FitnessApi.fitnessActivityReadScope]);

    GoogleSignInAccount? account = await googleSignIn.signIn();
    if (account == null) {
      // Пользователь не вошел в учетную запись Google
      print('Пользователь не вошел в учетную запись Google');
    } else {
      // Пользователь успешно вошел в учетную запись Google, получаем данные из Google Fit API
      print('Пользователь успешно вошел в учетную запись Google, получаем данные из Google Fit API');
      var authHeaders = await account.authHeaders;
      var client = http.Client();
      var fitnessApi = FitnessApi(client);

      // Здесь вы можете использовать методы Fitness API для получения данных из Google Fit
    }
  }

  void requestBluetoothScanPermission() async {
    var status = await Permission.bluetoothScan.status;
    print('Статус разрешения на сканирование Bluetooth: $status');

    if (!status.isGranted) {
      print('Запрос разрешения на сканирование Bluetooth...');
      await Permission.bluetoothScan.request();
      print('Разрешение на сканирование Bluetooth запрошено');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Connection'),
      ),
      body: const Center(
        child: Text('Searching for Xiaomi Mi Band 2...'),
      ),
    );
  }
}