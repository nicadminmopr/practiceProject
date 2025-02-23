class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal();

  String? authToken;
  String? username;

  void setAuthToken(String token) {
    authToken = token;
  }

  void setUsername(String name) {
    username = name;
  }

  String? getAuthToken() {
    return authToken;
  }

  String? getUsername() {
    return username;
  }

  void clear() {
    authToken = null;
    username = null;
  }
}
