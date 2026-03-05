import 'package:deardiaryv2/features/diary/data/models/diary_model.dart';

abstract class DiaryLocalDatasource {
  Future<List<DiaryModel>> getEntries();
  Future<void> addEntry(DiaryModel model);
  Future<void> saveEntries(List<DiaryModel> entries);
  Future<List<DiaryModel>> getUnsyncedEntries();
  Future<void> updateEntry(int localId, String title, String content);
  Future<DiaryModel> findByRemoteId(int remoteId);
  Future<DiaryModel> findByLocalId(int localId);
  Future<List<DiaryModel>> findByLocalIds(List<int> remoteIds);
  Future<void> deleteByLocalIds(List<int> remoteIds);
  Future<void> softDelete(List<int> ids); 
}
