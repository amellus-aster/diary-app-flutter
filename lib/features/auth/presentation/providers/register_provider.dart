import 'package:deardiaryv2/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter/material.dart';

enum RegisterStatus { idle, loading, success, error }

class RegisterProvider extends ChangeNotifier {
  final RegisterUsecase registerUsecase;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  RegisterProvider(this.registerUsecase);
  RegisterStatus _status = RegisterStatus.idle;
  RegisterStatus get status => _status;
  Future<void> register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    _errorMessage = null;
    if (email.trim().isEmpty ||
        password.trim().isEmpty ||
        confirmPassword.trim().isEmpty) {
      _errorMessage = "Please fill all fields";
      _status = RegisterStatus.error;
      notifyListeners();
      return;
    }

    if (password != confirmPassword) {
      _errorMessage = "Passwords do not match";
      _status = RegisterStatus.error;
      notifyListeners();
      return;
    }
    try {
      _status = RegisterStatus.loading;
      notifyListeners();
      await registerUsecase.call(email, password, confirmPassword);
      await Future.delayed(Duration(seconds: 2));
      _status = RegisterStatus.success;
      
    } catch (e) {
      _errorMessage = "Sign up failed";
      _status = RegisterStatus.error;
    }
    notifyListeners();
  }

  void setError() {
    _status = RegisterStatus.error;
  }
}
