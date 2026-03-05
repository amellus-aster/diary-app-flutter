import 'package:deardiaryv2/features/auth/domain/entities/user.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/get_access_token_usecase.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:deardiaryv2/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final GetCurrentUserUsecase getCurrentUserUseCase;
  final GetAccessTokenUsecase getAccessTokenUsecase;
  final LogoutUsecase logoutUsecase;
  ProfileProvider(
    this.getCurrentUserUseCase,
    this.getAccessTokenUsecase,
    this.logoutUsecase,
  );
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();
    var token = await getAccessTokenUsecase.call();
    if (token != null) {
      _user = await getCurrentUserUseCase.call(token);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logOut() async {
    await logoutUsecase.call();
  }
}
