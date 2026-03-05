import 'dart:convert';
import 'package:deardiaryv2/core/errors/exceptions.dart';
import 'package:deardiaryv2/features/diary/data/datasources/diary_remote_datasource.dart';
import 'package:deardiaryv2/features/diary/data/models/diary_model.dart';
import 'package:http/http.dart' as http;

class DiaryRemoteDatasourceImpl implements DiaryRemoteDatasource {
  @override
  Future<List<DiaryModel>> getEntries(String accessToken) async {
    final response = await http.get(
      Uri.parse("http://localhost:5089/api/Diary"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (response.statusCode != 200) {
      throw Exception("get diaries fail");
    }  
    final List<dynamic> entries = jsonDecode(response.body);

    return entries.map((e) => DiaryModel.fromJson(e)).toList();
  }

  @override
  Future<DiaryModel> addEntry(
    String accessToken,
    String title,
    String content,
  ) async {
    final response = await http.post(
      Uri.parse("http://localhost:5089/api/Diary/add"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{'Title': title, 'Content': content}),
    );
    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
    if (response.statusCode != 200) {
      throw Exception("add diaries fail");
    }
    final entry = jsonDecode(response.body);
    return DiaryModel.fromJson(entry);
  }

  @override
  Future<void> deleteEntries(String accessToken, List<int> remoteIds) async { 
    final url = Uri.parse("http://localhost:5089/api/Diary/batch");
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(remoteIds),
    );

    if (response.statusCode == 401) {
      throw UnauthorizedException();
    }

    if (response.statusCode != 204) {
      throw Exception("Delete failed");
    }
  }

  @override
  Future<DiaryModel> updateEntry(
    String accessToken,
    int id,
    String title,
    String content,
  ) async {
    final response = await http.put(
      Uri.parse("http://localhost:5089/api/Diary/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(<String, dynamic>{'Title': title, 'Content': content}),
    );
     if (response.statusCode == 401) {
      throw UnauthorizedException();
    }
    if (response.statusCode != 200) {
      throw Exception("update diaries fail");
    }
    final entry = jsonDecode(response.body);
    return DiaryModel.fromJson(entry);
  }
}
