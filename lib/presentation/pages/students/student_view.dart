import 'dart:io';

import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/student.dart';
import 'package:course_manage_with_isar/presentation/pages/students/student_detail.dart';
import 'package:course_manage_with_isar/services/database_service.dart';
import 'package:course_manage_with_isar/utils/course_to_string.dart';

class StudentView extends StatelessWidget {
  final Function(Student? course) addOrUpdateStudent;
  final Function(int id) deleteStudent;
  const StudentView(
      {super.key,
      required this.addOrUpdateStudent,
      required this.deleteStudent});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();
    return StreamBuilder(
        stream: databaseService.listenToStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data!.isEmpty) {
              return const Center(child: Text('No students available'));
            }
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  getCourseName(data[index].courses);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                StudentDetail(student: data[index])));
                      },
                      child: Material(
                        color: const Color.fromARGB(255, 247, 247, 247),
                        borderRadius: BorderRadius.circular(10),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            title: Text(data[index].name),
                            contentPadding: const EdgeInsets.all(0),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  FileImage(File(data[index].image)),
                            ),
                            subtitle: Text(
                              data[index].courses.isNotEmpty
                                  ? getCourseName(data[index].courses)
                                  : '',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      addOrUpdateStudent(data[index]);
                                    },
                                    child: const Icon(Icons.edit)),
                                GestureDetector(
                                    onTap: () {
                                      deleteStudent(data[index].id);
                                    },
                                    child: const Icon(Icons.delete)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return Text('Error!! ${snapshot.error}',
                style: const TextStyle(
                    fontWeight: FontWeight.w400, color: Colors.red));
          }
          return const Text('Something went wrong!!',
              style: TextStyle(fontWeight: FontWeight.w400, color: Colors.red));
        });
  }
}
