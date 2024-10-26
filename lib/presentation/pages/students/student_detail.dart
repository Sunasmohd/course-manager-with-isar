import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/student.dart';
import 'package:course_manage_with_isar/presentation/widgets/course_card.dart';

class StudentDetail extends StatelessWidget {
  final Student student;
  const StudentDetail({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'My Courses',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 170,
              child: student.courses.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: student.courses.length,
                      itemBuilder: (context, index) {
                        final course = student.courses.toList()[index];
                        return CourseCard(
                          image: course.image,
                          name: course.name,
                          isSingle: index == 0,
                        );
                      },
                    )
                  : const Text(
                      'No courses purchased!!',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.red),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
