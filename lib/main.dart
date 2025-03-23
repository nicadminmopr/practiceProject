import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:practiceproject/teacher/teacher_dashboard.dart';
import 'package:practiceproject/utils/singleton.dart';
import 'package:practiceproject/utils/storage_service.dart';

import 'authentication/login_screen.dart';
import 'dashboard_screen.dart';

enum UserRole {
  schoolAdmin,
  branchAdmin,
  teacher,
  classTeacher,
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FaceCamera.initialize();
  await GetStorage.init();
  runApp(MyClass());
}

class MyClass extends StatelessWidget {
  AuthManager auth = AuthManager();

  Future<bool> fetch() async {
    RxBool isLogin = false.obs;
    var data = StorageService().read('token');
    var roleId = StorageService().read('roleId');

    if (data != null) {
      isLogin.value = true;
      auth.setAuthToken(data);
      auth.setRoleId(roleId);
    } else {
      isLogin.value = false;
    }
    return isLogin.value;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
          future: fetch(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error checking login status'));
            } else {
              bool isLoggedIn = snapshot.data ?? false;
              return isLoggedIn ? DashboardScreen() : LoginScreen();
            }
          }),

    );
  }
}
