import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/teacher.dart';
import 'package:course_manage_with_isar/presentation/widgets/course_card.dart';
import 'package:course_manage_with_isar/presentation/widgets/row_container.dart';

class TeacherDetail extends StatelessWidget {
  final Teacher teacher;
  const TeacherDetail({super.key, required this.teacher});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'My Course',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            teacher.course.value != null
                ? CourseCard(
                    image: teacher.course.value != null
                        ? teacher.course.value!.image
                        : '',
                    name: teacher.course.value != null
                        ? teacher.course.value!.name
                        : '',
                    isSingle: true,
                  )
                : const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Doesn\'t have a course yet',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.red),
                    ),
                  ),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'My Students',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: teacher.course.value != null
                  ? (teacher.course.value!.students.toList().isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                            'No students are registered for this course',
                            style: TextStyle(
                                fontWeight: FontWeight.w400, color: Colors.red),
                          ),
                        )
                      : ListView.builder(
                          itemCount:
                              teacher.course.value!.students.toList().length,
                          itemBuilder: (context, index) {
                            final student =
                                teacher.course.value!.students.toList()[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              child: RowContainer(value: student),
                            );
                          },
                        ))
                  : const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Students will be only available through courses',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.red),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
