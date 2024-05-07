class UserApiConstants{
  /// EndPoint для регистрации пользователя.
  static const String registerUser = 'auth/users/';

  /// EndPoint для активации пользователя.
  static const String activateUser = 'auth/users/activation/';

  /// EndPoint для авторизации пользователя.
  static const String loginUser = 'auth/jwt/create/';

  /// EndPoint для отправки данных опроса пользователя.
  static const String surveyUser = 'health/survey/';

  /// EndPoint для обновления токена пользователя.
  static const String refreshJwtToken = 'auth/jwt/refresh/';
}