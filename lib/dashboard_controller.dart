import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practiceproject/authentication/login_screen.dart';
import 'package:practiceproject/utils/apptextstyles.dart';
import 'package:practiceproject/utils/storage_service.dart';

class DashboardController extends GetxController {
  final StorageService storageService = StorageService();
  RxString userRole = ''.obs;
  RxList menuRoleWise = [{}].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserType();
  }

  getUserType() async {
    String? usertype = storageService.read<String>('userType');
    if (usertype == 'schoolAdmin') {
      userRole.value = 'School Admin';
    } else if (usertype == 'branchAdmin') {
      userRole.value = 'Branch Admin';
    } else if (usertype == 'teacher') {
      userRole.value = 'Teacher';
    } else if (usertype == 'classTeacher') {
      userRole.value = 'Class Teacher';
    }
  }

  void showLogoutDialog() {
    Get.defaultDialog(
      title: "Logout",
      middleText: "Are you sure you want to log out?",
      titleStyle: AppTextStyles.heading(fontSize: 18, color: Colors.black),
      middleTextStyle: AppTextStyles.body(fontSize: 16, color: Colors.black),
      radius: 10,
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close dialog
          },
          child: Text(
            "Cancel",
            style: AppTextStyles.body(color: Colors.deepPurple, fontSize: 14),
          ),
        ),
        MaterialButton(
          color: Colors.red,
          onPressed: () async {
            await StorageService().clear();
            Get.offAll(() => LoginScreen());
          },
          child: Text(
            "Logout",
            style: AppTextStyles.body(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
