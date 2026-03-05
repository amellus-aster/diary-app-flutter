import 'package:deardiaryv2/features/diary/data/datasources/diary_local_datasource.dart';
import 'package:hive/hive.dart';
import '../models/diary_model.dart';

class DiaryLocalDatasourceImpl implements DiaryLocalDatasource {
  final Box<DiaryModel> box;
  DiaryLocalDatasourceImpl(this.box);
  @override
  Future<List<DiaryModel>> getEntries() async {
    final entries = box.values.toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  @override
  Future<void> addEntry(DiaryModel entry) async {
    await box.add(entry);
    // auto key
  }

  @override
  Future<void> updateEntry(int localId, String title, String content) async {
    final entry = box.get(localId)!;

    entry
      ..title = title
      ..content = content
      ..updatedAt = DateTime.now()
      ..isSynced = false;

    await entry.save();
  }

  @override
  Future<void> saveEntries(List<DiaryModel> entries) async {
    for (final entry in entries) {
      try {
        final existing = await findByRemoteId(entry.remoteId!);

        existing
          ..title = entry.title
          ..content = entry.content
          ..updatedAt = entry.updatedAt
          ..isSynced = true;

        await existing.save();
      } catch (_) {
        await box.add(entry);
      }
    }
  }

  @override
  Future<List<DiaryModel>> getUnsyncedEntries() async {
    return box.values.where((e) => e.isSynced == false).toList();
  }

  @override
  Future<DiaryModel> findByRemoteId(int remoteId) async {
    return box.values.firstWhere((e) => e.remoteId == remoteId);
  }

  @override
  Future<DiaryModel> findByLocalId(int localId) async {
    return box.get(localId)!;
  }

  @override
  Future<List<DiaryModel>> findByLocalIds(List<int> localIds) async {
    return localIds.map((id) => box.get(id)!).toList();
  }

  @override
  Future<void> deleteByLocalIds(List<int> localIds) async {
    await box.deleteAll(localIds);
  }
  @override
  Future<void> softDelete(List<int> ids) async {
    final entries = ids.map((id) => box.get(id)!).toList();

    for (final e in entries) {
      e
        ..isDeleted = true
        ..isSynced = false;
    }

    await box.putAll({for (final e in entries) e.key: e});
  }
}
