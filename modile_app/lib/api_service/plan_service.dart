import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:modile_app/api_service/user_service.dart';
import 'package:modile_app/constants/fitness_api_constants.dart';
import 'package:modile_app/models/plan_model.dart';
import 'package:modile_app/constants/api_constants.dart';

import '../storages/jwt_token_storage.dart';

class PlanService {

  Future<List<PlanModel>?> getRecommendedPlans() async {
    try {
      await UserService().refreshJwtToken();
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants.getPlans}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
      );
      if (response.statusCode.toString().startsWith('2')) {
        List<PlanModel> planModel = listRecommendedPlanModelFromJson(response.body);
        return planModel;
      } else if (response.statusCode.toString().startsWith('4')) {
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Не удалось получить данные: ${e.toString()}');
      rethrow;
    }
    return null;
  }

  /// Метод получения планов - отслеживаемыех пользователем
  Future<List<PlanModel>?> getFollowedPlans() async {
    try {
      await UserService().refreshJwtToken();
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants.getPlans}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
      );
      if (response.statusCode.toString().startsWith('2')) {
        List<PlanModel> planModel = listFollowedPlanModelFromJson(response.body);
        return planModel;
      } else if (response.statusCode.toString().startsWith('4')) {
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Не удалось получить данные: ${e.toString()}');
      rethrow;
    }
    return null;
  }

  Future<PlanModel?> getPlan(String slugPlan) async{
    try{
      await UserService().refreshJwtToken();
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants.getPlans}$slugPlan/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
      );
      if (response.statusCode.toString().startsWith('2')) {
        PlanModel planModel = planModelFromJson(response.body);
        return planModel;
      } else if (response.statusCode.toString().startsWith('4')) {
        throw (utf8.decode(response.bodyBytes));
      }
    }catch(e){
      dev.log('Не удалось получить данные: ${e.toString()}');
      rethrow;
    }
    return null;
  }

  Future<void> followPlan(String slugPlan) async {
    try {
      await UserService().refreshJwtToken();
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants
            .getPlans}$slugPlan${FitnessApiConstants.followPlan}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
      );
      if (response.statusCode.toString().startsWith('2')) {
        dev.log('Пользователь начал отслеживать план');
      } else if (response.statusCode.toString().startsWith('4')) {
        dev.log('Ошибка при запросе на отслеживание плана: ${utf8.decode(response.bodyBytes)}');
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Ошибка при запросе на отслеживание плана: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> stopFollowPlan(String slugPlan) async {
    try {
      await UserService().refreshJwtToken();
      var response = await http.delete(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants
            .getPlans}$slugPlan${FitnessApiConstants.followPlan}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
      );
      if (response.statusCode.toString().startsWith('2')) {
        dev.log('Пользователь прекратил отслеживать план');
      } else if (response.statusCode.toString().startsWith('4')) {
        dev.log('Ошибка при запросе на прекращение отслеживания плана: ${utf8.decode(response.bodyBytes)}');
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Ошибка при запросе на прекращение отслеживания плана: ${e.toString()}');
      rethrow;
    }
  }
}