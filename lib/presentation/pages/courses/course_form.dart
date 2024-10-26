import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:course_manage_with_isar/models/course.dart';
import 'package:course_manage_with_isar/utils/extensions.dart';
import 'package:course_manage_with_isar/presentation/widgets/custom_textfield.dart';
import 'package:course_manage_with_isar/services/media_service.dart';

class CourseForm extends StatefulWidget {
  final Course? course;
  final Function(Course course) onSave;
  const CourseForm({super.key, required this.course, required this.onSave});

  @override
  State<CourseForm> createState() => _CourseFormState();
}

class _CourseFormState extends State<CourseForm> {
  late TextEditingController _titleController;
  late TextEditingController _durationController;
  late TextEditingController _priceController;
  File? _selectedCourseImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _durationController = TextEditingController();
    _priceController = TextEditingController();
    addOrUpdateCourse(widget.course);
  }

  void addOrUpdateCourse([Course? updateCourse]) {
    if (updateCourse != null) {
      _titleController.text = updateCourse.name;
      _durationController.text = updateCourse.duration.toString();
      _priceController.text = updateCourse.price.toString();
      _selectedCourseImage = File(updateCourse.image);
    } else {
      _titleController.clear();
      _priceController.clear();
      _durationController.clear();
      _selectedCourseImage = null;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  void pickImage() async {
    File? file = await MediaService.pickImageFromGallery();
    if (file != null) {
      setState(() {
        _selectedCourseImage = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: pickImage,
            child: CircleAvatar(
                backgroundImage: _selectedCourseImage != null
                    ? FileImage(_selectedCourseImage!)
                    : null,
                radius: 50,
                child: _selectedCourseImage == null
                    ? const Icon(Icons.drive_folder_upload)
                    : null),
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            controller: _titleController,
            hintText: 'Title',
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            controller: _durationController,
            hintText: 'Duration (Months)',
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(2),
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          CustomTextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            hintText: 'Price (Rupees)',
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r"^\d{0,10}(\.\d{0,2})?")),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_selectedCourseImage != null) {
                  final courseTitle = _titleController.text.toCapitalize();
                  final course = Course()
                    ..name = courseTitle
                    ..duration = int.parse(_durationController.text)
                    ..price = double.parse(_priceController.text)
                    ..image = _selectedCourseImage!.path;

                  widget.onSave(course); // Passing the course to parent
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image must be provided')));
                }
              }
            },
            child: Text(widget.course == null ? 'Add Course' : 'Update Course'),
          ),
        ],
      ),
    );
  }
}
