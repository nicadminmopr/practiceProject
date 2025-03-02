import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:practiceproject/teacher/students/student_list_teacher_screen.dart';
import 'package:practiceproject/teacher/subject_teacher_screen.dart';
import 'package:practiceproject/teacher/upload_section/upload_screen.dart';

import '../utils/custom_appbar.dart';
import '../utils/singleton.dart';

class ClasslistTeacherScreen extends StatefulWidget {
  String onEvent;

  ClasslistTeacherScreen({required this.onEvent});

  @override
  State<ClasslistTeacherScreen> createState() => _ClasslistTeacherScreenState();
}

class _ClasslistTeacherScreenState extends State<ClasslistTeacherScreen> {
  final List<String> classNames = ['1', '2', '3', '4', '5', '6'];

  RxList classList = [].obs;
  RxBool loading = false.obs;

  Future getClasses() async {
    loading.value = true;
    var headers = {
      'Authorization':
          'Bearer ${AuthManager().getAuthToken()}'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/classTeacherData/getAssignedClasses'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      var r = await response.stream.bytesToString();
      var d = jsonDecode(r);

      classList.value = d;
    } else {
      loading.value = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClasses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Classes'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                hintText: 'Search by class, section, or student name',
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade50),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade50),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade50),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() => !loading.value
                  ? classList.value.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Number of columns
                            crossAxisSpacing: 16, // Space between columns
                            mainAxisSpacing: 16, // Space between rows
                          ),
                          itemCount: classList.value.length,
                          itemBuilder: (context, index) {
                            final className = classList.value[index];
                            return GestureDetector(
                              onTap: () {
                                //widget.onTap();
                                if (widget.onEvent ==
                                    'Mark Students Attendance') {
                                  Get.to(() => StudentListTeacherScreen(),
                                      arguments: {
                                        'className': className['value'],
                                        'classId': className['code'].toString()
                                      });
                                } else {
                                  Get.to(() => SubjectTeacherScreen(onEvent: widget.onEvent,),
                                      arguments: {
                                        'className': className['value'],
                                        'classId': className['code'].toString(),
                                        'title': widget.onEvent.toString()
                                      });

                                  /*Get.to(() => UploadScreen(title: 'Upload Homework',),arguments: {

                                  });*/
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 40,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.7),
                                      child: Text(
                                        className['value'],
                                        style: GoogleFonts.montserrat(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Class ${className['value']}',
                                      style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text('No Data Available'),
                        )
                  : Center(
                      child: CupertinoActivityIndicator(),
                    )),
            ),
          ],
        ),
      ),
    );
  }
}
