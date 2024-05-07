import 'dart:developer';
import 'package:hive/hive.dart';

import '../models/jwt_token_model.dart';

/// Доступ к хранилищу данных Hive типа JwtTokenModel.
final jwtTokenBox = Hive.box<JwtTokenModel>('jwt_token_model');

/// Добавление данных в хранилище
///
/// [models] - список с данными типа JwtTokenModel.
void addJwtToken(JwtTokenModel jwtToken) {
  try {
    jwtTokenBox.put(0, jwtToken);
    print('Добавление токена');
    print(jwtToken.username);
  } catch (e) {
    log('Ошибка при сохранении jwt токена в базу данных: ${e.toString()}');
  }
}

/// Обновление Jwt токена в хранилище
void updateJwtToken(String access){
  JwtTokenModel? jwtToken = jwtTokenBox.get(0);
  if(jwtToken != null) {
    jwtToken?.access = access;
    jwtTokenBox.put(0, jwtToken!);
  }else{
    throw Exception('Ошибка при обновлении токена в хранилище');
  }
}

/// Получение Jwt токена из хранилища
JwtTokenModel? getJwtToken(){
  try {
    JwtTokenModel? jwtToken = jwtTokenBox.get(0);
    return jwtToken;
  } catch (e) {
    log('Ошибка при получении jwt токена из базы данных: ${e.toString()}');
  }
}
