import 'dart:convert';

import 'package:modile_app/api_service/user_service.dart';
import 'package:modile_app/constants/api_constants.dart';
import 'package:modile_app/models/dynamic_info_model.dart';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

import '../constants/health_api_constants.dart';
import '../constants/user_api_constants.dart';
import '../storages/jwt_token_storage.dart';

class DynamicInfoService{

  /// Метод получения динамической информации пользователя.
  /// Возвращает модель [DynamicInfoModel] либо `null`.
  Future<DynamicInfoModel?> getDynamicInfo() async {
    try{
      await UserService().refreshJwtToken();
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${HealthApiConstants.getDynamicInfoLatest}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${getJwtToken()?.access}',
          },
      );
      if (response.statusCode.toString().startsWith('2')) {
        DynamicInfoModel dynamicInfoModels = dynamicInfoModelFromJson(response.body);
        return dynamicInfoModels;
      } else if (response.statusCode.toString().startsWith('4')) {
        throw (utf8.decode(response.bodyBytes));
      }
    }catch(e){
      dev.log('Не удалось получить данные о динамической информации пользователя: ${e.toString()}');
      rethrow;
    }
    return null;
  }

  Future<List<DynamicInfoModel>?> getDynamicInfoList() async {
    try{
      await UserService().refreshJwtToken();
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${HealthApiConstants.getDynamicInfoList}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
      );
      if (response.statusCode.toString().startsWith('2')) {
        List<DynamicInfoModel> dynamicInfoModels = dynamicInfoModelListFromJson(response.body);
        return dynamicInfoModels;
      } else if (response.statusCode.toString().startsWith('4')) {
        throw (utf8.decode(response.bodyBytes));
      }
    }catch(e){
      dev.log('Не удалось получить данные о всей динамической информации пользователя: ${e.toString()}');
      rethrow;
    }
    return null;
  }

  @override
  Future<void> createDynamicInfo(DynamicInfoModel dynamicInfoModel) async {
    try {
      await UserService().refreshJwtToken();
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${HealthApiConstants.createDynamicInfo}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
        body: jsonEncode(<String, String>{
            "weight": dynamicInfoModel.weight.toString(),
            "physical_health": dynamicInfoModel.physicalHealth.toString(),
            "mental_health": dynamicInfoModel.mentalHealth.toString(),
            "general_health": dynamicInfoModel.generalHealth.toString(),
            "sleep_time": dynamicInfoModel.sleepTime.toString()
        }),
      );
      if (response.statusCode.toString().startsWith('2')) {
        dev.log('Динамические данные пользователя успешно созданы');
      } else if (response.statusCode.toString().startsWith('4')) {
        dev.log('Ошибка при опросе пользователя: ${utf8.decode(response.bodyBytes)}');
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Ошибка при создании динамических данных пользователя: ${e.toString()}');
      rethrow;
    }
  }
}