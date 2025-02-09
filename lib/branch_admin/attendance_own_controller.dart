import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:practiceproject/utils/apptextstyles.dart';

class AttendanceOwnController extends GetxController {
  var currentTime = ''.obs;
  var currentDate = ''.obs;
  var remark = ''.obs;
  RxString lat = ''.obs;
  RxString long = ''.obs;
  RxBool loading = false.obs;

  RxString selfieImage = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // Function to capture selfie
  Future<void> takeSelfie() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front, // Use front camera
    );

    if (image != null) {
      selfieImage.value = image.path;
    }
  }

  @override
  void onInit() {
    super.onInit();
    updateDateTime();
    fetchLocation();
  }

  // Update date and time
  void updateDateTime() {
    final now = DateTime.now();
    currentDate.value = DateFormat('yyyy-MM-dd').format(now);
    currentTime.value = DateFormat('hh:mm a').format(now);
  }

  // Submit attendance
  void markAttendance() {
    if (remark.value.isEmpty) {
      Get.snackbar('Error', 'Please enter a remark.');
      return;
    }
    // Save attendance logic here (e.g., API call or database)
    Get.snackbar('Success', 'Attendance marked successfully!');
  }

  void fetchLocation() async {
    try {
      Position position = await getCurrentLocation();
      lat.value = position.latitude.toString();
      long.value = position.longitude.toString();
      log("Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    } catch (e) {
      log("Error: $e");
    }
  }

  RxBool isChecked = false.obs;

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check and request permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

//TODO: New Code
  Future<Position?> getLocation() async {
    final PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.status;
    if (permissionStatus == PermissionStatus.granted) {
      return await Geolocator.getCurrentPosition();
    } else if (permissionStatus == PermissionStatus.denied) {
      final result = await showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Location Permission'),
          content: Text('Near by location'),
          actions: [
            TextButton(
              child: Text('cancel'),
              onPressed: () => Navigator.pop(context, false),
            ),
            TextButton(
              child: Text('okay'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
      if (result == true) {
        final newPermissionStatus =
            await Permission.locationWhenInUse.request();
        if (newPermissionStatus == PermissionStatus.granted) {
          return await Geolocator.getCurrentPosition();
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final result = await showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
          title: Text('Location Permission'),
          content: const Text(
              'To show nearby places, we need your location. Please go to app settings and grant location permission.'),
          actions: [
            TextButton(
              child: Text('Okay'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      await openAppSettings();
      return null;
    } else {
      final newPermissionStatus = await Permission.locationWhenInUse.request();
      if (newPermissionStatus == PermissionStatus.granted) {
        return await Geolocator.getCurrentPosition();
      } else {
        return null;
      }
    }
  }

  Future<bool> requestLocationPermission() async {
    RxBool v = false.obs;
    var status = await Permission.location.request();
    log('Status: $status');
    if (status.isGranted) {
      v.value = true;
      // Location permission is granted, proceed with location services.
    } else if (status.isDenied) {
      v.value = false;
      // Handle the case when permission is denied.
    }
    return v.value;
  }

  markAttendanceFunction(image) async {
    loading.value = true;
    List<int> imageBytes = await File(image).readAsBytes();
    String base64Image = base64Encode(imageBytes);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJhbGciOiJIUzUxMiJ9.eyJqdGkiOiJBTlUiLCJ1c2VyUmVzcG9uc2UiOnsidXNlcm5hbWUiOiJBTlUiLCJ1c2VyVXVpZCI6IjQ1ZWVmZWViLWM5Y2QtNDBiZi04MGYyLWNmNzkxNDdiNTUyOSIsInJvbGVJZCI6MTksIm5hbWUiOiJBbnVyYWRoYSBTaW5naCIsImRlc2lnbmF0aW9uIjoiVGVhY2hlciIsImlzU2VjdGlvbiI6ZmFsc2V9LCJzdWIiOiI0NWVlZmVlYi1jOWNkLTQwYmYtODBmMi1jZjc5MTQ3YjU1MjkiLCJpYXQiOjE3Mzg0OTU5MzcsImV4cCI6MTczODU4MjMzN30.liXJzLCGLAJiYhR4QARsM3vUspWGGLly2_HMU-YQgR9eilQ-vGjUQfAStdN8fNj9Riq9jfEEMYzq5ENIS0IE0A'
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'http://147.79.66.224/madminapi/private/w/v1/employeeAttendance'));

    request.body = json.encode(
        {"longitude": lat.value, "latitude": long.value, "photo": base64Image});
    log('Body ${request.body}');
    request.headers.addAll(headers);
    log('Headers ${request.headers}');
    http.StreamedResponse response = await request.send();
    log('Code ${response.statusCode.toString()}');
    if (response.statusCode == 200) {
      loading.value = false;
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text('Marked Successfully')));
    } else {
      loading.value = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
          content: Text('Image size too big . Increase Size at server side')));
    }
  }


}
