import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/apptextstyles.dart';
import 'attendance_own_controller.dart';
import 'camera_screen.dart';

class AttendanceOwn extends StatefulWidget {
  const AttendanceOwn({super.key});

  @override
  State<AttendanceOwn> createState() => _AttendanceOwnState();
}

class _AttendanceOwnState extends State<AttendanceOwn> {
  final controller = Get.put(AttendanceOwnController());

  void _myCallback(String message) {
    log('Callback received: $message');
    setState(() {
      _callbackMessage = message;
    });

    if (controller.lat.value.isNotEmpty &&
        controller.long.value.isNotEmpty) {
      controller
          .markAttendanceFunction(_callbackMessage);
    } else {
      controller.fetchLocation();
      ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
              content: Text('Location is mandatory')));
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mark My Attendance',
          style: AppTextStyles.heading(fontSize: 15, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${controller.currentDate.value}',
                        style: AppTextStyles.heading(
                            fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Time: ${controller.currentTime.value}',
                        style: AppTextStyles.heading(
                            fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                /*Obx(
                  () => controller.selfieImage.value.isNotEmpty
                      ? Center(
                          child: ClipOval(
                            child: Image.file(
                              File(
                                controller.selfieImage.value,
                              ),
                              height: 120,
                              width: 120,
                            ),
                          ),
                        ) // Show captured selfie
                      : Center(
                          child: IconButton(
                            icon: Icon(Icons.person,
                                size: 100, color: Colors.grey),
                            onPressed: () {
                              controller.takeSelfie();
                            },
                          ),
                        ),
                ),*/

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(() => Checkbox(
                          value: controller.isChecked.value,
                          onChanged: (bool? value) {
                            if (value!) {
                              //controller.showConfirmationPopup(Get.context!);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MyCamera(onDataReceived: _myCallback),
                                ),
                              );
                            }
                            controller.isChecked.value = value ?? false;
                          },
                        )),
                    Text("I confirm my attendance."),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                _callbackMessage.isNotEmpty
                    ? Center(
                        child: MaterialButton(
                          color: Colors.green,
                          onPressed: () {
                            if (controller.lat.value.isNotEmpty &&
                                controller.long.value.isNotEmpty) {
                              controller
                                  .markAttendanceFunction(_callbackMessage);
                            } else {
                              controller.fetchLocation();
                              ScaffoldMessenger.of(Get.context!).showSnackBar(
                                  SnackBar(
                                      content: Text('Location is mandatory')));
                            }
                          },
                          child: Text(
                            'Mark Attendance',
                            style: AppTextStyles.body(
                                fontSize: 15, color: Colors.white),
                          ),
                        ),
                      )
                    : SizedBox(),
                /*Center(
                  child: MaterialButton(
                    color: Colors.green,
                    onPressed: () {
                      if (controller.lat.value.isNotEmpty &&
                          controller.long.value.isNotEmpty) {
                        if (controller.selfieImage.value.isNotEmpty) {
                          controller.markAttendanceFunction();
                        } else {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                              SnackBar(content: Text('Image is mandatory')));
                        }
                      } else {
                        ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(content: Text('Location is mandatory')));
                      }
                    },
                    child: Text(
                      'Mark Attendance',
                      style:
                          AppTextStyles.body(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          Obx(() => controller.loading.value
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade300.withOpacity(0.7),
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : SizedBox())
        ],
      ),
    );
  }
}
