import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:practiceproject/utils/singleton.dart';

import 'getEvents.dart';
import 'package:http/http.dart' as http;

class GetEventController extends GetxController {
  var selectedType = 'Event'.obs; // Observable variable for dropdown value
  var data = [].obs;
  var loading = false.obs;

  getData(String url) async {
    data.value.clear();
    data.value = [];
    loading.value = true;
    var headers = {
      'accept': '*/*',
      'Authorization': 'Bearer ${AuthManager().authToken}'
    };
    var request = http.Request('GET', Uri.parse(url));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    log("${response.statusCode}");
    if (response.statusCode == 200) {
      loading.value = false;
      var d = await response.stream.bytesToString();
      var dd = jsonDecode(d);
      data.value = dd;
      log('Data ${data.value}');
    } else {
      data.value.clear();
      data.value = [];
      loading.value = false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData("http://147.79.66.224/madminapi/private/v1/events");
  }
}
