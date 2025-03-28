import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:practiceproject/authentication/login_screen.dart';
import 'package:practiceproject/teacher/classlist_teacher_screen.dart';
import 'package:practiceproject/utils/apptextstyles.dart';
import 'package:practiceproject/utils/singleton.dart';
import 'package:practiceproject/utils/storage_service.dart';
import 'package:http/http.dart' as http;
import 'branch_admin/Attendance_own.dart';

class DashboardController extends GetxController {
  final StorageService storageService = StorageService();
  RxString userRole = ''.obs;
  RxList menuRoleWise = [{}].obs;

  RxString selectedBranch = ''.obs;
  RxList branchList = [].obs;
  RxBool loading = false.obs;
  RxMap aData = {}.obs;
  RxMap studentAttendanceData = {}.obs;
  RxList teacherMenu = [
    {
      "name": "Mark Your Attendance",
      "image": "assets/attendance.png",
      "navigation": "AttendanceOwn"
    },
    {
      "name": "Mark Students Attendance",
      "image": "assets/attendance.png",
      "navigation": "ClasslistTeacherScreen",
      "onEvent": "Mark Students Attendance"
    },
    {
      "name": "Upload Homework",
      "image": "assets/paper.png",
      "navigation": "ClasslistTeacherScreen",
      "onEvent": "Upload Homework"
    },
    {
      "name": "Upload Classwork",
      "image": "assets/paper.png",
      "navigation": "ClasslistTeacherScreen",
      "onEvent": "Upload Classwork"
    },
    {
      "name": "Upload Assignment",
      "image": "assets/paper.png",
      "navigation": "ClasslistTeacherScreen",
      "onEvent": "Upload Assignment"
    },
    {
      "name": "Logout",
      "image": "assets/logout.png",
      "navigation": "ClasslistTeacherScreen",
      "onEvent": "Upload Assignment"
    }
  ].obs;
  RxString expenditureData = ''.obs;
  RxString feeReceiptData = ''.obs;

  void handleNavigation(String title) {
    if (title == "Mark Your Attendance") {
      Get.to(() => AttendanceOwn());
    } else if (title == "Mark Students Attendance") {
      Get.to(() => ClasslistTeacherScreen(onEvent: "Mark Students Attendance"));
    } else if (title == "Upload Homework") {
      Get.to(() => ClasslistTeacherScreen(onEvent: "Upload Homework"));
    } else if (title == "Upload Classwork") {
      Get.to(() => ClasslistTeacherScreen(onEvent: "Upload Classwork"));
    } else if (title == "Upload Assignment") {
      Get.to(() => ClasslistTeacherScreen(onEvent: "Upload Assignment"));
    } else if (title == "Logout") {
      showLogoutDialog();
    } else {
      Get.snackbar("Error", "Invalid Selection",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getUserType();
    getLocation();
  }

  getUserType() async {
    log('ROLE ID: ${AuthManager().roleId}');
    AuthManager().username = await storageService.read("name");
    AuthManager().roleId = await storageService.read("roleId");
    AuthManager().designation = await storageService.read("designation");
    if (AuthManager().roleId == '19') {
      userRole.value = 'Teacher';
    } else if (AuthManager().roleId == '3') {
      userRole.value = 'Principle';
    } else if (AuthManager().roleId == '2') {
      userRole.value = 'Branch Admin';
      Future.value([
        getBranches(),
      ]);
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
            AuthManager().clear();
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

  getBranches() async {
    loading.value = true;
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/v1/r/schoolBranches/getBranchesBySchoolId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      var d = await response.stream.bytesToString();
      var r = jsonDecode(d);
      branchList.value = r;
      log('Branches ${branchList.value}');
      selectedBranch.value = branchList.first['code'].toString();
      getEmployeeData(selectedBranch.value);
      Future.wait([
        getStudentAttendanceData(),
        getExpenditureData(),
        getFeeReceiptData()
      ]);
    } else {
      loading.value = false;
      print(response.reasonPhrase);
    }
  }

  getEmployeeData(code) async {
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/employeeAttendanceData/branchWiseData/$code'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var d = await response.stream.bytesToString();
      var r = jsonDecode(d);
      aData.value = r;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getStudentAttendanceData() async {
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/studentAttendanceData/branchWiseData/${selectedBranch.value}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var d = await response.stream.bytesToString();
      var r = jsonDecode(d);
      studentAttendanceData.value = r;
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getExpenditureData() async {
    loading.value = true;

    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/expenditureData/branchWise/${selectedBranch.value}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;

      var d = await response.stream.bytesToString();
      var re = jsonDecode(d);
      expenditureData.value = re['totalAmount'].toString();
    } else {
      loading.value = false;
      print(response.reasonPhrase);
    }
  }

  Future getFeeReceiptData() async {
    loading.value = true;

    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/feeReceiptData/branchWise/${selectedBranch.value}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;

      var d = await response.stream.bytesToString();
      var re = jsonDecode(d);
      feeReceiptData.value = re['totalAmount'].toString();
    } else {
      loading.value = false;
      print(response.reasonPhrase);
    }
  }


  //Code for Location on
  Future<Position?> fetchGpsLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, can't continue
      // You might want to show a dialog to the user
      Geolocator.openLocationSettings();
      return null;
    }

    // Check for permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permission denied again
        await openAppSettings(); // Open app settings
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      await openAppSettings(); // Open app settings
      return null;
    }

    // If permission granted
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  void getLocation() async {
    Position? position = await fetchGpsLocation();
    if (position != null) {
      print("Lat: ${position.latitude}, Long: ${position.longitude}");
    } else {
      print("Could not fetch location.");
    }
  }


}
