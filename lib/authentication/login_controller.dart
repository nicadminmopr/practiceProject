import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../dashboard_screen.dart';
import '../main.dart';
import '../utils/singleton.dart';
import '../utils/storage_service.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var email = ''.obs;
  var password = ''.obs;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final StorageService storageService = StorageService();
  UserRole role = UserRole.classTeacher;
  RxBool showPassword = true.obs;

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
      if (responseApi['roleId'].toString() == '19') {

        await storageService.write('userType', 'teacher');
      } else if (responseApi['roleId'].toString() == '3') {

      } else if (responseApi['roleId'].toString() == '2') {

      }

      await storageService.write('name', responseApi['name'].toString());
      await storageService.write('roleId', responseApi['roleId'].toString());
      AuthManager().setRoleId(responseApi['roleId'].toString());
      Map<String, String> headers = response.headers;

      print('Response Headers:');
      headers.forEach((key, value) {
        log('$key: $value');
      });
      log('header going to save is ${response.headers['authorization']}');
      await storageService.write('token', response.headers['authorization']);
      AuthManager().setAuthToken(response.headers['authorization'].toString());
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
