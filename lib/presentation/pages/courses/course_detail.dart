import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/course.dart';
import 'package:course_manage_with_isar/presentation/widgets/row_container.dart';

class CourseDetail extends StatelessWidget {
  final Course course;
  const CourseDetail({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.name,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
            const Divider(
              height: 50,
            ),
            const Text(
              'Tutor',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            course.teacher.value == null
                ? const Text(
                    'No tutors are available for this course',
                    style: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.red),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RowContainer(value: course.teacher.value),
                  ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Students',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: course.students.toList().isEmpty
                  ? const Text('No students are registered for this course.',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.red))
                  : ListView.builder(
                      itemCount: course.students.toList().length,
                      itemBuilder: (context, index) {
                        final student = course.students.toList()[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: RowContainer(value: student),
                        );
                      }),
            )
          ],
        ),
      ),
    );
  }
}
