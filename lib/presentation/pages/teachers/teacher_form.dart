import 'dart:io';
import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/course.dart';
import 'package:course_manage_with_isar/models/teacher.dart';
import 'package:course_manage_with_isar/presentation/widgets/custom_textfield.dart';
import 'package:course_manage_with_isar/services/database_service.dart';
import 'package:course_manage_with_isar/services/media_service.dart';
import 'package:course_manage_with_isar/utils/extensions.dart';

class TeacherForm extends StatefulWidget {
  final Teacher? teacher;
  final Function(Teacher teacher) onSave;
  const TeacherForm({super.key, required this.teacher, required this.onSave});

  @override
  State<TeacherForm> createState() => _TeacherFormState();
}

class _TeacherFormState extends State<TeacherForm> {
  late TextEditingController _nameController;
  File? _selectedTeacherImage;
  Course? selectedCourse;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    addOrUpdateTeacher(widget.teacher);
  }

  void addOrUpdateTeacher([Teacher? updateTeacher]) {
    if (updateTeacher != null) {
      _nameController.text = updateTeacher.name;
      _selectedTeacherImage = File(updateTeacher.image);
      selectedCourse = updateTeacher.course.value;
    } else {
      _nameController.clear();
      _selectedTeacherImage = null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  void pickImage() async {
    File? file = await MediaService.pickImageFromGallery();
    if (file != null) {
      setState(() {
        _selectedTeacherImage = file;
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
                backgroundImage: _selectedTeacherImage != null
                    ? FileImage(_selectedTeacherImage!)
                    : null,
                radius: 50,
                child: _selectedTeacherImage == null
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
          FutureBuilder(
              future: databaseService.getCoursesWithoutTeacher(),
              builder: (context, snapshot) {
                final data = snapshot.data;
                if (snapshot.hasData) {
                  selectedCourse =
                      snapshot.data!.isNotEmpty && widget.teacher == null
                          ? snapshot.data![0]
                          : selectedCourse;
                  return DropdownMenu(
                      hintText: 'Select a Course',
                      onSelected: (value) {
                        selectedCourse = value;
                      },
                      width: MediaQuery.sizeOf(context).width - 50,
                      initialSelection: selectedCourse,
                      dropdownMenuEntries: List.generate(data!.length, (index) {
                        return DropdownMenuEntry(
                          value: data[index],
                          label: data[index].name,
                        );
                      }));
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_selectedTeacherImage != null && selectedCourse != null) {
                  final teacher = Teacher()
                    ..name = _nameController.text.toCapitalize()
                    ..image = _selectedTeacherImage!.path
                    ..course.value = selectedCourse;

                  widget.onSave(teacher); // Passing the course to parent
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image must be provided')));
                }
              }
            },
            child:
                Text(widget.teacher == null ? 'Add Teacher' : 'Update Teacher'),
          ),
        ],
      ),
    );
  }
}
