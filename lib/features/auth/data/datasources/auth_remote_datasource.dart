import 'package:deardiaryv2/features/auth/data/models/login_response_model.dart';
import 'package:deardiaryv2/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<LoginResponseModel> login(String email, String password);
  Future<UserModel> getMe(String accessToken);
  Future<LoginResponseModel> refreshToken(String refreshToken);
  Future<LoginResponseModel> register(
    String email,
    String password,
    String confirmPassword,
  );
}
