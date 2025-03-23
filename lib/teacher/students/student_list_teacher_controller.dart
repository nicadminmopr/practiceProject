import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:practiceproject/dashboard_screen.dart';
import 'package:practiceproject/utils/apptextstyles.dart';

import '../../utils/singleton.dart';

class StudentListTeacherController extends GetxController {
  RxList studentList = [].obs;
  RxBool loading = false.obs;
  RxBool marking = false.obs;
  var attendance = <int, bool>{}.obs;
  void setStudentList(List<dynamic> students) {
    //studentList.assignAll(students);

    // Initialize attendance map for all students to false
    for (var student in students) {
      final id = student['studentId'];
      if (!attendance.containsKey(id)) {
        attendance[id] = false;
      }
    }
  }

  void toggleAttendance(int studentId, bool isPresent) {
    attendance[studentId] = isPresent;
  }

  getStudentList() async {
    loading.value = true;
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/w/v1/academicYearWiseStudent/${Get.arguments['classId'].toString()}/0'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      var r = await response.stream.bytesToString();
      var d = jsonDecode(r);
      studentList.value = d;
      setStudentList(studentList.value);
    } else {
      loading.value = false;
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }

  saveAttendance(body) async {
    marking.value = true;
    var headers = {
      'Authorization': 'Bearer ${AuthManager().getAuthToken()}',
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/w/v1/studentAttendance'));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      marking.value = false;
      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/checkmark.png',
                height: 100,
                color: Colors.green,
              ),
              // Add an image in assets folder
              SizedBox(height: 10),
              Text(
                "Attendance Marked Successfully!",
                style: AppTextStyles.heading(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              MaterialButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Get.offAll(() => DashboardScreen());
                },
                child:
                    Text("Back to Home", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    } else {
      marking.value = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text(
              'Something went wrong ${response.statusCode.toString()} Server Error')));
    }
  }

  /*void submitAttendance() {

    final now = DateTime.now();
    final formattedDate = DateFormat('d-M-yyyy').format(now).split('-');

    final List<Map<String, dynamic>> attendanceList = attendance.entries
        .where((entry) => entry.value)
        .map((entry) => {
              "studentId": entry.key,
              "isPresent": true,
              "day": formattedDate[0],
              "month": formattedDate[1],
              "year": formattedDate[2],
            })
        .toList();
    log('body sent is $attendanceList');
    //saveAttendance(attendanceList);
  }*/

  void submitAttendance() {
    final now = DateTime.now();
    final formattedDate = DateFormat('d-M-yyyy').format(now).split('-');

    final List<Map<String, dynamic>> attendanceList = attendance.entries
        .map((entry) => {
      "studentId": entry.key,
      "isPresent": entry.value, // true or false based on marking
      "classId":"${Get.arguments['classId']}",
      "sectionId": null,
    })
        .toList();

    log('body sent is ${jsonEncode(attendanceList)}');
    saveAttendance(attendanceList);
  }
// Replace with API call

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getStudentList();
  }
}
