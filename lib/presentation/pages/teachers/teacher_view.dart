import 'dart:io';

import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/teacher.dart';
import 'package:course_manage_with_isar/presentation/pages/teachers/teacher_detail.dart';
import 'package:course_manage_with_isar/services/database_service.dart';

class TeacherView extends StatelessWidget {
  final Function(Teacher? teacher) addOrUpdateTeacher;
  final Function(int id) deleteTeacher;
  const TeacherView(
      {super.key,
      required this.addOrUpdateTeacher,
      required this.deleteTeacher});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();
    return StreamBuilder(
        stream: databaseService.listenToTeachers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data!.isEmpty) {
              return const Center(child: Text('No teachers available'));
            }
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                TeacherDetail(teacher: data[index])));
                      },
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 247, 247, 247),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListTile(
                            title: Text(data[index].name),
                            contentPadding: const EdgeInsets.all(0),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: FileImage(
                                File(data[index].image)
                              ),
                            ),
                            subtitle: Text(data[index].course.value != null
                                ? data[index].course.value!.name.toString()
                                : ''),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      addOrUpdateTeacher(data[index]);
                                    },
                                    child: const Icon(Icons.edit)),
                                GestureDetector(
                                    onTap: () {
                                      deleteTeacher(data[index].id);
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
