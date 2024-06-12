
import 'dart:convert';
import 'dart:developer';

import 'package:modile_app/api_service/user_service.dart';
import 'package:modile_app/models/state_info_model.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../constants/health_api_constants.dart';
import '../storages/jwt_token_storage.dart';

class StateInfoService{

  Future<StateInfoModel?> getStateInfo() async {
    try{
      await UserService().refreshJwtToken();
      var response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}${HealthApiConstants.updateStateInfo}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
      );
      if (response.statusCode.toString().startsWith('2')) {
        StateInfoModel stateInfoModel = stateInfoModelFromJson(response.body);
        return stateInfoModel;
      } else if (response.statusCode.toString().startsWith('4')) {
        throw (utf8.decode(response.bodyBytes));
      }
    }catch(e){
      log('Не удалось получить данные о динамической информации пользователя: ${e.toString()}');
      rethrow;
    }
    return null;
  }

  Future<void> updateDynamicInfo(StateInfoModel stateInfoModel) async {
    try {
      await UserService().refreshJwtToken();
      var response = await http.put(
        Uri.parse('${ApiConstants.baseUrl}${HealthApiConstants.updateStateInfo}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
        body: jsonEncode(<String, String>{
          "is_diabetic": stateInfoModel.isDiabetic.toString(),
          "is_diabetic_with_diseases": stateInfoModel.isDiabeticWithDiseases.toString(),
          "diabetic_period": stateInfoModel.diabeticPeriod.toString(),
          "height": stateInfoModel.height.toString()
        }),
      );
      if (response.statusCode.toString().startsWith('2')) {
        log('Статические данные пользователя успешно обновлены');
      } else if (response.statusCode.toString().startsWith('4')) {
        log('Ошибка при обновлении статических данных: ${utf8.decode(response.bodyBytes)}');
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      log('Ошибка при обновлении статических данных пользователя: ${e.toString()}');
      rethrow;
    }
  }
}