import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
    log('Subject Name : ${Get.arguments['subjectName']}');
    return Scaffold(
      appBar: CustomAppBar(title: title.value),
      backgroundColor: Colors.white,
      body: Obx(() => !loading.value
          ? screenData.value.isNotEmpty &&
                  screenData.value['workTitle'] != null &&
                  screenData.value['workContent'] != null
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10),
                          child: Text(
                            '${Get.arguments['subjectName'] ?? "Subject"}',
                            style: AppTextStyles.heading(
                                color: Colors.white, fontSize: 14),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0))),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Title: ',
                                    style: GoogleFonts.montserrat(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                TextSpan(
                                    text: screenData.value['workTitle'] ?? "",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ])),
                              SizedBox(
                                height: 8,
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Description: ',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                        text: screenData.value['workContent'] ?? "",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ])),

                              SizedBox(
                                height: 8,
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Date: ',
                                        style: GoogleFonts.montserrat(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    TextSpan(
                                        text: DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                            screenData.value['classworkDate'] ??
                                                DateTime.now().toString())),
                                        style: GoogleFonts.montserrat(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ])),

                            ],
                          ),
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.0,
                              spreadRadius: 1.0,
                              offset: Offset(1.0, 1.0))
                        ]),
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
