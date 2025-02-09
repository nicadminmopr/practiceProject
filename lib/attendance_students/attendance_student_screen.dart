import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/apptextstyles.dart';

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
class AttendanceScreen extends StatelessWidget {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mark Attendance',style: AppTextStyles.heading(fontSize: 15, color: Colors.black),),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
                  () => ListView.builder(
                itemCount: controller.students.length,
                itemBuilder: (context, index) {
                  final student = controller.students[index];
                  return Card(color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      title: Text(student.name,style: AppTextStyles.heading(fontSize: 15, color: Colors.black),),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Present',style: AppTextStyles.body(fontSize: 15, color: Colors.black),),
                              value: 'Present',
                              groupValue: student.attendance,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.updateAttendance(student.id, value);
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<String>(
                              title: Text('Absent',style: AppTextStyles.body(fontSize: 15, color: Colors.black),),
                              value: 'Absent',
                              groupValue: student.attendance,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.updateAttendance(student.id, value);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(color: Colors.black,height: 48,minWidth: 300.0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
              onPressed: controller.saveAttendance,
              child: Text('Save Attendance',style: AppTextStyles.heading(fontSize: 15, color: Colors.white),),
            ),
          ),
          SizedBox(height: 20.0,)
        ],
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: AttendanceScreen(),
  ));
}
