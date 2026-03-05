import 'dart:convert';
import 'package:deardiaryv2/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:deardiaryv2/features/auth/data/models/login_response_model.dart';
import 'package:deardiaryv2/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  @override
  Future<LoginResponseModel> login(String email, String password) async {
    final url = Uri.parse("http://localhost:5089/api/Auth/login");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'Email': email, 'Password': password}),
    );
    if (response.statusCode != 200) {
      throw Exception("Login Failed");
    }
    var data = jsonDecode(response.body);
    return LoginResponseModel.fromJson(data);
  }

  @override
  Future<UserModel> getMe(String accessToken) async{
     final meResponse = await http.get(
      Uri.parse("http://localhost:5089/api/Auth/me"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );
    if (meResponse.statusCode == 200) {
      var data = jsonDecode(meResponse.body);
      return UserModel(id: data['id'], email: data['email']);
    } else {
      throw Exception("ME failed: ${meResponse.body}");
    }
  }
  @override
  Future<LoginResponseModel> refreshToken(String refreshToken) async {
    final url = Uri.parse("http://localhost:5089/api/Auth/refresh-token");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{'RefreshToken': refreshToken}),
    );
    if (response.statusCode != 200) {
      throw Exception("Refresh failed");
    }
    var data = jsonDecode(response.body);
    return LoginResponseModel.fromJson(data);
  }

  @override
  Future<LoginResponseModel> register(
    String email,
    String password,
    String confirmPassword,
  ) async {
    final url = Uri.parse("http://localhost:5089/api/Auth/register");
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'Email': email,
        'Password': password,
        'ConfirmPassword': confirmPassword,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception("Register failed");
    }
    var data = jsonDecode(response.body);
    return LoginResponseModel.fromJson(data);
  }
}
