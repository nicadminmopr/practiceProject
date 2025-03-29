import 'dart:convert';

import 'package:get/get.dart';
import 'package:practiceproject/utils/singleton.dart';
import 'package:http/http.dart' as http;

class ViewMyAttendanceController extends GetxController {

  RxBool loading  = false.obs;
  RxMap attendanceData = {}.obs;
  getAttendance() async {
    loading.value = true;
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/w/v1/employeeAttendance'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      var d = await response.stream.bytesToString();
      var r = jsonDecode(d);
      attendanceData.value = r;
    } else {
      loading.value = false;
      attendanceData.value.clear();

    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getAttendance();
  }
}
