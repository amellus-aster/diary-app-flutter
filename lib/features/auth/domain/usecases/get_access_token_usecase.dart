import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';

class GetAccessTokenUsecase {
  final AuthRepository authRepository;
  GetAccessTokenUsecase(this.authRepository);
   Future<String?> call() async {
    return authRepository.getToken();
  }
}