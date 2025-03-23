// Importing necessary packages
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:practiceproject/utils/apptextstyles.dart';

import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Image.asset(
              'assets/backgroundimage.avif',
              height: height,
              width: width,
              fit: BoxFit.fill,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.12),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1.0,
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 1)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Column(
                          children: [

                            SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              'assets/8030890.png',
                              height: height * 0.18,fit: BoxFit.cover,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: controller.emailController,
                              onChanged: (value) =>
                                  controller.email.value = value,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username cannot be empty';
                                } else if (value.length < 2) {
                                  return 'Username cannot be less than 2 characters';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.supervised_user_circle,
                                    size: 25,
                                    color: Colors.black,
                                  ),
                                  labelText: 'Username',
                                  labelStyle: AppTextStyles.body(
                                      fontSize: 14.0, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  )),
                            ),
                            SizedBox(height: 16),
                            Obx(() => TextFormField(
                                  controller: controller.passwordController,
                                  onChanged: (value) =>
                                      controller.password.value = value,
                                  obscureText: controller.showPassword.value,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Password cannot be empty';
                                    } else if (value.length < 2) {
                                      return 'value cannot be less than 2 characters';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.password,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          controller.showPassword.value =
                                              !controller.showPassword.value;
                                          log('Value ${controller.showPassword.value}');
                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: Obx(
                                            () => controller.showPassword.value
                                                ? Icon(
                                                    Icons.lock,
                                                    color: Colors.black,
                                                    size: 25.0,
                                                  )
                                                : Icon(
                                                    Icons.lock_open_outlined,
                                                    color: Colors.black,
                                                    size: 25.0,
                                                  )),
                                      ),
                                      labelText: 'Password',
                                      labelStyle: AppTextStyles.body(
                                          fontSize: 14.0, color: Colors.black),
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      )),
                                )),
                            SizedBox(height: 24),
                            Obx(() => Container(
                                  height: 48.0,
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  width: double.infinity,
                                  child: MaterialButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0)),
                                    onPressed: () {
                                      /* controller.login({
                      "username": controller.emailController.text,
                      'password': controller.passwordController.text
                    });*/
                                      if (formKey.currentState!.validate()) {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        var body = {
                                          "username":
                                              controller.emailController.text,
                                          "password":
                                              controller.passwordController.text
                                        };
                                        controller.loginFunction(body);
                                      }
                                    },
                                    color: Colors.black,
                                    textColor: Colors.white,
                                    disabledColor: Colors.grey,
                                    child: controller.isLoading.value
                                        ? CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            'Login',
                                            style: AppTextStyles.heading(
                                                fontSize: 15.0,
                                                color: Colors.white),
                                          ),
                                  ),
                                )),
                            SizedBox(height: 24),
                          ],
                        ),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    home: LoginScreen(),
  ));
}
