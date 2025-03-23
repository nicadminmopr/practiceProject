import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:practiceproject/dashboard_controller.dart';
import 'package:practiceproject/utils/apptextstyles.dart';
import 'package:practiceproject/utils/singleton.dart';

import '../branch_admin/attendance_own_controller.dart';
import '../branch_admin/camera_screen.dart';
import 'classlist_teacher_screen.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({Key? key}) : super(key: key);

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  final controller1 = Get.put(AttendanceOwnController());
  String _callbackMessage = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
    // showConfirmationPopup(context); // If needed
  }

  void showConfirmationPopup(BuildContext context) {
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
    final List<Map<String, dynamic>> drawerItems = [
      {
        "title": "Mark your attendance",
        "onTap": () {
          Get.to(() => MyCamera(onDataReceived: _myCallback));
        },
      },
      {
        "title": "Student Attendance",
        "onTap": () {
          Get.to(() =>
              ClasslistTeacherScreen(onEvent: 'Mark Students Attendance'));
        },
      },
      {
        "title": "Upload Homework",
        "onTap": () {
          Get.to(() => ClasslistTeacherScreen(onEvent: 'Upload Homework'));
        },
      },
      {
        "title": "Upload Classwork",
        "onTap": () {
          Get.to(() => ClasslistTeacherScreen(onEvent: 'Upload Classwork'));
        },
      },
      {
        "title": "Upload Assignment",
        "onTap": () {
          Get.to(() => ClasslistTeacherScreen(onEvent: 'Upload Assignment'));
        },
      },
      {
        "title": "See Homework",
        "onTap": () {
          Get.to(() => ClasslistTeacherScreen(onEvent: 'See Homework'));
        },
      },
      {
        "title": "See Classwork",
        "onTap": () {
          Get.to(() => ClasslistTeacherScreen(onEvent: 'See Classwork'));
        },
      },
      {
        "title": "Attendance Logs",
        "onTap": () {
          // You can add navigation or logic for attendance logs here
        },
      },
    ];
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: buildDrawer(context, drawerItems),
      body: Column(
        children: [
          SizedBox(height: kToolbarHeight),
          Row(
            children: [
              SizedBox(width: 15),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                          offset: Offset(1.0, 1.0))
                    ],
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.menu, color: Colors.black, size: 20.0),
                ),
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                        offset: Offset(1.0, 1.0))
                  ],
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.notifications_none,
                    color: Colors.black, size: 20.0),
              ),
              SizedBox(width: 15),
            ],
          ),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              children: [
                Image.asset('assets/profile.png', height: 80, width: 80),
                SizedBox(width: 12.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome',
                        style: AppTextStyles.body(
                                color: Colors.black, fontSize: 14)
                            .copyWith(fontWeight: FontWeight.normal)),
                    Text('${AuthManager().username}',
                        style: AppTextStyles.heading(
                                color: Colors.black, fontSize: 16)
                            .copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline)),
                    Text(
                        '${AuthManager().designation ?? "${Get.find<DashboardController>().userRole.value}"}',
                        style: AppTextStyles.body(
                                color: Colors.black, fontSize: 15)
                            .copyWith(fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: optionWidget(
                        title: "Mark your attendance",
                        color: Color(0xffbdea96),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyCamera(onDataReceived: _myCallback),
                            ),
                          );
                        },
                        imagePath: "assets/teacherIcons/immigration.png",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: optionWidget(
                        title: "Student Attendance",
                        color: Color(0xffaef3ff),
                        onTap: () {
                          Get.to(() => ClasslistTeacherScreen(
                                onEvent: 'Mark Students Attendance',
                              ));
                        },
                        imagePath: "assets/teacherIcons/student.png",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: optionWidget(
                        title: "Upload Homework",
                        color: Color(0xffffcbe2),
                        onTap: () {
                          Get.to(() => ClasslistTeacherScreen(
                                onEvent: 'Upload Homework',
                              ));
                        },
                        imagePath: "assets/teacherIcons/homework.png",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: optionWidget(
                        title: "Upload Classwork",
                        color: Color(0xffbdea96),
                        onTap: () {
                          Get.to(() => ClasslistTeacherScreen(
                                onEvent: 'Upload Classwork',
                              ));
                        },
                        imagePath: "assets/teacherIcons/book.png",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: optionWidget(
                        title: "Upload Assignment",
                        color: Color(0xffaef3ff),
                        onTap: () {
                          Get.to(() => ClasslistTeacherScreen(
                                onEvent: 'Upload Assignment',
                              ));
                        },
                        imagePath: "assets/teacherIcons/assignment.png",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: optionWidget(
                        title: "See Homework",
                        color: Color(0xffffcbe2),
                        onTap: () {
                          Get.to(() => ClasslistTeacherScreen(
                                onEvent: 'See Homework',
                              ));
                        },
                        imagePath: "assets/teacherIcons/homework.png",
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: optionWidget(
                        title: "See Classwork",
                        color: Color(0xffbdea96),
                        onTap: () {
                          Get.to(() => ClasslistTeacherScreen(
                                onEvent: 'See Classwork',
                              ));
                        },
                        imagePath: "assets/teacherIcons/book.png",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: optionWidget(
                        title: "Attendance Logs",
                        color: Color(0xffaef3ff),
                        onTap: () {},
                        imagePath: "assets/teacherIcons/file.png",
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Drawer buildDrawer(BuildContext context, drawerItems) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/profile.png'),
                ),
                SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${AuthManager().username}',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    Text('${AuthManager().designation ?? "--"}',
                        style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: drawerItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    drawerItems[index]['title'],
                    style: AppTextStyles.body(
                      fontSize: 14.0,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.pop(context); // Close drawer first
                    drawerItems[index]['onTap'](); // Then perform action
                  },
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout",
                style: AppTextStyles.body(
                  fontSize: 14.0,
                ).copyWith(fontWeight: FontWeight.bold)),
            onTap: () {
              Get.find<DashboardController>().showLogoutDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget optionWidget({
    required String title,
    required String imagePath,
    required Function onTap,
    required Color color,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.0),
            boxShadow: [
              BoxShadow(
                offset: Offset(1.0, 1.0),
                spreadRadius: 1.0,
                blurRadius: 1.0,
                color: Colors.black12,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Image.asset(
                  '$imagePath',
                  height: 40,
                  width: 40,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "$title",
                style: AppTextStyles.heading(fontSize: 14),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
}
