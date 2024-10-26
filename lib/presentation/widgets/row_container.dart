import 'dart:io';

import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/student.dart';
import 'package:course_manage_with_isar/models/teacher.dart';

class RowContainer<T> extends StatelessWidget {
  final T value;
  const RowContainer({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: FileImage(value is Student
              ? File((value as Student).image)
              : value is Teacher
                  ? File((value as Teacher).image)
                  : File('')),
        ),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Text(
            value is Student
                ? (value as Student).name
                : value is Teacher
                    ? (value as Teacher).name
                    : '',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
