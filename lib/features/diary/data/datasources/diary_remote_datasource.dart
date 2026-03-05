import 'package:deardiaryv2/features/diary/data/models/diary_model.dart';

abstract class DiaryRemoteDatasource {
  Future<List<DiaryModel>> getEntries(String accessToken); 
  Future<DiaryModel> addEntry(String accessToken, String title, String content); 
  Future<DiaryModel> updateEntry(String accessToken, int id,String title, String content); 
  Future<void> deleteEntries(String accessToken, List<int> remoteIds ); 
}