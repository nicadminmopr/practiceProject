import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard_screen.dart';
import '../main.dart';
import '../utils/storage_service.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  var isLoading = false.obs;
  var email = ''.obs;
  var password = ''.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final StorageService storageService = StorageService();
  UserRole role = UserRole.classTeacher;

  void login(body) async {
    isLoading.value = true;
    // Simulate a network call
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;
    if (body['username'] == 'schoolAdmin') {
      await storageService.write('userType', 'schoolAdmin');
      Get.to(() => DashboardScreen());
    } else if (body['username'] == 'branchAdmin') {
      await storageService.write('userType', 'branchAdmin');
      Get.to(() => DashboardScreen());
    } else if (body['username'] == 'teacher') {
      await storageService.write('userType', 'teacher');
      Get.to(() => DashboardScreen());
    } else if (body['username'] == 'classTeacher') {
      await storageService.write('userType', 'classTeacher');
      Get.to(() => DashboardScreen());
    }

    Get.snackbar('Login', 'Login successful', snackStyle: SnackStyle.GROUNDED);
  }

  loginFunction(body) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST',
        Uri.parse('http://147.79.66.224/madminapi/publicApi/v1/auth/login'));
    request.body = json.encode(body);
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      isLoading.value = false;
      var responseApi = jsonDecode(await response.stream.bytesToString());
      if (responseApi['designation'] == 'Teacher') {
        await storageService.write('userType', 'teacher');
        await storageService.write('name', responseApi['name'].toString());
      }
      Get.to(() => DashboardScreen());
      log('Response $responseApi');
    } else {
      isLoading.value = false;
      log(response.reasonPhrase.toString());
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('Something went wrong')));
    }
  }
}
