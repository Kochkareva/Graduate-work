import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

import 'package:modile_app/models/training_model.dart';
import '../constants/api_constants.dart';
import '../constants/fitness_api_constants.dart';

class TrainingService{

  Future<TrainingModel?> getTraining(String slugPlan, String slugTraining) async{
    try{
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${FitnessApiConstants.getPlans}$slugPlan/$slugTraining'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
}