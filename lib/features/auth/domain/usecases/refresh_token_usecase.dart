import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUsecase {
  final AuthRepository authRepository;
  RefreshTokenUsecase(this.authRepository);
  Future<void> call(String refreshToken) async {
    await authRepository.refreshToken(refreshToken);
  }
}
