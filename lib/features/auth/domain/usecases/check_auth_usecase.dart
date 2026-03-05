import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';

class CheckAuthUsecase {
  final AuthRepository authRepository;
  CheckAuthUsecase(this.authRepository); 
  Future<bool> call() async {
    return authRepository.checkAuth();
  }
}
