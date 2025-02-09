import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'authentication/login_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
