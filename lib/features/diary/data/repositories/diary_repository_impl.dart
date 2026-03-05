import 'package:deardiaryv2/core/errors/exceptions.dart';
import 'package:deardiaryv2/features/auth/domain/repositories/auth_repository.dart';
import 'package:deardiaryv2/features/diary/data/datasources/diary_local_datasource.dart';
import 'package:deardiaryv2/features/diary/data/datasources/diary_remote_datasource.dart';
import 'package:deardiaryv2/features/diary/data/models/diary_model.dart';
import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:deardiaryv2/features/diary/domain/repositories/diary_repository.dart';

class DiaryRepositoryImpl implements DiaryRepository {
  final DiaryLocalDatasource local;
  final DiaryRemoteDatasource remote;
  final AuthRepository authRepository;
  DiaryRepositoryImpl({
    required this.local,
    required this.remote,
    required this.authRepository,
  });
  @override
  Future<List<DiaryEntry>> getEntries() async {
    final localModels = await local.getEntries();
    return localModels
        .where((e) => !e.isDeleted)
        .map((m) => m.toEntity())
        .toList();
  }

  @override
  Future<void> addEntry(DiaryEntry entry) async {
    final localModel = DiaryModel.fromEntity(entry);
    await local.addEntry(localModel);
  }

  @override
  Future<void> updateEntry(int localId, String title, String content) async {
    await local.updateEntry(localId, title, content);
  }

  @override
  Future<void> deleteEntries(List<int> selectedIds) async {
    await local.softDelete(selectedIds);
  }

  @override
  Future<List<DiaryEntry>> searchEntries(String keyword) async {
    final entries = await local.getEntries();

    return entries
        .where(
          (e) =>
              !e.isDeleted &&
              (e.title.toLowerCase().contains(keyword.toLowerCase()) ||
                  e.content.toLowerCase().contains(keyword.toLowerCase())),
        )
        .map((e) => e.toEntity())
        .toList();
  }

  @override
  Future<void> syncEntries() async {
    return authRepository.executeWithAuth((token) async {
      final unsynced = await local.getUnsyncedEntries();
      for (final entry in unsynced) {
        try {
          if (entry.isDeleted) {
            if (entry.remoteId != null) {
              await remote.deleteEntries(token, [entry.remoteId!]);
            }
            await entry.delete();
            entry.isSynced = true;
            await entry.save();
            continue;
          }
          if (entry.remoteId == null) {
            final remoteModel = await remote.addEntry(
              token,
              entry.title,
              entry.content,
            );

            entry
              ..remoteId = remoteModel.remoteId
              ..isSynced = true;

            await entry.save();
          } else {
            await remote.updateEntry(
              token,
              entry.remoteId!,
              entry.title,
              entry.content,
            );

            entry.isSynced = true;
            await entry.save();
          }
        } catch (e) {
          if (e is UnauthorizedException) {
            rethrow;
          }
        }
      }
    });
  }
}
