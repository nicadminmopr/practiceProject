import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../utils/apptextstyles.dart'; // For file handling


class UploadStudyMaterialController extends GetxController {
  var title = ''.obs;
  var description = ''.obs;
  var selectedFile = Rx<File?>(null);

  // Pick a file
  void pickFile() async {
    //FilePickerResult? result = await FilePicker.platform.pickFiles();
    var result;
    if (result != null) {
      selectedFile.value = File(result.files.single.path!);
    } else {
      Get.snackbar('Error', 'No file selected.');
    }
  }

  // Submit the form
  void uploadMaterial() {
    if (title.isEmpty || description.isEmpty || selectedFile.value == null) {
      Get.snackbar('Error', 'Please fill all the fields and upload a file.');
      return;
    }

    // Logic to upload the file (e.g., API call)
    Get.snackbar('Success', 'Study material uploaded successfully!');
  }
}

class UploadStudyMaterialScreen extends StatelessWidget {
  final UploadStudyMaterialController controller =
      Get.put(UploadStudyMaterialController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Study Material',style: AppTextStyles.body(fontSize: 15, color: Colors.black),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',labelStyle: AppTextStyles.body(fontSize: 15, color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.title.value = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',labelStyle: AppTextStyles.body(fontSize: 15, color: Colors.black),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => controller.description.value = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: controller.pickFile,
                      icon: Icon(Icons.upload_file),
                      label: Text('Select File',style: AppTextStyles.body(fontSize: 15, color: Colors.black),),
                    ),
                    SizedBox(height: 8),
                    Text(
                      controller.selectedFile.value != null
                          ? 'Selected File: ${controller.selectedFile.value!.path.split('/').last}'
                          : 'No file selected',
                      style: AppTextStyles.body(fontSize: 15, color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: MaterialButton(color: Colors.black,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      controller.uploadMaterial();
                    }
                  },
                  child: Text('Upload Material',style: AppTextStyles.body(fontSize: 15, color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: UploadStudyMaterialScreen(),
  ));
}
