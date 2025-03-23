import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:practiceproject/utils/apptextstyles.dart';

import '../utils/custom_appbar.dart';
import 'package:http/http.dart' as http;

import '../utils/singleton.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  RxString title = ''.obs;
  RxString url = ''.obs;
  RxMap screenData = {}.obs;
  RxBool loading = false.obs;

  getData(url) async {
    log('called');
    loading.value = true;
    var headers = {'Authorization': 'Bearer ${AuthManager().getAuthToken()}'};
    var request = http.Request('GET', Uri.parse('$url'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    log('${response.statusCode.toString()}');
    if (response.statusCode == 200) {
      loading.value = false;

      var d = await response.stream.bytesToString();
      var dd = jsonDecode(d);
      screenData.value = dd;
      log('Screen Data${screenData.value}');
    } else {
      loading.value = false;
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
      log('1');
      setState(() {
        title.value = 'Classwork';

        url.value =
            'http://147.79.66.224/madminapi/private/v1/r/classworkData/getRecentClassWork/${body['classId'].toString()}/${body['subjectId'].toString()}/0';
      });
      getData(url.value);
    } else if (body['title'] == 'See Homework') {
      log('2');
      setState(() {
        title.value = 'Homework';
        url.value =
            'http://147.79.66.224/madminapi/private/v1/r/homeworkData/getRecentClassWork/${body['classId'].toString()}/${body['subjectId'].toString()}/0';
      });
      getData(url.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: title.value),
      backgroundColor: Colors.white,
      body: Obx(() => !loading.value
          ? screenData.value.isNotEmpty &&
                  screenData.value['workTitle'] != null &&
                  screenData.value['workContent'] != null
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Title',
                        style: AppTextStyles.body(color: Colors.grey)
                            .copyWith(fontSize: 12),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        screenData.value['workTitle'] ?? "",
                        style: AppTextStyles.body(color: Colors.black)
                            .copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Description',
                        style: AppTextStyles.body(color: Colors.grey)
                            .copyWith(fontSize: 12),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        screenData.value['workContent'] ?? "",
                        style: AppTextStyles.body(color: Colors.black)
                            .copyWith(fontSize: 14),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Date',
                        style: AppTextStyles.body(color: Colors.grey)
                            .copyWith(fontSize: 12),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                      Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.parse(
                            screenData.value['classworkDate'] ??
                                DateTime.now().toString())),
                        style: AppTextStyles.body(color: Colors.black)
                            .copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Image.asset(
                    'assets/no-data.png',
                    height: 80,
                    width: 80,
                  ),
                )
          : Center(
              child: CupertinoActivityIndicator(),
            )),
    );
  }
}
