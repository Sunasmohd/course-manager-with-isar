import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/course.dart';
import 'package:course_manage_with_isar/presentation/widgets/row_container.dart';
import 'package:course_manage_with_isar/services/database_service.dart';

class CourseDetail extends StatelessWidget {
  final Course course;
  const CourseDetail({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();
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
            FutureBuilder(
                future: databaseService.getTeacherFor(course),
                builder: (index, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: RowContainer(value: snapshot.data!));
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
                  if (snapshot.data == null) {
                    return const Text(
                        'No tutors are available for this course.',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.red));
                  }
                  return const Text('Something went wrong!!',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.red));
                }),
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
            FutureBuilder(
                future: databaseService.getStudentsFor(course),
                builder: (index, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return const Text(
                          'No students are registered for this course.',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, color: Colors.red));
                    }
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final student = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: RowContainer(value: student),
                            );
                          }),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Error!! ${snapshot.error}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, color: Colors.red));
                  }
                  return const Text(
                      'No students are registered for this course.',
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: Colors.red));
                }),
          ],
        ),
      ),
    );
  }
}
