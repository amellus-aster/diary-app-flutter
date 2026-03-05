import 'package:deardiaryv2/features/auth/domain/entities/user.dart';
import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUsecase {
  final AuthRepository authRepository;
  GetCurrentUserUsecase(this.authRepository); 
  Future<User> call(String accessToken) async  { 
      return authRepository.getMe(accessToken); 
  }
}