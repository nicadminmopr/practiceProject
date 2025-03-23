class AuthManager {
  static final AuthManager _instance = AuthManager._internal();

  factory AuthManager() {
    return _instance;
  }

  AuthManager._internal();

  String? authToken;
  String? username;
  String? roleId;
  String? designation;

  void setAuthToken(String token) {
    authToken = token;
  }

  void setUsername(String name) {
    username = name;
  }

  void setDesignation(String name) {
    designation = name;
  }

  String? getAuthToken() {
    return authToken;
  }

  String? getDesignation() {
    return designation;
  }

  String? getUsername() {
    return username;
  }

  void setRoleId(String roleI) {
    roleId = roleI;
  }

  String? getRoleId() {
    return roleId;
  }

  void clear() {
    authToken = null;
    username = null;
    roleId = null;
    designation = null;
  }
}
