import 'dart:convert';
import 'dart:developer' as dev;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modile_app/contracts/service_contracts/abstract_user_service.dart';
import 'package:modile_app/models/jwt_token_model.dart';
import 'package:modile_app/models/survey_model.dart';
import 'package:modile_app/models/user_model.dart';
import 'package:modile_app/constants/api_constants.dart';
import 'package:hive/hive.dart';

import '../constants/user_api_constants.dart';
import '../storages/jwt_token_storage.dart';

class UserService implements AbstractUserService {

  /// Хранилище с данными о JWT-токене пользователя.
  List<JwtTokenModel> jwtTokenModel = Hive
      .box<JwtTokenModel>('jwt_token_model')
      .values
      .toList();

  /// Метод регистрации пользователя в системе.
  ///
  /// [userModel] - модель с данными о  пользователе.
  @override
  Future<int?> registerUser(UserModel userModel) async {
    try {
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${UserApiConstants.registerUser}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'email': userModel.email,
          'username': userModel.userName,
          'password': userModel.password,
          're_password': userModel.rePassword,
          'date_of_birth': DateFormat('dd.MM.yyyy').format(
              userModel.dateOfBirth),
          'gender': userModel.gender,
          'race': userModel.race.name
        }),
      );
      if (response.statusCode.toString().startsWith('2')) {
        int uid = jsonDecode(response.body)['uid'];
        return uid;
      } else if (response.statusCode.toString().startsWith('4')) {
        dev.log('Ошибка при регистрации пользователя: ${utf8.decode(response.bodyBytes)}');
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Ошибка при регистрации пользователя: ${e.toString()}');
      rethrow;
    }
    return null;
  }

  /// Метод активации пользователя в системе.
  ///
  /// [userModel] - модель с данными о  пользователе.
  /// [code] - код с почты пользователя.
  @override
  Future<void> activateUser(UserModel userModel, String code) async {
    try {
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${UserApiConstants
            .activateUser}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'uid': userModel.id.toString(),
          'code': code
        }),
      );
      if (response.statusCode.toString().startsWith('2')) {
        dev.log('Активация пользователя прошла успешно');
      } else if (response.statusCode.toString().startsWith('4')) {
        dev.log('Ошибка при активации пользователя: ${utf8.decode(response.bodyBytes)}');
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Ошибка при активации аккаунта пользователя: ${e.toString()}');
      rethrow;
    }
  }

  /// Метод авторизации пользователя в системе.
  ///
  /// [userModel] - модель с данными о  пользователе.
  @override
  Future<JwtTokenModel?> loginUser(String userName, String password) async {
    try {
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${UserApiConstants
            .loginUser}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': userName,
          'password': password
        }),
      );
      if (response.statusCode.toString().startsWith('2')) {
        JwtTokenModel jwtTokenModel = jwtTokenModelFromJson(response.body);
        addJwtToken(jwtTokenModel);
        return jwtTokenModel;
      } else if (response.statusCode.toString().startsWith('4')) {
        dev.log('Ошибка при авторизации пользователя: ${utf8.decode(response.bodyBytes)}');
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Ошибка при авторизации пользователя: ${e.toString()}');
      rethrow;
    }
    return null;
  }

  /// Метод для отправки данных опроса пользователя в систему.
  ///
  /// [surveyModel] - модель с данными об ответах пользователя на опрос.
  @override
  Future<void> surveyUser(SurveyModel surveyModel) async {
    try {
      var response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}${UserApiConstants
            .surveyUser}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${getJwtToken()?.access}',
        },
        body: jsonEncode(<String, String>{
          'is_using_data_agreed': surveyModel.isUsingDataAgreed.toString(),
          'height': surveyModel.height.toString(),
          'is_heart_diseased': surveyModel.isHeartDiseased.toString(),
          'is_diabetic': surveyModel.isDiabetic.toString(),
          'is_diabetic_with_diseases': surveyModel.isDiabeticWithDiseases
              .toString(),
          'diabetic_period': surveyModel.diabeticPeriod.toString(),
          'is_physical_activity': surveyModel.isPhysicalActivity.toString(),
          'is_kidney_diseased': surveyModel.isKidneyDiseased.toString(),
          'is_kidney_disease_chronic': surveyModel.isKidneyDiseaseChronic
              .toString(),
          'is_cholesterol': surveyModel.isCholesterol.toString(),
          'is_stroked': surveyModel.isStroked.toString(),
          'is_blood_pressure': surveyModel.isBloodPressure.toString(),
          'is_smoker': surveyModel.isSmoker.toString(),
          'is_alcoholic': surveyModel.isAlcoholic.toString(),
          'is_asthmatic': surveyModel.isAsthmatic.toString(),
          'is_skin_cancer': surveyModel.isSkinCancer.toString(),
          'weight': surveyModel.weight.toString(),
          'physical_health': surveyModel.physicalHealth.toString(),
          'mental_health': surveyModel.mentalHealth.toString(),
          'is_difficult_to_walk': surveyModel.isDifficultToWalk.toString(),
          'general_health': surveyModel.generalHealth,
          'sleep_time': surveyModel.sleepTime.toString()
        }),
      );
      if (response.statusCode.toString().startsWith('2')) {
        dev.log('Опрос пользователя прошел успешно');
      } else if (response.statusCode.toString().startsWith('4')) {
        dev.log('Ошибка при опросе пользователя: ${utf8.decode(response.bodyBytes)}');
        throw (utf8.decode(response.bodyBytes));
      }
    } catch (e) {
      dev.log('Ошибка при опросе пользователя: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> refreshJwtToken() async {
    try {
      String? refresh = getJwtToken()?.refresh;
      if (refresh != null) {
        var response = await http.post(
          Uri.parse('${ApiConstants.baseUrl}${UserApiConstants
              .refreshJwtToken}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer ${getJwtToken()?.access}',
          },
          body: jsonEncode(<String, String>{
            'refresh': refresh.toString(),
          }),
        );
        if (response.statusCode.toString().startsWith('2')) {
          updateJwtToken(jsonDecode(response.body)['access']);
        } else if (response.statusCode.toString().startsWith('4')) {
          throw (utf8.decode(response.bodyBytes));
        }
      } else {
        throw ('Ошибка при обновлении jwt токена пользователя');
      }
    } catch (e) {
      dev.log('Ошибка при обновлении jwt токена пользователя: ${e.toString()}');
      rethrow;
    }
  }
}