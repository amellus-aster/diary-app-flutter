import 'package:deardiaryv2/core/errors/exceptions.dart';
import 'package:deardiaryv2/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:deardiaryv2/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:deardiaryv2/features/auth/domain/entities/user.dart';
import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource local;
  AuthRepositoryImpl({required this.remote, required this.local});
  @override
  Future<User> login(String email, String password) async {
    final loginResponse = await remote.login(email, password);
    await local.saveTokens(
      loginResponse.accessToken,
      loginResponse.refreshToken,
    );
    final userModel = await remote.getMe(loginResponse.accessToken);
    return userModel.toEntity();
  }

  @override
  Future<User> register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    final registerResponse = await remote.register(
      email,
      password,
      confirmPassword,
    );
    await local.saveTokens(
      registerResponse.accessToken,
      registerResponse.refreshToken,
    );
    final userModel = await remote.getMe(registerResponse.accessToken);
    return userModel.toEntity();
  }

  @override
  Future<void> refreshToken(String refreshToken) async {
    final response = await remote.refreshToken(refreshToken);
    await local.saveTokens(response.accessToken, response.refreshToken);
  }

  @override
  Future<void> logout() async {
    await local.clearTokens();
  }

  @override
  Future<bool> checkAuth() async {
    final accessToken = await local.getAccessToken();
    if (accessToken == null) return false;
    if (!JwtDecoder.isExpired(accessToken)) {
      return true;
    }
    final refreshToken = await local.getRefreshToken();
    if (refreshToken == null) return false;
    try {
      final newTokens = await remote.refreshToken(refreshToken);
      await local.saveTokens(newTokens.accessToken, newTokens.refreshToken);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<String?> getToken() async {
    var token = await local.getAccessToken();
    return token;
  }

  @override
  Future<User> getMe(String accessToken) async {
    try {
      final remoteModel = await remote.getMe(accessToken);
      return remoteModel.toEntity();
    } catch (e) {
      throw Exception("get me failed");
    }
  }

  @override
  Future<String?> currentUserId() async {
    final token = await local.getAccessToken();

    if (token == null) {
      return null; 
    }

    final decoded = JwtDecoder.decode(token);

    return decoded["sub"];
  }

  @override
  Future<T> executeWithAuth<T>(Future<T> Function(String token) apiCall) async {
    var token = await local.getAccessToken();
    try {
      return await apiCall(token!);
    } on UnauthorizedException {
      final refreshToken = await local.getRefreshToken();

      if (refreshToken == null) throw UnauthorizedException();

      final newTokens = await remote.refreshToken(refreshToken);

      await local.saveTokens(newTokens.accessToken, newTokens.refreshToken);

      return await apiCall(newTokens.accessToken);
    }
  }
}
