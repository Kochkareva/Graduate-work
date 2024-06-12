import 'package:modile_app/contracts/enums/race_enum.dart';

/// Модель для представления данных пользователя.
class UserModel {

  /// Уникальный идентификатор пользователя.
  int? id;
  /// Электронная почта пользователя.
  String email;
  /// Имя пользователя.
  String userName;
  /// Пароль пользователя.
  String password;
  /// Повторный ввод пароля пользователя для подтверждения.
  String rePassword;
  /// Дата рождения пользователя.
  DateTime dateOfBirth;
  /// Пол пользователя.
  String gender;
  /// Раса пользователя.
  Race race;

  /// Конструктор класса [UserModel].
  UserModel(this.id, {
    required this.email,
    required this.userName,
    required this.password,
    required this.rePassword,
    required this.dateOfBirth,
    required this.gender,
    required this.race
  });
}