import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../utils/singleton.dart';
import 'package:http/http.dart' as http;

class PrincipalDashboardController extends GetxController {
  RxString selectedBranch = '0'.obs;
  RxList branchList = [].obs;
  RxBool loading = false.obs;
  RxBool loadingFalse = false.obs;
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
    loadingFalse.value = true;
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/studentAttendanceData/branchWiseData/${selectedBranch.value}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {loadingFalse.value = false;

      var d = await response.stream.bytesToString();
      var r = jsonDecode(d);
      studentAttendanceData.value = r;
    } else {
      loadingFalse.value = false;
      print(response.reasonPhrase);
    }
  }

  Future getExpenditureData() async {
    loading.value = true;
    loadingFalse.value = true;
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/expenditureData/branchWise/${selectedBranch.value}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      loadingFalse.value = false;
      var d = await response.stream.bytesToString();
      var re = jsonDecode(d);
      expenditureData.value = re['totalAmount'].toString();
    } else {
      loadingFalse.value = false;
      loading.value = false;
      print(response.reasonPhrase);
    }
  }

  Future getFeeReceiptData() async {
    loading.value = true;
    loadingFalse.value = true;
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/feeReceiptData/branchWise/${selectedBranch.value}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      loadingFalse.value = false;
      var d = await response.stream.bytesToString();
      var re = jsonDecode(d);
      feeReceiptData.value = re['totalAmount'].toString();
    } else {
      loadingFalse.value = false;
      loading.value = false;
      print(response.reasonPhrase);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getStudentAttendanceData();
    getExpenditureData();
    getFeeReceiptData();
  }
}
