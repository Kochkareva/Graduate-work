import 'dart:convert';

import 'package:modile_app/api_service/user_service.dart';
import 'package:modile_app/constants/api_constants.dart';
import 'package:modile_app/models/dynamic_info_model.dart';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;

import '../constants/health_api_constants.dart';
import '../storages/jwt_token_storage.dart';

class DynamicInfoService{

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
      dev.log('Не удалось получить данные: ${e.toString()}');
      rethrow;
    }
    return null;
  }
}