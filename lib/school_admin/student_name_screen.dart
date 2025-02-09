import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/custom_appbar.dart';



class Student {
  final String name;
  final String className; // Class the student belongs to
  final String status; // "Paid" or "Pending"
  final String? paymentDate; // Date if the fee is paid

  Student({
    required this.name,
    required this.className,
    required this.status,
    this.paymentDate,
  });
}

class StudentListScreen extends StatelessWidget {
  final List<Student> students = [
    Student(
      name: "Alice Johnson",
      className: "Class 1",
      status: "Paid",
      paymentDate: "2025-01-01",
    ),
    Student(name: "Bob Smith", className: "Class 2", status: "Pending"),
    Student(
      name: "Charlie Brown",
      className: "Class 3",
      status: "Paid",
      paymentDate: "2025-01-05",
    ),
    Student(name: "Diana Ross", className: "Class 4", status: "Pending"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Students'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FeePieChart(paidFees: 70.0, pendingFees: 30.0),
              SizedBox(height: 20),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];
                  return Card(
                    color: Colors.white,
                    elevation: 1.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                        student.status == "Paid"
                            ? Colors.green
                            : Colors.red,
                        child: Text(
                          student.name[0], // Initial of the student name
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        student.name,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        '${student.className}\n'
                            '${student.status == "Paid" ? "Status: Paid\nDate: ${student.paymentDate}" : "Status: Pending"}',
                        style: GoogleFonts.montserrat(
                          color:
                          student.status == "Paid"
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      trailing: Icon(
                        student.status == "Paid"
                            ? Icons.check_circle
                            : Icons.error,
                        color:
                        student.status == "Paid"
                            ? Colors.green
                            : Colors.red,
                      ),
                      isThreeLine:
                      true, // To accommodate class name and fee status
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeePieChart extends StatelessWidget {
  final double paidFees;
  final double pendingFees;

  FeePieChart({required this.paidFees, required this.pendingFees});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Fee Distribution',
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          height: 200,
          child: PieChart(
            PieChartData(
              sections: _getSections(),
              centerSpaceRadius: 40,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegend('Paid Fees', Colors.green),
            const SizedBox(width: 10),
            _buildLegend('Pending Fees', Colors.red),
          ],
        ),
      ],
    );
  }

  List<PieChartSectionData> _getSections() {
    final double total = (paidFees + pendingFees) as double;
    final paidPercentage = (paidFees / total) * 100;
    final pendingPercentage = (pendingFees / total) * 100;

    return [
      PieChartSectionData(
        color: Colors.green,
        value: paidPercentage,
        title: '${paidPercentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: pendingPercentage,
        title: '${pendingPercentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.black,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}