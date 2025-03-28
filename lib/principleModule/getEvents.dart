import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practiceproject/utils/custom_appbar.dart';
import 'eventUploadController.dart';
import 'getEventController.dart';

class Getevents extends StatelessWidget {
  final controller = Get.put(GetEventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Event/Circular List'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting Event or Circular
            Obx(() => DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedType.value,
                  onChanged: (String? newValue) {
                    if (controller.selectedType.value == 'Event') {
                      controller.getData(
                          "http://147.79.66.224/madminapi/private/v1/events");
                    } else if (controller.selectedType.value == 'Circular') {
                      controller.getData(
                          "http://147.79.66.224/madminapi/private/v1/circular");
                    }
                  },
                  items: <String>['Event', 'Circular']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )),

            SizedBox(height: 20),

            Obx(() => !controller.loading.value
                ? controller.data.isNotEmpty
                    ? ListView.builder(
                        itemCount: controller.data.length,
                        itemBuilder: (context, index) {
                          final event = controller.data[index];
                          return Card(
                            margin: EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(event['title'] ?? ""),
                              subtitle: Text(event['content'] ?? ""),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text("No Data Available"),
                      )
                : Center(
                    child: CupertinoActivityIndicator(),
                  ))
          ],
        ),
      ),
    );
  }
}

class Event {
  final String title;
  final String content;

  Event({required this.title, required this.content});
}

class Circular {
  final String title;
  final String content;

  Circular({required this.title, required this.content});
}
