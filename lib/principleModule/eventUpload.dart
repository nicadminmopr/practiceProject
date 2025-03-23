import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practiceproject/utils/apptextstyles.dart';
import 'package:practiceproject/utils/custom_appbar.dart';

import 'eventUploadController.dart';

class EventCircularScreen extends StatelessWidget {
  final EventCircularController controller = Get.put(EventCircularController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Upload Section"),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown for selecting Event or Circular
                  Obx(() => DropdownButton<String>(isExpanded: true,
                    value: controller.selectedValue.value,
                    onChanged: (String? newValue) {
                      controller.updateSelectedValue(newValue!);
                    },
                    items: <String>['Event', 'Circular']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: AppTextStyles.heading(fontSize: 15),),
                      );
                    }).toList(),
                  )),

                  SizedBox(height: 20),

                  // Title TextField
                  TextFormField(
                    controller: controller.titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field Cannot be Empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                    onChanged: (value) {
                      controller.updateTitle(value);
                    },
                  ),

                  SizedBox(height: 20),

                  // Content TextField
                  TextFormField(
                    controller: controller.contentController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Field Cannot be Empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Content',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                    onChanged: (value) {
                      controller.updateContent(value);
                    },
                  ),
                ],
              ),
              key: controller.formkey,
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
      // Full-width Submit Button at the bottom
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity, // Full width
          child: MaterialButton(
            color: Colors.black,
            height: 48,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            onPressed: () {
              if (controller.formkey.currentState!.validate()) {
                var body = {
                  "title": controller.titleController.text,
                  "content": controller.contentController.text,
                };
                if (controller.selectedValue.value == 'Event') {
                  controller.postCircular(
                      body, "http://147.79.66.224/madminapi/private/v1/events");
                } else if (controller.selectedValue.value == 'Circular') {
                  controller.postCircular(body,
                      "http://147.79.66.224/madminapi/private/v1/circular");
                }
              }
            },
            child: Text(
              'Submit',
              style: AppTextStyles.body(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
