import 'package:deardiaryv2/features/auth/domain/entities/user.dart';
import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository authRepository;
  LoginUsecase(this.authRepository);
  Future<User> call(String email, String password) async {
    return authRepository.login(email, password);
  }
}
