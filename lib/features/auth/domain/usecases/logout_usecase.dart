import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';

class LogoutUsecase {
  AuthRepository authRepository; 
  LogoutUsecase(this.authRepository); 
   Future<void> call() async {
    await authRepository.logout();
  }
}