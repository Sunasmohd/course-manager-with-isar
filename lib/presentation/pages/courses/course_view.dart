import 'dart:io';

import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/course.dart';
import 'package:course_manage_with_isar/presentation/pages/courses/course_detail.dart';
import 'package:course_manage_with_isar/services/database_service.dart';

class CourseView extends StatelessWidget {
  final Function(Course? course) addOrUpdateCourse;
  final Future<int?> Function(int id) deleteCourse;
  const CourseView(
      {super.key, required this.addOrUpdateCourse, required this.deleteCourse});

  @override
  Widget build(BuildContext context) {
    final databaseService = DatabaseService();
    return StreamBuilder(
        stream: databaseService.listenToCourses(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            if (data!.isEmpty) {
              return const Center(child: Text('No courses available'));
            }
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return LayoutBuilder(builder: (context, constraints) {
                    return Padding(
                      padding: EdgeInsets.all(constraints.maxHeight * 0.04),
                      child: Material(
                        color: const Color.fromARGB(255, 250, 250, 250),
                        surfaceTintColor:
                            const Color.fromARGB(255, 250, 250, 250),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        elevation: 1,
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CourseDetail(course: data[index])));
                              },
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: Image(
                                    height: constraints.maxHeight / 2.6,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    image: FileImage(File(data[index].image))),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: constraints.maxHeight * 0.04,
                                  horizontal: constraints.maxWidth * 0.04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    data[index].name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.015,
                                  ),
                                  Text(
                                    '${data[index].duration} months',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.015,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '₹${data[index].price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                addOrUpdateCourse(data[index]);
                                              },
                                              child: const Icon(Icons.edit)),
                                          GestureDetector(
                                              onTap: () async {
                                                final count =
                                                    await deleteCourse(
                                                        data[index].id);
                                                if (count != null) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          icon: GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: CircleAvatar(
                                                              radius: 30,
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .error,
                                                              child: const Icon(
                                                                Icons.close,
                                                                size: 40,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          content: Text(
                                                            'Deletion failed $count student${count == 1 ? ' is' : 's are'} associated with this course',
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        );
                                                      });
                                                }
                                              },
                                              child: const Icon(Icons.delete)),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
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
