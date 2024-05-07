import '../../models/jwt_token_model.dart';
import '../../models/survey_model.dart';
import '../../models/user_model.dart';

abstract class AbstractUserService {
  Future<int?> registerUser(UserModel userModel);
  Future<void> activateUser(UserModel userModel, String code);
  Future<JwtTokenModel?> loginUser(String userName, String password);
  Future<void> surveyUser(SurveyModel surveyModel);
  Future<void> refreshJwtToken();
}