import 'package:deardiaryv2/features/auth/domain/usecases/check_auth_usecase.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/logout_usecase.dart';
import 'package:deardiaryv2/features/auth/presentation/status/auth_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider extends ChangeNotifier {
  final CheckAuthUsecase checkAuthUseCase;
  final LogoutUsecase logoutUsecase; 
  AuthProvider(this.checkAuthUseCase, this.logoutUsecase);
  AuthStatus _status = AuthStatus.unknown;
  AuthStatus get status => _status;
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
  Future<void> checkAuthStatus() async {
    final isAuthenticated = await checkAuthUseCase.call(); 

    _status = isAuthenticated
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;

    notifyListeners();
  }
  Future<void> logout() async {
    await logoutUsecase.call();
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
