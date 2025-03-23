import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practiceproject/utils/custom_appbar.dart';
import 'eventUploadController.dart';
import 'getEventController.dart';

class Getevents extends StatelessWidget {
  final  controller = Get.put(GetEventController());

  @override
  Widget build(BuildContext context) {
    // Fetch events and circulars when the screen is loaded
    controller.fetchEvents();
    controller.fetchCirculars();

    return Scaffold(
      appBar: CustomAppBar(title: 'Event/Circular List'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting Event or Circular
            Obx(() => DropdownButton<String>(isExpanded: true,
              value: controller.selectedType.value,
              onChanged: (String? newValue) {
                controller.updateSelectedType(newValue!);
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

            // List of Events/Circulars
            Expanded(
              child: Obx(() {
                if (controller.selectedType.value == 'Event') {
                  return ListView.builder(
                    itemCount: controller.events.length,
                    itemBuilder: (context, index) {
                      final event = controller.events[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(event.title),
                          subtitle: Text(event.content),
                        ),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    itemCount: controller.circulars.length,
                    itemBuilder: (context, index) {
                      final circular = controller.circulars[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(circular.title),
                          subtitle: Text(circular.content),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
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