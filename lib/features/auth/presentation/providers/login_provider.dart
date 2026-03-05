import 'package:deardiaryv2/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter/material.dart';

enum LoginStatus { idle, loading, success, error }

class LoginProvider extends ChangeNotifier {
  final LoginUsecase loginUsecase;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  LoginProvider(this.loginUsecase);
  LoginStatus _status = LoginStatus.idle;
  LoginStatus get status => _status;
  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Please fill all fields";
      _status = LoginStatus.error;
      notifyListeners();
      return;
    }
    try {
      _status = LoginStatus.loading;
      notifyListeners();
      await loginUsecase.call(email, password);
      _status = LoginStatus.success;
    } catch (e) {
      _errorMessage = "Sign in failed";
      _status = LoginStatus.error;
    }
    notifyListeners();
  }
}
