import 'package:deardiaryv2/features/diary/domain/repositories/diary_repository.dart';

class SyncEntryUsecase {
  final DiaryRepository diaryRepository; 
  SyncEntryUsecase(this.diaryRepository); 
  Future<void> call() async {
     await diaryRepository.syncEntries(); 
  }
}