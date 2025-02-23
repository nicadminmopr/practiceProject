import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practiceproject/teacher/upload_section/upload_controller.dart';

import '../../utils/apptextstyles.dart';

class UploadScreen extends StatefulWidget {
  String title;

  UploadScreen({super.key, required this.title});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final controller = Get.put(UploadController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          widget.title,
          style: AppTextStyles.heading(fontSize: 15, color: Colors.white),
        ),
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 25.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Title Field
                  TextFormField(
                    controller: controller.titleController,
                    decoration: InputDecoration(
                        labelText: "Title",
                        labelStyle: AppTextStyles.body(),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.paste,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () => controller
                            .pasteFromClipboard(controller.titleController),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Content Field
                  TextFormField(
                    controller: controller.contentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: "Content",
                        labelStyle: AppTextStyles.body(),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.paste,
                          color: Colors.black,
                          size: 20,
                        ),
                        onPressed: () => controller
                            .pasteFromClipboard(controller.contentController),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Last Date Picker
                  widget.title!='Upload Classwork'? Obx(() => TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Last Date",
                      labelStyle: AppTextStyles.body(),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: Colors.black,
                        ),
                        onPressed: () => controller.pickDate(context),
                      ),
                    ),
                    controller:
                    TextEditingController(text: controller.lastDate.value),
                  )):SizedBox(),

                  SizedBox(height: 50),

                  // Submit Button
                  MaterialButton(
                    color: Colors.black,
                    minWidth: 300.0,
                    height: 49.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)),
                    onPressed: controller.submitHomework,
                    child: Text(
                      "Save",
                      style: AppTextStyles.heading(
                          color: Colors.white, fontSize: 14.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(()=>controller.loading.value?Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.shade300.withOpacity(0.7),
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          ):SizedBox())
        ],
      ),
    );
  }
}
