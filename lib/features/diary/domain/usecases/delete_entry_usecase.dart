import 'package:deardiaryv2/features/diary/domain/repositories/diary_repository.dart';

class DeleteEntryUsecase {
  final DiaryRepository diaryRepository;
  DeleteEntryUsecase(this.diaryRepository);
  Future<void> call(List<int> selectedIds) async {
    await diaryRepository.deleteEntries(selectedIds);
  }
}
