import 'package:hive/hive.dart';
import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
part 'diary_model.g.dart';

@HiveType(typeId: 0)
class DiaryModel extends HiveObject {
  int? get localId => key as int?;
  @HiveField(0)
  int? remoteId;

  @HiveField(1)
  String userId;

  @HiveField(2)
  String title;

  @HiveField(3)
  String content;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  bool isSynced;

  @HiveField(7)
  bool isDeleted;

  DiaryModel({
    this.remoteId,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
    required this.isDeleted,
  });

  factory DiaryModel.fromJson(Map<String, dynamic> json) {
    return DiaryModel(
      remoteId: json['id'],
      userId: json['userId'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isSynced: true,
      isDeleted: false, 
    );
  }

  DiaryEntry toEntity() {
    return DiaryEntry(
      localId: localId!,
      remoteId: remoteId,
      userId: userId,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isDeleted: isDeleted,
      isSynced: isSynced,
    );
  }

  factory DiaryModel.fromEntity(DiaryEntry entity) {
    return DiaryModel(
      remoteId: entity.remoteId,
      userId: entity.userId,
      title: entity.title,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isSynced: entity.isSynced,
      isDeleted: entity.isDeleted
    );
  }

}
