import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:deardiaryv2/features/diary/domain/repositories/diary_repository.dart';

class SearchEntryUsecase {
  final DiaryRepository diaryRepository;

  SearchEntryUsecase(this.diaryRepository);

  Future<List<DiaryEntry>> call(String keyword) {
    return diaryRepository.searchEntries(keyword);
  }
}