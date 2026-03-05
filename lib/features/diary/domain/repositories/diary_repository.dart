import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';

abstract class DiaryRepository {
  Future<void> addEntry( DiaryEntry entry);
  Future<void> updateEntry(
    int localId,
    String title,
    String content,
  );
  Future<List<DiaryEntry>> getEntries();
  Future<void> syncEntries();
  Future<void> deleteEntries(List<int> selectedIds); 
  Future<List<DiaryEntry>> searchEntries(String keyword);
}
