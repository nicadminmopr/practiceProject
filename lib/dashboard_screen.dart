import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practiceproject/school_admin/class_screens.dart';
import 'package:practiceproject/school_admin/student_attendance.dart';
import 'package:practiceproject/school_admin/student_name_screen.dart';
import 'package:practiceproject/school_admin/teacher_attendance.dart';
import 'package:practiceproject/teacher/classlist_teacher_screen.dart';

import 'attendance_students/attendance_student_screen.dart';
import 'attendance_students/mark_my_attendance.dart';
import 'attendance_students/upload_material.dart';
import 'branch_admin/Attendance_own.dart';
import 'branch_admin/upload_circular/event.dart';
import 'dashboard_controller.dart';
import 'utils/apptextstyles.dart';

class DashboardScreen extends StatelessWidget {
  final controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: Get.width,
            height: Get.height * 0.15,
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
                  style:
                      AppTextStyles.heading(fontSize: 25, color: Colors.white),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Obx(() => Text(
                      controller.userRole.value,
                      // Replace with dynamic teacher's name
                      style:
                          AppTextStyles.body(fontSize: 18, color: Colors.white),
                    )),
                SizedBox(
                  height: 5.0,
                ),
                Row(
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
                )
              ],
            ),
          ),
          SizedBox(height: 40), // Space between name and buttons

          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Explore',
              style: AppTextStyles.heading(fontSize: 15, color: Colors.black),
            ),
          ),
          SizedBox(height: 20),
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
                  ? Row(
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
                            child: options(
                                'Student Attendance', 'assets/attendance.png'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Get.to(() => UploadCircularScreen());
                            },
                            child: options(
                                'Upload Circular/Event', 'assets/notice.png'),
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
                            child: options(
                                'Mark Your Attendance', 'assets/check.png'),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                      ],
                    )
                  : (controller.userRole.value == 'Teacher')
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      Get.to(() => AttendanceOwn());
                                      //Get.to(() => MyCamera());
                                    },
                                    child: options('Mark Your Attendance',
                                        'assets/attendance.png'),
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
                                    child: options('Mark Students Attendance',
                                        'assets/attendance.png'),
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
                                    child: options(
                                        'Upload Homework', 'assets/paper.png'),
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
                                    child: options(
                                        'Upload Classwork', 'assets/paper.png'),
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
                                    child: options('Upload Assignment',
                                        'assets/paper.png'),
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
                            )
                          ],
                        )
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
}
