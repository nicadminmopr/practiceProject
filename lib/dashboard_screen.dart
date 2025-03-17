import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:practiceproject/school_admin/class_screens.dart';
import 'package:practiceproject/school_admin/student_attendance.dart';
import 'package:practiceproject/school_admin/student_name_screen.dart';
import 'package:practiceproject/school_admin/teacher_attendance.dart';
import 'package:practiceproject/teacher/classlist_teacher_screen.dart';
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
  final controller1 = Get.put(AttendanceOwnController());

  //TODO: Code for attendance

  void _myCallback(String message) {
    log('Callback received: $message');
    setState(() {
      _callbackMessage = message;
    });

    if (controller1.lat.value.isNotEmpty && controller1.long.value.isNotEmpty) {
      controller1.markAttendanceFunction(_callbackMessage);
    } else {
      controller1.fetchLocation();
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('Location is mandatory')));
    }
    //showConfirmationPopup(context);
  }

  String _callbackMessage = "";

  showConfirmationPopup(BuildContext context) {
    log('here entered');
    String currentDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Attendance"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Date & Time: $currentDateTime",
                style: AppTextStyles.heading(fontSize: 15, color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                "I confirm the data provided by me is correct.",
                style: AppTextStyles.body(fontSize: 15, color: Colors.black),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Mark Attendance"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log('Role Id: ${AuthManager().roleId}');
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                controller.storageService.read('name').toString(),
                style: AppTextStyles.heading(color: Colors.white, fontSize: 20),
              ),
              accountEmail: Text(controller.userRole.value,
                  style:
                      AppTextStyles.heading(color: Colors.white, fontSize: 14)),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: controller.teacherMenu
                  .map((f) => ListTile(
                        onTap: () {
                          controller.handleNavigation(f['name']);
                        },
                        leading: Image.asset(
                          f['image'],
                          height: 25,
                          width: 25,
                        ),
                        title: Text(
                          f['name'],
                          style: AppTextStyles.body(
                              fontSize: 14.0, color: Colors.black),
                        ),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top + 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Builder(
                    builder: (context) => IconButton(
                          icon: Icon(Icons.menu), // Drawer Icon
                          onPressed: () =>
                              Scaffold.of(context).openDrawer(), // Open Drawer
                        )),
                Spacer(),
                Icon(
                  Icons.notifications,
                  color: Colors.black,
                  size: 25.0,
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    controller.showLogoutDialog();
                  },
                  child: Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 25.0,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Teacher's Name
          Stack(
            children: [
              Container(
                width: Get.width,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.deepPurple.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      controller.storageService.read('name').toString(),
                      // Replace with dynamic teacher's name
                      style: AppTextStyles.heading(
                          fontSize: 25, color: Colors.white),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Obx(() => Text(
                          controller.userRole.value,
                          // Replace with dynamic teacher's name
                          style: AppTextStyles.body(
                              fontSize: 18, color: Colors.white),
                        )),
                    SizedBox(
                      height: 5.0,
                    ),
                    Obx(() => !controller.loading.value
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.white),
                            child: Obx(
                              () => DropdownButton<String>(
                                isExpanded: true,
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                underline: SizedBox(),
                                hint: Text(
                                  'Select Branch ',
                                  style: AppTextStyles.heading(
                                      color: Colors.deepPurple, fontSize: 14),
                                ),
                                value:
                                    controller.selectedBranch.value.isNotEmpty
                                        ? controller.selectedBranch.value
                                        : null,
                                onChanged: (newValue) {
                                  controller.selectedBranch.value = newValue!;
                                },
                                items: controller.branchList.value.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item['code'].toString(),
                                    child: Text(item['value']),
                                  );
                                }).toList(),
                              ),
                            ),
                          )
                        : Center(
                            child: CupertinoActivityIndicator(),
                          ))
                    /*Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      'Opening time: 08:00 AM',
                      style:
                          AppTextStyles.body(fontSize: 13, color: Colors.white),
                    )
                  ],
                )*/
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: -5,
                child: ClipOval(
                  child: Image.asset(
                    'assets/8030890.png',
                    height: 80,
                    width: 80,
                  ),
                ),
              )
            ],
          ),
          // SizedBox(height: 40), // Space between name and buttons

          SizedBox(height: 20),
          /*Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Explore',
              style: AppTextStyles.heading(fontSize: 15, color: Colors.black),
            ),
          ),*/

          controller.userRole.value == 'School Admin'
              ? Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ClassGridScreen(
                                onTap: () {
                                  Get.to(() => StudentListScreen());
                                },
                              ));
                        },
                        behavior: HitTestBehavior.opaque,
                        child: options('Fees Management', 'assets/receipt.png'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.to(() => TeacherAttendanceScreen());
                        },
                        child:
                            options('Teacher Attendance', 'assets/school.png'),
                      ),
                    ),
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
                        child: options(
                            'Student Attendance', 'assets/attendance.png'),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                  ],
                )
              : (controller.userRole.value == 'Branch Admin')
                  ? branchAdminUI()
                  : (controller.userRole.value == 'Teacher')
                      ? teacherUI()
                      : (controller.userRole.value == 'Class Teacher')
                          ? Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Get.to(() => UploadCircularScreen());
                                    },
                                    child: options('Upload Circular/Event',
                                        'assets/notice.png'),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => ClassGridScreen(
                                            onTap: () {
                                              Get.to(() => AttendanceScreen());
                                            },
                                          ));
                                    },
                                    child: options('Mark Students Attendance',
                                        'assets/attendance.png'),
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
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.to(() => MarkAttendanceScreen());
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: options(
                                        'Mark Attendance', 'assets/check.png'),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Get.to(() => AttendanceScreen());
                                    },
                                    child: options('Student Attendance',
                                        'assets/attendance.png'),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Get.to(() => UploadStudyMaterialScreen());
                                    },
                                    child: options('Upload Assignment',
                                        'assets/paper.png'),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: options('Notice', 'assets/notice.png'),
                                ),
                              ],
                            ),
          SizedBox(height: 30),
          /* Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Manage your school',
              style: AppTextStyles.heading(fontSize: 15, color: Colors.black),
            ),
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: optionsNew('Calender', 'assets/calendar.png'),
              ),
              Expanded(
                flex: 1,
                child: optionsNew('Profile', 'assets/profile-user.png'),
              ),
              Expanded(
                flex: 1,
                child: optionsNew('Fees', 'assets/receipt.png'),
              ),
              Expanded(
                flex: 1,
                child: optionsNew('Reports', 'assets/report.png'),
              ),
            ],
          ),*/
        ],
      ),
    );
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

  Widget teacherUI() => Column(
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
                    /*Get.to(() => ClassGridScreen(
                                            onTap: () {
                                              Get.to(() => AttendanceScreen());
                                            },
                                          ));*/

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
      );

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
                                      Get.to(() => EmployeeDirectory(),arguments: {
                                        "type":"all",
                                        "branch_id":controller.selectedBranch.value
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
                                      Get.to(() => EmployeeDirectory(),arguments: {
                                        "type":"present",
                                        "branch_id":controller.selectedBranch.value
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
                                    child:  Container(
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
