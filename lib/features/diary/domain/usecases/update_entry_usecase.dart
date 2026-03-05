import 'package:deardiaryv2/features/diary/domain/repositories/diary_repository.dart';

class UpdateEntryUsecase {
  final DiaryRepository diaryRepository;
  UpdateEntryUsecase(this.diaryRepository);
  Future<void> call(
    int localId,
    String title,
    String content,
  ) async {
   await diaryRepository.updateEntry(localId, title, content);
  }
}
