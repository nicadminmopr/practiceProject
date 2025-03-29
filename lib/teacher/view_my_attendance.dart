import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:practiceproject/teacher/view_my_attendance_controller.dart';
import 'package:practiceproject/utils/custom_appbar.dart';
import 'package:get/get.dart';
import '../utils/apptextstyles.dart';

class ViewMyAttendance extends StatelessWidget {
  final controller = Get.put(ViewMyAttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Attendance Logs"),
      body: Column(
        children: [
          Obx(() => !controller.loading.value
              ? controller.attendanceData.isNotEmpty?
          Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    elevation: 4, // Shadow effect
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            controller.attendanceData['name'],
                            style: AppTextStyles.heading(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(
                            "Date: ${controller.attendanceData['date']}",
                            style: AppTextStyles.body(
                                    color: Colors.black, fontSize: 13)
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Divider(),
                          // Details in rows
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      formatTime(
                                          controller.attendanceData['inTime']),
                                      style: AppTextStyles.heading(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.login,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text("In Time",
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600))
                                        ],
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Color(0xff0368ff),
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      formatTime(
                                          controller.attendanceData['outTime']),
                                      style: AppTextStyles.heading(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.login,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5.0,
                                          ),
                                          Text("Out Time",
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600))
                                        ],
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Color(0xff0368ff),
                                          borderRadius:
                                              BorderRadius.circular(25.0)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Date
                        ],
                      ),
                    ),
                  ),
                ):Center(child: Text("No Attendance Available"),)
              : Center(
                  child: CupertinoActivityIndicator(),
                ))
        ],
      ),
    );
  }

  String formatTime(String time) {
    try {
      final parsedTime = DateFormat("HH:mm:ss.SSS").parse(time);
      return DateFormat("hh:mm a").format(parsedTime); // Converts to AM/PM
    } catch (e) {
      return time; // Fallback if parsing fails
    }
  }
}
