import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';
import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:deardiaryv2/features/diary/domain/repositories/diary_repository.dart';

class AddEntryUsecase {
  final DiaryRepository diaryRepository;
  final AuthRepository authRepository;
  AddEntryUsecase(this.diaryRepository, this.authRepository);
  Future<void> call(String title, String content) async {
    final userId = await authRepository.currentUserId();
    if (userId == null) {
      throw Exception("User not authenticated");
    }
    final entry = DiaryEntry.create(title, userId, content);
    await diaryRepository.addEntry(entry);
  }
}
