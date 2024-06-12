import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:modile_app/constants/api_constants.dart';
import 'package:modile_app/constants/fitness_api_constants.dart';
import 'package:modile_app/constants/health_api_constants.dart';
import 'package:modile_app/constants/user_api_constants.dart';
import 'package:modile_app/logic/google_connect.dart';

Map<String, String> credentials = { 'username' : 'test', 'password':'test'};

Future<Map<String, dynamic>> login(String userName, String password) async {
  var response = await http.post(
    Uri.parse('${ApiConstants.baseUrl}${UserApiConstants.loginUser}'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'username': userName,
      'password': password
    }),
  );
  return json.decode(response.body);
}

void main() {
  group('Health tests', () {
    late String accessToken;

    setUp(() async {
      var response = await login(
          credentials['username']!, credentials['password']!);
      accessToken = response['access'];
    });

    test('Test Pass Survey', () async {
      var data = {
        "is_using_data_agreed": false,
        "height": 177,
        "is_heart_diseased": false,
        "is_diabetic": true,
        "is_diabetic_with_diseases": true,
        "diabetic_period": 0,
        "is_physical_activity": false,
        "is_kidney_diseased": false,
        "is_kidney_disease_chronic": false,
        "is_cholesterol": false,
        "is_stroked": false,
        "is_blood_pressure": false,
        "is_smoker": false,
        "is_alcoholic": false,
        "is_asthmatic": false,
        "is_skin_cancer": false,
        "weight": 75,
        "physical_health": 2,
        "mental_health": 15,
        "is_difficult_to_walk": false,
        "general_health": "Very good",
        "sleep_time": 8
      };
      var response = await http.post(
          Uri.parse('${ApiConstants.baseUrl}${UserApiConstants.surveyUser}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $accessToken',
          },
          body: jsonEncode(data));

      expect(response.statusCode, 200);
    });

    test('Test Get Dynamic Info', () async {
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${HealthApiConstants.getDynamicInfoLatest}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      expect(response.statusCode, 200);
    });
  });

  group('Fitness tests', () {

    late String accessToken;

    String slugPlan = 'traininarium-podgotovitelnyij-plan-na-vsyo-telo-uproschyonnyij-i';

    setUp(() async {
      var response = await login(
          credentials['username']!, credentials['password']!);
      accessToken = response['access'];
    });

    test('Test get plans', () async {
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants.getPlans}'),
      );
      expect(response.statusCode, 200);
    });

    test('Test get plan', () async{
      String slugPlan = 'traininarium-podgotovitelnyij-plan-na-vsyo-telo-i';
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants.getPlans}$slugPlan/'),
      );
      expect(response.statusCode, 200);
    });

    test('Test follow plan', () async{
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants
            .getPlans}$slugPlan${FitnessApiConstants.followPlan}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      expect(response.statusCode, 204);
    });

    test('Test training performance', () async{
      var data = {
        "training_slug": "$slugPlan-training-1",
        "pulse": [12.1, 14,4, 12,2],
        "mid_fatigue": false,
        "short_breath": false,
        "heart_ace": false,
        "training_risk_g": 0.23
      };
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants
            .training}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(data),
      );
      expect(response.statusCode, 201);
    });

    test('Test stop follow plan', () async{
      var response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants
            .getPlans}$slugPlan${FitnessApiConstants.followPlan}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );
      expect(response.statusCode, 204);
    });

  });
}