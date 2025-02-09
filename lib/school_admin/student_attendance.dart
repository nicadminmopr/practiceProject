import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_appbar.dart';



class StudentAttendance extends StatefulWidget {
  @override
  _StudentAttendanceState createState() =>
      _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  final List<Map<String, String>> attendanceData = [
    {"name": "John Doe", "date": "2025-01-10", "status": "Present"},
    {"name": "Jane Smith", "date": "2025-01-10", "status": "Absent"},
    {"name": "Emily Davis", "date": "2025-01-11", "status": "Present"},
    {"name": "Michael Brown", "date": "2025-01-12", "status": "Present"},
  ];

  DateTime? selectedDate; // Selected date for filtering

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredData =
    selectedDate == null
        ? attendanceData
        : attendanceData
        .where(
          (entry) =>
      entry["date"] ==
          selectedDate!.toIso8601String().split('T')[0],
    )
        .toList();

    return Scaffold(
      appBar: CustomAppBar(title: 'Student Attendance'),
      body: Column(
        children: [
          // Filter Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                MaterialButton(
                  onPressed: _showDatePicker,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Colors.grey,
                        size: 25.0,
                      ),
                      SizedBox(width: 15.0),
                      Text(
                        selectedDate == null
                            ? "Filter by Date"
                            : selectedDate!.toIso8601String().split('T')[0],
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (selectedDate != null)
                  IconButton(
                    icon: Icon(Icons.clear, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        selectedDate = null; // Reset the filter
                      });
                    },
                  ),
              ],
            ),
          ),

          // Attendance List
          Expanded(
            child:
            filteredData.isEmpty
                ? Center(
              child: Text("No data available for the selected date"),
            )
                : ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final entry = filteredData[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                      entry["status"] == "Present"
                          ? Colors.green
                          : Colors.red,
                      child: Text(
                        entry["name"]![0], // Initial of teacher name
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      entry["name"]!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "Date: ${entry["date"]}\nStatus: ${entry["status"]}",
                      style: GoogleFonts.montserrat(
                        color:
                        entry["status"] == "Present"
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Show Calendar Date Picker
  void _showDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020), // Earliest selectable date
      lastDate: DateTime(2030), // Latest selectable date
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }
}

