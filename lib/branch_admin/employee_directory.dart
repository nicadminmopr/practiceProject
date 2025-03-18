import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:practiceproject/utils/apptextstyles.dart';
import 'package:practiceproject/utils/custom_appbar.dart';
import 'package:http/http.dart' as http;

import '../utils/Base64Image.dart';
import '../utils/singleton.dart';

class EmployeeDirectory extends StatefulWidget {
  const EmployeeDirectory({super.key});

  @override
  State<EmployeeDirectory> createState() => _EmployeeDirectoryState();
}

class _EmployeeDirectoryState extends State<EmployeeDirectory> {
  RxList data = [].obs;
  RxBool loading = false.obs;
  RxString type = ''.obs;

  Future getAllEmployeeData(branch_id) async {
    loading.value = true;
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/employeeData/branchWiseEmployee/1'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      var d = await response.stream.bytesToString();
      var re = jsonDecode(d);
      data.value = re;
      log('Data: ${data.value}');
    } else {
      loading.value = false;
      print(response.reasonPhrase);
    }
  }

  Future getAllEmployeeDataPresent(branch_id) async {
    loading.value = true;
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/r/v1/employeeAttendanceData/todayData/1'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      var d = await response.stream.bytesToString();
      var re = jsonDecode(d);
      data.value = re;
      log('Data: ${data.value}');
    } else {
      loading.value = false;
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    callingFun();
  }

  callingFun() async {
    var a = Get.arguments;
    if (a['type'] == 'present') {
      type.value = 'present';
      getAllEmployeeDataPresent(a['branch_id'] ?? '1');
    } else if (a['type'] == 'all') {
      type.value = 'all';
      getAllEmployeeData(a['branch_id'] ?? '1');
    } else {
      type.value = 'all';
      getAllEmployeeData(a['branch_id'] ?? '1');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Employees List'),
      body: Obx(() => !loading.value
          ? data.isNotEmpty
              ? ListView.separated(
                  padding: EdgeInsets.only(top: 20.0),
                  itemCount: data.length,
                  itemBuilder: (context, int index) {
                    var d = data[index];

                    return (type.value == 'all')
                        ? ListTile(
                            leading: Image.asset(
                              'assets/profile.png',
                              height: 35,
                              width: 35,
                            ),
                            title: Text(
                              data[index]['value'],
                              style: AppTextStyles.body(
                                  color: Colors.black, fontSize: 14),
                            ),
                          )
                        : (type.value == 'present')
                            ? Container(
                                margin: EdgeInsets.symmetric(horizontal: 15),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                  ),
                                  elevation: 4, // Shadow effect
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        // Circular photo
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: MemoryImage(
                                              base64Decode(d['inPhoto'])),
                                        ),
                                        const SizedBox(width: 16),

                                        // Name, In Time, Out Time, Date
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                d['name'],
                                                style: AppTextStyles.heading(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "In Time:  ",
                                                      style: AppTextStyles.body(
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                    TextSpan(
                                                      text:formatTime (d['inTime']),
                                                      style: AppTextStyles.heading(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                text: TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: "Out Time:  ",
                                                      style: AppTextStyles.body(
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                    TextSpan(
                                                      text:formatTime (d['outTime']),
                                                      style: AppTextStyles.heading(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "Date: ${d['date']}",
                                                style: AppTextStyles.body(
                                                    color: Colors.blueAccent,
                                                    fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox();
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                )
              : Center(
                  child: Text('No Data Available'),
                )
          : Center(
              child: CupertinoActivityIndicator(),
            )),
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
