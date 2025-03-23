import 'package:get/get.dart';

import 'getEvents.dart';

class GetEventController extends GetxController {
  var selectedType = 'Event'.obs; // Observable variable for dropdown value
  var events = <Event>[].obs; // Observable list of events
  var circulars = <Circular>[].obs; // Observable list of circulars

  void updateSelectedType(String value) {
    selectedType.value = value;
  }

  void fetchEvents() {
    // Simulate fetching events from an API or local storage
    events.assignAll([
      Event(title: 'Event 1', content: 'Content for Event 1'),
      Event(title: 'Event 2', content: 'Content for Event 2'),
    ]);
  }

  void fetchCirculars() {
    // Simulate fetching circulars from an API or local storage
    circulars.assignAll([
      Circular(title: 'Circular 1', content: 'Content for Circular 1'),
      Circular(title: 'Circular 2', content: 'Content for Circular 2'),
    ]);
  }
}