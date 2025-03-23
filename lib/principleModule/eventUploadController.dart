import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practiceproject/utils/singleton.dart';
import 'package:http/http.dart' as http;

class EventCircularController extends GetxController {
  RxBool loading = false.obs;
  var selectedValue = 'Event'.obs; // Observable variable for dropdown value
  var title = ''.obs; // Observable variable for title
  var content = ''.obs; // Observable variable for content
  var titleError = ''.obs; // Observable variable for title error message
  var contentError = ''.obs; // Observable variable for content error message
  final formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  void updateSelectedValue(String value) {
    selectedValue.value = value;
  }

  void updateTitle(String newTitle) {
    title.value = newTitle;
    if (newTitle.isEmpty) {
      titleError.value = 'Title cannot be empty';
    } else {
      titleError.value = '';
    }
  }

  void updateContent(String newContent) {
    content.value = newContent;
    if (newContent.isEmpty) {
      contentError.value = 'Content cannot be empty';
    } else {
      contentError.value = '';
    }
  }

  bool validate() {
    if (title.value.isEmpty) {
      titleError.value = 'Title cannot be empty';
    }
    if (content.value.isEmpty) {
      contentError.value = 'Content cannot be empty';
    }
    return title.value.isNotEmpty && content.value.isNotEmpty;
  }

  Map<String, String> getBody() {
    return {
      "title": title.value,
      "content": content.value,
    };
  }

  Future<void> postCircular(body, url) async {
    loading.value = true;
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${AuthManager().getAuthToken()}'
    };
    var request = http.Request('GET', Uri.parse(url));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      loading.value = false;
      Navigator.pop(Get.context!);
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text('Uploaded Successfully'),
        backgroundColor: Colors.green,
      ));
    } else {
      loading.value = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text('Something went wrong'),
        backgroundColor: Colors.red,
      ));
    }
  }
}
