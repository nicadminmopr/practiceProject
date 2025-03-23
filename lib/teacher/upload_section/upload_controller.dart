import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../../dashboard_screen.dart';
import '../../utils/apptextstyles.dart';
import '../../utils/singleton.dart';

class UploadController extends GetxController {
  var titleController = TextEditingController();
  var contentController = TextEditingController();
  var lastDate = ''.obs;
  RxBool loading = false.obs;

  void pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)), // Future dates only
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      lastDate.value = DateFormat('yyyy-MM-dd').format(pickedDate);
    }
  }

  Future<void> pasteFromClipboard(TextEditingController controller) async {
    ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      controller.text = data.text!;
    }
  }

  void submitHomework() {
    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('All Fields are mandatory')));

      return;
    }
    if (Get.arguments['title'] != 'Upload Classwork') {
      if (lastDate.value.isEmpty) {
        ScaffoldMessenger.of(Get.context!)
            .showSnackBar(SnackBar(content: Text('Select Last Date')));
        return;
      }
    }

    if (Get.arguments['title'] == 'Upload Homework') {
      var body = {
        "classId": Get.arguments['classId'].toString(),
        "subjectId": Get.arguments['subjectId'].toString(),
        "workSubmissionDate": lastDate.value,
        "workTitle": titleController.text,
        "workContent": contentController.text
      };
      log('Body Printed: ${jsonEncode(body)}');
      String url = 'http://147.79.66.224/madminapi/private/v1/homework';
      uploadWork(url, body);
    } else if (Get.arguments['title'] == 'Upload Classwork') {
      var body = {
        "classId": Get.arguments['classId'].toString(),
        "subjectId": Get.arguments['subjectId'].toString(),
        "sectionId": null,
        "workTitle": titleController.text,
        "workContent": contentController.text
      };
      log('Body Printed: ${jsonEncode(body)}');
      String url = 'http://147.79.66.224/madminapi/private/v1/classwork';
      uploadWork(url, body);
    } else if (Get.arguments['title'] == 'Upload Assignment') {
      var body = {
        "classId": Get.arguments['classId'].toString(),
        "subjectId": Get.arguments['subjectId'].toString(),
        "workSubmissionDate": lastDate.value,
        "workTitle": titleController.text,
        "workContent": contentController.text
      };
      log('Body Printed: ${jsonEncode(body)}');
      String url = 'http://147.79.66.224/madminapi/private/v1/assignment';
      uploadWork(url, body);
    }
  }

  uploadWork(url, body) async {
    log('Body ${jsonEncode(body)}');
    log('Url ${url}');
    log('Header ${AuthManager().getAuthToken()}');
    loading.value = true;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${AuthManager().getAuthToken()}'
    };
    var request = http.Request('POST', Uri.parse('$url'));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('Added Successfully')));
      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/checkmark.png',
                height: 100,
                color: Colors.green,
              ),
              // Add an image in assets folder
              SizedBox(height: 10),
              Text(
                "Added Successfully",
                style: AppTextStyles.heading(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              MaterialButton(
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onPressed: () {
                  Get.offAll(() => DashboardScreen());
                },
                child:
                    Text("Back to Home", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    } else {
      loading.value = false;
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }
}
