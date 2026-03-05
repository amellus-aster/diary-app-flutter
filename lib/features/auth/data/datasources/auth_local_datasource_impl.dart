import 'package:deardiaryv2/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  @override  
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', accessToken);
    prefs.setString('refresh_token', refreshToken);
  }
  @override 
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token'); 
  }
  @override
  Future<String?> getRefreshToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token'); 
  }
  @override 
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('access_token'); 
    prefs.remove('refresh_token'); 
  }
}