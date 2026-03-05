import 'dart:async';

import 'package:deardiaryv2/features/diary/domain/entities/diary_entry.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/add_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/delete_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/get_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/search_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/sync_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/domain/usecases/update_entry_usecase.dart';
import 'package:deardiaryv2/features/diary/presentation/screens/home.dart';
import 'package:flutter/material.dart';

enum DiaryStatus { idle, loading, success, error }

class DiaryProvider extends ChangeNotifier {
  DiaryStatus _status = DiaryStatus.idle;
  DiaryStatus get status => _status;
  bool _isSelectionMode = false;
  bool get isSelectionMode => _isSelectionMode;
  final Set<int> _selectedLocalIds = {};
  Set<int> get selectedLocalIds => _selectedLocalIds;
  List<DiaryEntry> searchResults = [];
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  List<DiaryEntry> diaries = [];
  Timer? _debounce;
  final GetEntryUsecase getEntryUsecase;
  final AddEntryUsecase addEntryUsecase;
  final DeleteEntryUsecase deleteEntryUsecase;
  final SyncEntryUsecase syncEntryUsecase;
  final UpdateEntryUsecase updateEntryUsecase;
  final SearchEntryUsecase searchEntryUsecase;

  void enterSelection(int id) {
    _isSelectionMode = true;
    _selectedLocalIds.add(id);
    notifyListeners();
  }

  void toggleSelection(int id) {
    if (_selectedLocalIds.contains(id)) {
      _selectedLocalIds.remove(id);
    } else {
      _selectedLocalIds.add(id);
    }

    if (_selectedLocalIds.isEmpty) {
      _isSelectionMode = false;
    }

    notifyListeners();
  }

  void exitSelection() {
    _isSelectionMode = false;
    _selectedLocalIds.clear();
    notifyListeners();
  }

  DiaryProvider({
    required this.getEntryUsecase,
    required this.addEntryUsecase,
    required this.deleteEntryUsecase,
    required this.updateEntryUsecase,
    required this.syncEntryUsecase,
    required this.searchEntryUsecase,
  });

  Future<void> fetchDiaries() async {
    _status = DiaryStatus.loading;
    notifyListeners();
    try {
      diaries = await getEntryUsecase.call();
      searchResults = diaries;
      _status = DiaryStatus.success;
    } catch (e) {
      _status = DiaryStatus.error;
    }
    notifyListeners();
  }

  Future<void> sync() async {
    try {
      await syncEntryUsecase.call();
    } catch (e) {
      _status = DiaryStatus.error;
    }
    notifyListeners();
  }

  Future<void> add(String title, String content) async {
    try {
      await addEntryUsecase.call(title, content);
      await fetchDiaries();
      unawaited(sync());
    } catch (e) {
      _status = DiaryStatus.error;
      notifyListeners();
    }
  }

  Future<void> update(int localId, String title, String content) async {
    try {
      await updateEntryUsecase.call(localId, title, content);
      await fetchDiaries();
      unawaited(sync());
    } catch (e) {
      _status = DiaryStatus.error;
      notifyListeners();
    }
  }

  Future<void> delete() async {
    try {
      await deleteEntryUsecase.call(_selectedLocalIds.toList());
      await fetchDiaries();
      unawaited(sync());
    } catch (e) {
      _status = DiaryStatus.error;
      notifyListeners();
    }
    exitSelection();
  }

  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;

    searchResults = await searchEntryUsecase.call(keyword);

    notifyListeners();
  }

  void searchDebounce(String keyword) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      search(keyword);
    });
  }

  void enterSearching() {
    _isSearching = true;
    notifyListeners();
  }

  void exitSearching() {
    _isSearching = false;
    searchResults = diaries;
    notifyListeners();
  }

  void sortDiaries(SortingType? type) {
    if (type == SortingType.newestFirst) {
      diaries.sort((a, b) => b.createdAt.compareTo(a.createdAt)); //new first
    } else {
      diaries.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    notifyListeners();
  }
}
