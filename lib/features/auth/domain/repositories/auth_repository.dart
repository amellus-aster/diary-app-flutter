import 'package:deardiaryv2/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String confirmPassword);
  Future<void> refreshToken(String refreshToken);
  Future<void> logout();
  Future<bool> checkAuth(); 
  Future<String?> getToken(); 
  Future<User> getMe(String accessToken); 
  Future<String?> currentUserId();
  Future<T> executeWithAuth<T>(Future<T> Function(String token) apiCall); 
}
