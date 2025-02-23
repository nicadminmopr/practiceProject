import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practiceproject/teacher/students/student_list_teacher_controller.dart';

import '../../utils/apptextstyles.dart';

// Model for a Student
class Student {
  final int id;
  final String name;
  String attendance; // 'Present' or 'Absent'

  Student({required this.id, required this.name, this.attendance = 'Absent'});
}

// Controller for managing attendance
class AttendanceController extends GetxController {
  var students = <Student>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
  }

  // Simulating fetching students
  void fetchStudents() {
    students.value = [
      Student(id: 1, name: 'Alice'),
      Student(id: 2, name: 'Bob'),
      Student(id: 3, name: 'Charlie'),
    ];
  }

  // Update attendance for a student
  void updateAttendance(int id, String attendance) {
    students.firstWhere((student) => student.id == id).attendance = attendance;
    students.refresh();
  }

  // Save attendance
  void saveAttendance() {
    // Logic to save attendance to a database or API
    Get.snackbar('Success', 'Attendance saved successfully!');
  }
}

// UI Screen for Marking Attendance
class StudentListTeacherScreen extends StatelessWidget {
  final controller = Get.put(StudentListTeacherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Mark Attendance',
          style: AppTextStyles.heading(fontSize: 15, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Obx(() => controller.marking.value
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade300.withOpacity(0.7),
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : SizedBox()),
          Column(
            children: [
              Expanded(
                child: Obx(
                  () => !controller.loading.value
                      ? controller.studentList.isNotEmpty
                          ? ListView.builder(
                              itemCount: controller.studentList.length,
                              itemBuilder: (context, index) {
                                return Obx(() => ListTile(
                                      title: Text(
                                        controller.studentList[index]
                                            ['studentName'],
                                        style: AppTextStyles.heading(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                        ).copyWith(fontWeight: FontWeight.w800),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Radio<bool>(
                                            activeColor: Colors.black,
                                            value: true,
                                            groupValue: controller.attendance[
                                                controller.studentList[index]
                                                    ["studentId"]],
                                            onChanged: (bool? value) {
                                              controller.toggleAttendance(
                                                  controller.studentList[index]
                                                      ["studentId"],
                                                  value ?? false);
                                            },
                                          ),
                                          Text(
                                            "Present",
                                            style: AppTextStyles.body(
                                                fontSize: 12.0,
                                                color: Colors.black),
                                          ),
                                          Radio<bool>(
                                            activeColor: Colors.black,
                                            value: false,
                                            groupValue: controller.attendance[
                                                controller.studentList[index]
                                                    ["studentId"]],
                                            onChanged: (bool? value) {
                                              controller.toggleAttendance(
                                                  controller.studentList[index]
                                                      ["studentId"],
                                                  value ?? false);
                                            },
                                          ),
                                          Text(
                                            "Absent",
                                            style: AppTextStyles.body(
                                                fontSize: 12.0,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      /* trailing: Checkbox(
                          activeColor: Colors.black,
                          shape: CircleBorder(),
                          value: controller.attendance[
                                  controller.studentList[index]["studentId"]] ??
                              false,
                          onChanged: (bool? value) {
                            controller.toggleAttendance(
                                controller.studentList[index]["studentId"],
                                value ?? false);
                          },
                        ),*/
                                    ));
                              },
                            )
                          : Center(
                              child: Text('No Data Available'),
                            )
                      : Center(
                          child: CupertinoActivityIndicator(),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => MaterialButton(
                      color: controller.attendance.isNotEmpty
                          ? Colors.black
                          : Colors.grey,
                      height: 48,
                      minWidth: 300.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onPressed: controller.submitAttendance,
                      child: Text(
                        'Save Attendance',
                        style: AppTextStyles.heading(
                            fontSize: 15, color: Colors.white),
                      ),
                    )),
              ),
              SizedBox(
                height: 20.0,
              )
            ],
          )
        ],
      ),
    );
  }
}
