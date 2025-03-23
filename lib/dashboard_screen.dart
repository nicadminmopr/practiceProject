import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:practiceproject/branch_admin/admin_dashboard.dart';
import 'package:practiceproject/principleModule/principal_dashboard.dart';
import 'package:practiceproject/school_admin/class_screens.dart';
import 'package:practiceproject/school_admin/student_attendance.dart';
import 'package:practiceproject/school_admin/student_name_screen.dart';
import 'package:practiceproject/school_admin/teacher_attendance.dart';
import 'package:practiceproject/teacher/classlist_teacher_screen.dart';
import 'package:practiceproject/teacher/teacher_dashboard.dart';
import 'package:practiceproject/utils/singleton.dart';

import 'attendance_students/attendance_student_screen.dart';
import 'attendance_students/mark_my_attendance.dart';
import 'attendance_students/upload_material.dart';
import 'branch_admin/Attendance_own.dart';
import 'branch_admin/attendance_own_controller.dart';
import 'branch_admin/camera_screen.dart';
import 'branch_admin/employee_directory.dart';
import 'branch_admin/upload_circular/event.dart';
import 'dashboard_controller.dart';
import 'utils/apptextstyles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    log('Role Id: ${AuthManager().roleId}');
    log('Role : ${controller.userRole.value}');
    return Scaffold(
        body: (AuthManager().roleId == '19')
            ? TeacherDashboardScreen()
            : (AuthManager().roleId == '3')
                ? PrincipalDashboardScreen()
                : (AuthManager().roleId == '2')
                    ? AdminDashboardScreen()
                    : SizedBox());
  }

  Widget options(String title, image) => Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.deepPurple.shade100),
            child: Image.asset(
              image,
              height: 25,
              width: 25,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            title,
            style: AppTextStyles.heading(fontSize: 12, color: Colors.black),
            textAlign: TextAlign.center,
          )
        ],
      );

  Widget optionsView(String title, image) => Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: Colors.deepPurple.shade100),
            child: Image.asset(
              image,
              height: 25,
              width: 25,
              color: Colors.deepPurple,
            ),
          ),
          SizedBox(
            height: 4.0,
          ),
          Text(
            title,
            style: AppTextStyles.heading(fontSize: 12, color: Colors.black),
            textAlign: TextAlign.center,
          )
        ],
      );

  Widget optionsNew(String title, image) => Container(
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12,
                  blurRadius: 1.0,
                  offset: Offset(1.0, 1.0),
                  spreadRadius: 1.0)
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.deepPurple.shade100),
              child: Image.asset(
                image,
                height: 25,
                width: 25,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(
              height: 7.0,
            ),
            Text(
              title,
              style: AppTextStyles.heading(fontSize: 12, color: Colors.black),
              textAlign: TextAlign.center,
            )
          ],
        ),
      );

  /*Widget teacherUI() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MyCamera(onDataReceived: _myCallback),
                      ),
                    );
                    //Get.to(() => MyCamera());
                  },
                  child:
                      options('Mark Your Attendance', 'assets/attendance.png'),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    */ /*Get.to(() => ClassGridScreen(
                                            onTap: () {
                                              Get.to(() => AttendanceScreen());
                                            },
                                          ));*/ /*

                    Get.to(() => ClasslistTeacherScreen(
                          onEvent: 'Mark Students Attendance',
                        ));
                  },
                  child: options(
                      'Mark Students Attendance', 'assets/attendance.png'),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.to(() => ClasslistTeacherScreen(
                          onEvent: 'Upload Homework',
                        ));
                  },
                  child: options('Upload Homework', 'assets/paper.png'),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ClasslistTeacherScreen(
                          onEvent: 'Upload Classwork',
                        ));
                  },
                  behavior: HitTestBehavior.opaque,
                  child: options('Upload Classwork', 'assets/paper.png'),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.to(() => ClasslistTeacherScreen(
                          onEvent: 'Upload Assignment',
                        ));
                  },
                  child: options('Upload Assignment', 'assets/paper.png'),
                ),
              ),
              Expanded(
                child: SizedBox(),
                flex: 1,
              ),
              Expanded(
                child: SizedBox(),
                flex: 1,
              ),
              Expanded(
                child: SizedBox(),
                flex: 1,
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Divider(),
          SizedBox(
            height: 10.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Get.to(() => ClasslistTeacherScreen(
                              onEvent: 'See Homework',
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: [
                            Text(
                              'Check Added Homework',
                              style: AppTextStyles.heading(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ClasslistTeacherScreen(
                              onEvent: 'See Classwork',
                            ));
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: [
                            Text(
                              'Check Added Classwork',
                              style: AppTextStyles.heading(
                                  fontSize: 16.0, color: Colors.white),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                padding: EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 20,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      );*/

  Widget branchAdminUi() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.to(() => ClassGridScreen(
                          onTap: () {
                            Get.to(() => StudentAttendance());
                          },
                        ));
                  },
                  child: options('Student Attendance', 'assets/attendance.png'),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Get.to(() => UploadCircularScreen());
                  },
                  child: options('Upload Circular/Event', 'assets/notice.png'),
                ),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    //Get.to(() => MarkAttendanceBranchAdminScreen());
                    Get.to(() => AttendanceOwn());
                  },
                  child: options('Mark Your Attendance', 'assets/check.png'),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(),
              ),
            ],
          )
        ],
      );

  Widget branchAdminUI() => Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Employee Attendance",
                        style: AppTextStyles.heading(
                            fontSize: 15.0, color: Colors.black),
                      ),
                      Spacer(),
                      Text(
                        "View All",
                        style: AppTextStyles.heading(
                                fontSize: 10.0, color: Colors.blue)
                            .copyWith(decoration: TextDecoration.underline),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  controller.userRole.value == 'Branch Admin'
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Get.to(() => EmployeeDirectory(),
                                          arguments: {
                                            "type": "all",
                                            "branch_id":
                                                controller.selectedBranch.value
                                          });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Total',
                                            style: AppTextStyles.heading(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Obx(() => controller.aData.isNotEmpty
                                              ? Text(
                                                  '${controller.aData['total'] ?? "--"}',
                                                  style: AppTextStyles.heading(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                )
                                              : CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                )),
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => EmployeeDirectory(),
                                          arguments: {
                                            "type": "present",
                                            "branch_id":
                                                controller.selectedBranch.value
                                          });
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Present',
                                            style: AppTextStyles.heading(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Obx(() => controller.aData.isNotEmpty
                                              ? Text(
                                                  '${controller.aData['presentCount'] ?? "--"}',
                                                  style: AppTextStyles.heading(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                )
                                              : CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                ))
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {},
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Absent',
                                            style: AppTextStyles.heading(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Obx(() => controller.aData.isNotEmpty
                                              ? Text(
                                                  '${controller.aData['absentCount'] ?? "--"}',
                                                  style: AppTextStyles.heading(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                )
                                              : CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                ))
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Student  Attendance",
                        style: AppTextStyles.heading(
                            fontSize: 15.0, color: Colors.black),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  controller.userRole.value == 'Branch Admin'
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Total',
                                            style: AppTextStyles.heading(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Obx(() => controller.aData.isNotEmpty
                                              ? Text(
                                                  '${controller.studentAttendanceData['total'] ?? "--"}',
                                                  style: AppTextStyles.heading(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                )
                                              : CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                )),
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => ClasslistTeacherScreen(
                                            onEvent: 'See Classwork',
                                          ));
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Present',
                                            style: AppTextStyles.heading(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Obx(() => controller.aData.isNotEmpty
                                              ? Text(
                                                  '${controller.studentAttendanceData['presentCount'] ?? "--"}',
                                                  style: AppTextStyles.heading(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                )
                                              : CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                ))
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {},
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Absent',
                                            style: AppTextStyles.heading(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Obx(() => controller.aData.isNotEmpty
                                              ? Text(
                                                  '${controller.studentAttendanceData['absentCount'] ?? "--"}',
                                                  style: AppTextStyles.heading(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                )
                                              : CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                ))
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Revenue",
                        style: AppTextStyles.heading(
                            fontSize: 15.0, color: Colors.black),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  controller.userRole.value == 'Branch Admin'
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Total Amount',
                                            style: AppTextStyles.heading(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Obx(() => controller
                                                  .feeReceiptData.isNotEmpty
                                              ? Text(
                                                  '₹ ${controller.feeReceiptData.value ?? "--"}',
                                                  style: AppTextStyles.heading(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                )
                                              : CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                )),
                                        ],
                                      ),
                                    ),
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.deepPurple,
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Expenditure',
                                            style: AppTextStyles.heading(
                                                fontSize: 12.0,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Obx(() => controller
                                                  .expenditureData.isNotEmpty
                                              ? Text(
                                                  '₹ ${controller.expenditureData.value ?? "--"}',
                                                  style: AppTextStyles.heading(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                )
                                              : CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                )),
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ],
        ),
      );
}
