import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../utils/apptextstyles.dart'; // For formatting date and time

class MarkAttendanceController extends GetxController {
  var currentTime = ''.obs;
  var currentDate = ''.obs;
  var remark = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateDateTime();
  }

  // Update date and time
  void updateDateTime() {
    final now = DateTime.now();
    currentDate.value = DateFormat('yyyy-MM-dd').format(now);
    currentTime.value = DateFormat('hh:mm a').format(now);
  }

  // Submit attendance
  void markAttendance() {
    if (remark.value.isEmpty) {
      Get.snackbar('Error', 'Please enter a remark.');
      return;
    }
    // Save attendance logic here (e.g., API call or database)
    Get.snackbar('Success', 'Attendance marked successfully!');
  }
}

class MarkAttendanceScreen extends StatelessWidget {
  final MarkAttendanceController controller = Get.put(MarkAttendanceController(),);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark My Attendance',style: AppTextStyles.heading(fontSize: 15, color: Colors.black),),
      ),
      body: Padding(
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
                    style: AppTextStyles.heading(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Time: ${controller.currentTime.value}',
                    style: AppTextStyles.heading(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Remark',
                  hintText: 'Enter a remark (e.g., Work from home)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.remark.value = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a remark.';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: MaterialButton(color: Colors.green,
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.markAttendance();
                  }
                },
                child: Text('Mark Attendance',style: AppTextStyles.body(fontSize: 15, color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: MarkAttendanceScreen(),
  ));
}
