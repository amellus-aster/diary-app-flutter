import 'package:deardiaryv2/features/auth/domain/entities/user.dart';
import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository authRepository;
  RegisterUsecase(this.authRepository);
  Future<User> call(String email, String password, String confirmPassword) async {
    return authRepository.register(email, password, confirmPassword);
  }
}
