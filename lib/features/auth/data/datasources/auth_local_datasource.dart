abstract class AuthLocalDatasource {
  Future<void> saveTokens(String accessToken, String refreshToken);
  Future<String?> getAccessToken(); 
  Future<String?> getRefreshToken(); 
  Future<void> clearTokens(); 
}