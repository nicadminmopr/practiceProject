import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practiceproject/teacher/students/student_list_teacher_controller.dart';

import '../../utils/apptextstyles.dart';


// UI Screen for Marking Attendance
class StudentListTeacherScreen extends StatelessWidget {
  final controller = Get.put(StudentListTeacherController());

  @override
  Widget build(BuildContext context) {
    log('Class Id: ${Get.arguments['classId']}');
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
                          controller.studentList[index]['studentName'],
                          style: AppTextStyles.heading(
                            color: Colors.black,
                            fontSize: 14.0,
                          ).copyWith(fontWeight: FontWeight.w800),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /*Text(
                              "Absent",
                              style: AppTextStyles.body(fontSize: 12.0, color: Colors.black),
                            ),*/
                            Switch(
                              activeColor: Colors.green,
                              value: controller.attendance[
                              controller.studentList[index]["studentId"]] ??
                                  false,
                              onChanged: (bool value) {
                                controller.toggleAttendance(
                                    controller.studentList[index]["studentId"], value);
                              },
                            ),
                           /* Text(
                              "Present",
                              style: AppTextStyles.body(fontSize: 12.0, color: Colors.black),
                            ),*/
                          ],
                        ),
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
                child: MaterialButton(
                  color: Colors.black,
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
                ),
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
