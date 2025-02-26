import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/custom_appbar.dart';
import 'package:http/http.dart' as http;

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  RxString title = ''.obs;
  RxString url = ''.obs;

  getData(url) async {
    var headers = {
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJBTlUiLCJ1c2VyUmVzcG9uc2UiOnsidXNlcm5hbWUiOiJBTlUiLCJ1c2VyVXVpZCI6IjRiZTY4M2Q1LWVhNWItNGYwNC1iYTg4LWFmYzVlNWEyZjUwMyIsInJvbGVJZCI6MTksIm5hbWUiOiJBbnVyYWRoYSBTaW5naCIsImRlc2lnbmF0aW9uIjoiVGVhY2hlciIsImlzU2VjdGlvbiI6ZmFsc2V9LCJzdWIiOiI0YmU2ODNkNS1lYTViLTRmMDQtYmE4OC1hZmM1ZTVhMmY1MDMiLCJpYXQiOjE3NDA0ODMxNTEsImV4cCI6MTc0MDU2OTU1MX0.Y6vX2YDgtevUQ6DrT94BGaJqQr4hSQp7gShBOQoTYGCPQXkRZyfkQgOZEc3kN_IrTAOV3-fLfZWrdgwHJQXrjg'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '$url'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeF();
  }

  changeF() {
    var body = Get.arguments;
    log('body : ${body}');
    if (body['title'] == 'See Classwork') {
      setState(() {
        title.value = 'Assignment';
        url.value =' http://147.79.66.224/madminapi/private/v1/r/classworkData/${body['subjectId'].toString()}/${body['classId'].toString()}/0';

      });
    } else if (body['title'] == 'See Homework') {
      setState(() {
        title.value = 'Homework';
        url.value = 'http://147.79.66.224/madminapi/private/v1/r/homeworkData/${body['subjectId'].toString()}/${body['classId'].toString()}/0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title.value),
      backgroundColor: Colors.white,
    );
  }
}
