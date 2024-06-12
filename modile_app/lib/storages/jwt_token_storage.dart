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

/// Получение Даты рождения пользователя из хранилища
DateTime? getDateOfBirth(){
  try {
    DateTime? dateOfBirth = jwtTokenBox.get(0)?.dateOfBirth;
    return dateOfBirth;
  } catch (e) {
    log('Ошибка при получении Даты рождения пользователя из базы данных: ${e.toString()}');
  }
}

String? getUserName(){
  try{
    String? username = jwtTokenBox.get(0)?.username;
    return username;
  }catch(e){
    log('Ошибка при получении имени пользователя из базы данных: ${e.toString()}');
  }
}
