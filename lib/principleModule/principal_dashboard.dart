import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:practiceproject/dashboard_controller.dart';
import 'package:practiceproject/principleModule/principalDashboardController.dart';
import 'package:practiceproject/utils/apptextstyles.dart';
import 'package:practiceproject/utils/singleton.dart';

import '../branch_admin/admin_dashboard_controller.dart';
import '../branch_admin/attendance_own_controller.dart';
import '../branch_admin/camera_screen.dart';
import '../branch_admin/employee_directory.dart';
import '../teacher/classlist_teacher_screen.dart';
import 'eventUpload.dart';
import 'getEvents.dart';

class PrincipalDashboardScreen extends StatefulWidget {
  const PrincipalDashboardScreen({Key? key}) : super(key: key);

  @override
  State<PrincipalDashboardScreen> createState() =>
      _PrincipalDashboardScreenState();
}

class _PrincipalDashboardScreenState extends State<PrincipalDashboardScreen> {
  final controller = Get.put(PrincipalDashboardController());
  final GlobalKey popupKey =
      GlobalKey(); // Place this outside your build method
  final controller1 = Get.put(AttendanceOwnController());
  String _callbackMessage = "";

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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: kToolbarHeight),
            Row(
              children: [
                SizedBox(width: 15),
                Spacer(),
                InkWell(
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
                    child: Icon(Icons.notifications_none,
                        color: Colors.black, size: 20.0),
                  ),
                  onTap: (){
                    Get.to(()=>Getevents());
                  },
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: () {
                    Get.find<DashboardController>().showLogoutDialog();
                  },
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
                    child: Icon(Icons.logout, color: Colors.black, size: 20.0),
                  ),
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
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  revenueCards(),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      InfoCard(
                          title: 'Total Employees',
                          count: "${controller.aData['total'] ?? "--"}".obs,
                          color: Colors.blue,
                          icon: Icons.people,
                          onTap: () {
                            Get.to(() => EmployeeDirectory(), arguments: {
                              "type": "all",
                              "branch_id": controller.selectedBranch.value
                            });
                          }),
                      SizedBox(height: 12),
                      InfoCard(
                        title: 'Present Employees',
                        onTap: () {
                          Get.to(() => EmployeeDirectory(), arguments: {
                            "type": "present",
                            "branch_id": controller.selectedBranch.value
                          });
                        },
                        count: "${controller.aData['presentCount'] ?? "--"}".obs,
                        color: Colors.green,
                        icon: Icons.verified,
                      ),
                      SizedBox(height: 12),
                      InfoCard(
                        title: 'Total Students',
                        count: "${controller.studentAttendanceData['total']}".obs,
                        color: Colors.deepPurple,
                        icon: Icons.school,
                      ),
                      SizedBox(height: 12),
                      InfoCard(
                        title: 'Present Students',
                        count:
                        "${controller.studentAttendanceData['presentCount']}"
                            .obs,
                        color: Colors.orange,
                        icon: Icons.check_circle,
                      ),
                      SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 48,
                        width: MediaQuery.of(context).size.width,

                        child: MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          color: Colors.black,
                          onPressed: () {
                          Get.to(()=>EventCircularScreen());
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Upload Event/Circular",
                                style: AppTextStyles.heading(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 48,
                        width: MediaQuery.of(context).size.width,

                        child: MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          color: Colors.black,
                          onPressed: () {

                            Get.to(()=>Getevents());
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.view_comfy_alt,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "View Events/Circular",
                                style: AppTextStyles.heading(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 48,
                        width: MediaQuery.of(context).size.width,

                        child: MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                          color: Colors.black,
                          onPressed: () {

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MyCamera(onDataReceived: _myCallback),
                              ),
                            );
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.center_focus_strong_rounded,
                                color: Colors.white,
                                size: 25,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Mark Attendance",
                                style: AppTextStyles.heading(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 40,),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dashboardHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Icon(Icons.notifications_none),
              SizedBox(width: 12),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.black),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget revenueCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildRevenueCard(
          title: "Total Amount",
          amount: "₹ ${controller.feeReceiptData.value}".obs,
          percentage: "+28%",
          bgColor: Color(0xffe1e8f9),
          subtitle: "From last week",
        ),
        _buildRevenueCard(
          title: "Expenditure",
          amount: "₹ ${controller.expenditureData.value}".obs,
          percentage: "+15%",
          bgColor: Color(0xfff8e2ee),
          subtitle: "From last week",
        ),
      ],
    );
  }

  Widget _buildRevenueCard({
    required String title,
    required RxString amount,
    required String percentage,
    required String subtitle,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/debitted-amount.png',
                  height: 20,
                  width: 20,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(title,
                    style:
                        AppTextStyles.body(fontSize: 14.0, color: Colors.black)
                            .copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(height: 8),
            Obx(() => Text(amount.value,
                style: AppTextStyles.heading(
                    fontSize: 18.0, color: Colors.black))),
            SizedBox(height: 4),
            Text(
              "• From Last year",
              style: AppTextStyles.body(fontSize: 12.0, color: Colors.grey)
                  .copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget InfoCard({
    required String title,
    required RxString count,
    required Color color,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body().copyWith(
                    fontSize: 14,
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                      count.value.toString(),
                      style: AppTextStyles.heading().copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    )),
              ],
            ),
          ],
        ),
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
