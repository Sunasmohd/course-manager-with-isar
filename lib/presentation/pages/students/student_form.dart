import 'dart:io';

import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/course.dart';
import 'package:course_manage_with_isar/models/student.dart';

import 'package:course_manage_with_isar/utils/extensions.dart';
import 'package:course_manage_with_isar/presentation/widgets/custom_textfield.dart';
import 'package:course_manage_with_isar/services/database_service.dart';
import 'package:course_manage_with_isar/services/media_service.dart';

class StudentForm extends StatefulWidget {
  final Student? student;
  final Function(Student student) onSave;
  const StudentForm({super.key, required this.student, required this.onSave});

  @override
  State<StudentForm> createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  late TextEditingController _nameController;
  late TextEditingController _courseController;
  File? _selectedStudentImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _courseController = TextEditingController();
    addOrUpdateStudent(widget.student);
  }

  List<Course> selectedCourses = [];

  void setCourseString() {
    for (var i = 0; i < selectedCourses.length; i++) {
      if (i != selectedCourses.length - 1) {
        _courseController.text += '${selectedCourses[i].name}, ';
      } else {
        _courseController.text += selectedCourses[i].name;
      }
    }
  }

  void addOrUpdateStudent([Student? updateStudent]) {
    if (updateStudent != null) {
      _nameController.text = updateStudent.name;
      _selectedStudentImage = File(updateStudent.image);
      selectedCourses = updateStudent.courses.toList();
      setCourseString();
    } else {
      _nameController.clear();
      _selectedStudentImage = null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  void pickImage() async {
    File? file = await MediaService.pickImageFromGallery();
    if (file != null) {
      setState(() {
        _selectedStudentImage = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: pickImage,
            child: CircleAvatar(
                backgroundImage: _selectedStudentImage != null
                    ? FileImage(_selectedStudentImage!)
                    : null,
                radius: 50,
                child: _selectedStudentImage == null
                    ? const Icon(Icons.drive_folder_upload)
                    : null),
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            controller: _nameController,
            hintText: 'Name',
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            readOnly: true,
            controller: _courseController,
            hintText: 'Select Courses',
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: FutureBuilder(
                            future: databaseService.getAllCourses(),
                            builder: (context, snapshot) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  StatefulBuilder(builder: (context, stateSet) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                          snapshot.data?.length ?? 0, (index) {
                                        final data = snapshot.data?[index];
                                        final isSelected = selectedCourses.any(
                                            (selectedCourse) =>
                                                selectedCourse.name ==
                                                data?.name);

                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: Text(snapshot
                                                    .data![index].name)),
                                            Checkbox(
                                                value: isSelected,
                                                onChanged: (v) {
                                                  if (v == true) {
                                                    selectedCourses.add(data!);
                                                  } else {
                                                    selectedCourses.removeWhere(
                                                        ((selectedCourse) =>
                                                            selectedCourse
                                                                .name ==
                                                            data?.name));
                                                  }
                                                  stateSet(() {});
                                                })
                                          ],
                                        );
                                      }),
                                    );
                                  }),
                                  ElevatedButton(
                                      onPressed: () {
                                        _courseController.clear();
                                        setCourseString();
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Add'))
                                ],
                              );
                            }));
                  });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (_selectedStudentImage != null) {
                  final student = Student()
                    ..name = _nameController.text.toCapitalize()
                    ..image = _selectedStudentImage!.path;

                  student.courses.addAll(List.from(selectedCourses));

                  widget.onSave(student); // Passing the course to parent
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image must be provided')));
                }
              }
            },
            child:
                Text(widget.student == null ? 'Add Student' : 'Update Student'),
          ),
        ],
      ),
    );
  }
}
