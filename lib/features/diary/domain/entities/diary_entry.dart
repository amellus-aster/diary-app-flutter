class DiaryEntry {
  final int localId;
  final int? remoteId;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final bool isSynced;

  const DiaryEntry({
    this.localId = 0,
    this.remoteId,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.isSynced,
  });

  factory DiaryEntry.create(String title, String userId, String content) {
    return DiaryEntry(
      localId: 0, // temporary
      remoteId: null,
      userId: userId,
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDeleted: false,
      isSynced: false,
    );
  }

  DiaryEntry copyWith({
    int? localId,
    int? remoteId,
    String? userId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isDeleted,
    bool? isSynced,
  }) {
    return DiaryEntry(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
