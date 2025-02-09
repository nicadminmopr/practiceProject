
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:practiceproject/school_admin/student_name_screen.dart';

import '../utils/custom_appbar.dart';


class ClassGridScreen extends StatelessWidget {
  Function onTap;
  ClassGridScreen({required this.onTap});
  final List<String> classNames = ['1', '2', '3', '4', '5', '6'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Classes'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                hintText: 'Search by class, section, or student name',
                hintStyle: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade50),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade50),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: Colors.grey.shade50),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 16, // Space between columns
                  mainAxisSpacing: 16, // Space between rows
                ),
                itemCount: classNames.length,
                itemBuilder: (context, index) {
                  final className = classNames[index];
                  return GestureDetector(
                    onTap:(){
                      onTap();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.black.withOpacity(0.7),
                            child: Text(
                              className,
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Class $className',
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


