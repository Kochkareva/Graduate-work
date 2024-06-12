import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modile_app/api_service/user_service.dart';
import 'dart:developer' as dev;

import 'package:modile_app/models/training_model.dart';
import '../constants/api_constants.dart';
import '../constants/fitness_api_constants.dart';
import '../models/training_performance_model.dart';
import '../storages/jwt_token_storage.dart';

class TrainingService{

  /// Метод получения тренировки в плане.
  /// Возвращает модель [TrainingModel] либо `null`.
  ///
  /// [slugPlan] - уникальный идентификатор плана.
  /// [slugTraining] - уникальный идентификатор тренировки.
  Future<TrainingModel?> getTraining(String slugPlan, String slugTraining) async{
    try{
      await UserService().refreshJwtToken();
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants.getPlans}$slugPlan/$slugTraining'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
      );
      if (response.statusCode.toString().startsWith('2')) {
        TrainingModel trainingModel = trainingModelFromJson(response.body);
        return trainingModel;
      } else if (response.statusCode.toString().startsWith('4')) {
        throw (utf8.decode(response.bodyBytes));
      }
    }catch(e){
      dev.log('Не удалось получить данные: ${e.toString()}');
      rethrow;
    }
    return null;
  }

  /// Метод получения пройденных тренировок пользователем в плане.
  /// Возвращает Список [TrainingPerformanceModel] либо `null`.
  ///
  /// [slugPlan] - уникальный идентификатор плана.
  Future<List<TrainingPerformanceModel>?> getTrainingPerformanceByPlan(String slugPlan) async{
    try{
      await UserService().refreshJwtToken();
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants.training}all/$slugPlan'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
      );
      if (response.statusCode.toString().startsWith('2')) {
        List<TrainingPerformanceModel> trainingPerformanceModel = trainingPerformanceModelFromJson(response.body);
        return trainingPerformanceModel;
      } else if (response.statusCode.toString().startsWith('4')) {
        throw (utf8.decode(response.bodyBytes));
      }
    }catch(e){
      dev.log('Не удалось получить данные о пройденных тренировках: ${e.toString()}');
      rethrow;
    }

    return null;
  }

  /// Метод запроса на выполнение тренировки пользователем.
  ///
  /// [trainingPerformance] - модель для представления информации о тренировке и физическом состоянии.
  Future<void> createTrainingPerformance(TrainingPerformanceModel trainingPerformance) async {
    try {
      await UserService().refreshJwtToken();
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants
            .training}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
        body: jsonEncode(<String, dynamic>{
          'training_slug': trainingPerformance.slug,
          'pulse': trainingPerformance.pulse,
          'mid_fatigue': trainingPerformance.midFatigue,
          'short_breath': trainingPerformance.shortBreath,
          'heart_ace': trainingPerformance.heartAce,
          'training_risk_g': trainingPerformance.trainingRiskG
        }),
      );
      if (response.statusCode.toString().startsWith('2')) {
        dev.log('Тренировка выполнена');
      } else if (response.statusCode.toString().startsWith('4')) {
        dev.log('Ошибка при создании выполненной тренировки: ${utf8.decode(response.bodyBytes)}');
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Ошибка при создании выполненной тренировки: ${e.toString()}');
      rethrow;
    }
  }
}