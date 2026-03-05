import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:deardiaryv2/features/diary/domain/repositories/diary_repository.dart';

class GetEntryUsecase {
  final DiaryRepository diaryRepository;
  GetEntryUsecase(this.diaryRepository); 
  Future<List<DiaryEntry>> call(){
     return diaryRepository.getEntries(); 
  }
}