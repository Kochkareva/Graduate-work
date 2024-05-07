import 'package:hive/hive.dart';
import 'dart:convert';
part 'jwt_token_model.g.dart';

/// Метод для преобразования JSON-строки в список объектов [JwtTokenModel].
///
/// [str] - входная строка
JwtTokenModel jwtTokenModelFromJson(String str) {
  Map<String, dynamic> jsonMap = json.decode(str);
  return JwtTokenModel.fromJson(jsonMap);
}

/// Модель данных JWT токена.
///
/// * [refresh] - refresh токен.
/// * [access] - access токен.
/// * [username] - имя пользователя.
@HiveType(typeId: 0)
class JwtTokenModel {
  @HiveField(0)
  String refresh;
  @HiveField(1)
  String access;
  @HiveField(2)
  String username;

  JwtTokenModel({
    required this.refresh,
    required this.access,
    required this.username
  });

  /// Метод для преобразования JSON в модель данных [JwtTokenModel].
  factory JwtTokenModel.fromJson(Map<String, dynamic> json) => JwtTokenModel(
    refresh: json['refresh'],
    access: json['access'],
    username:  utf8.decode(json['username'].toString().codeUnits)
  );

}