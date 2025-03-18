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

import '../../utils/apptextstyles.dart';
import 'package:http/http.dart' as http;

import '../../utils/singleton.dart';
// For formatting date and time

class MarkAttendanceController extends GetxController {
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

  markAttendanceFunction() async {
    loading.value = true;
    List<int> imageBytes = await File(selfieImage.value).readAsBytes();
    String base64Image = base64Encode(imageBytes);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer ${AuthManager().getAuthToken()}'
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
    var d = jsonDecode(await response.stream.bytesToString());
    log('Message ${d['message']}');
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
  showConfirmationPopup(BuildContext context) {
    String currentDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Attendance"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Date & Time: $currentDateTime",style: AppTextStyles.heading(fontSize: 15, color: Colors.black),),
              SizedBox(height: 10),
              Text("I confirm the data provided by me is correct.",style: AppTextStyles.body(fontSize: 15, color: Colors.black),),


            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Mark Attendance"),
            ),
          ],
        );
      },
    );
  }
}

class MarkAttendanceBranchAdminScreen extends StatelessWidget {
  final MarkAttendanceController controller = Get.put(
    MarkAttendanceController(),
  );
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mark My Attendance',
          style: AppTextStyles.heading(fontSize: 15, color: Colors.black),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${controller.currentDate.value}',
                        style: AppTextStyles.heading(
                            fontSize: 15, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Time: ${controller.currentTime.value}',
                        style: AppTextStyles.heading(
                            fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                /*Obx(
                  () => controller.selfieImage.value.isNotEmpty
                      ? Center(
                          child: ClipOval(
                            child: Image.file(
                              File(
                                controller.selfieImage.value,
                              ),
                              height: 120,
                              width: 120,
                            ),
                          ),
                        ) // Show captured selfie
                      : Center(
                          child: IconButton(
                            icon: Icon(Icons.person,
                                size: 100, color: Colors.grey),
                            onPressed: () {
                              controller.takeSelfie();
                            },
                          ),
                        ),
                ),*/

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(()=>Checkbox(
                      value: controller.isChecked.value,
                      onChanged: (bool? value) {
                        if(value!){
                          //controller.showConfirmationPopup(Get.context!);

                        }
                        controller.isChecked.value = value ?? false;

                      },
                    )),
                    Text("I confirm my attendance."),
                  ],
                ),
                /*Center(
                  child: MaterialButton(
                    color: Colors.green,
                    onPressed: () {
                      if (controller.lat.value.isNotEmpty &&
                          controller.long.value.isNotEmpty) {
                        if (controller.selfieImage.value.isNotEmpty) {
                          controller.markAttendanceFunction();
                        } else {
                          ScaffoldMessenger.of(Get.context!).showSnackBar(
                              SnackBar(content: Text('Image is mandatory')));
                        }
                      } else {
                        ScaffoldMessenger.of(Get.context!).showSnackBar(
                            SnackBar(content: Text('Location is mandatory')));
                      }
                    },
                    child: Text(
                      'Mark Attendance',
                      style:
                          AppTextStyles.body(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          Obx(() => controller.loading.value
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade300.withOpacity(0.7),
                  child: Center(
                    child: CupertinoActivityIndicator(),
                  ),
                )
              : SizedBox())
        ],
      ),
    );
  }


}
