import 'package:flutter/material.dart';
import 'package:course_manage_with_isar/models/course.dart';
import 'package:course_manage_with_isar/models/student.dart';
import 'package:course_manage_with_isar/models/teacher.dart';
import 'package:course_manage_with_isar/presentation/pages/courses/course_form.dart';
import 'package:course_manage_with_isar/presentation/pages/courses/course_view.dart';
import 'package:course_manage_with_isar/presentation/pages/students/student_form.dart';
import 'package:course_manage_with_isar/presentation/pages/students/student_view.dart';
import 'package:course_manage_with_isar/presentation/pages/teachers/teacher_form.dart';
import 'package:course_manage_with_isar/presentation/pages/teachers/teacher_view.dart';
import 'package:course_manage_with_isar/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DatabaseService databaseService;

  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
  }

  // Stop listening to the stream when the widget is disposed
  @override
  void dispose() {
    super.dispose();
  }

  // delete course
  Future<int?> deleteCourse(int id) async {
    return await databaseService.deleteCourses(id);
  }

  // add or update course
  void addOrUpdateCourse([Course? updateCourse]) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close))),
            content: CourseForm(
              course: updateCourse,
              onSave: (Course course) {
                if (updateCourse == null) {
                  databaseService.addCourses(course);
                } else {
                  course.id = updateCourse.id;
                  databaseService.updateCourses(course);
                }
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  // delete student
  void deleteStudent(int id) async {
    await databaseService.deleteStudents(id);
  }

  // add or update student
  void addOrUpdateStudent([Student? updateStudent]) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close))),
            content: StudentForm(
              student: updateStudent,
              onSave: (Student student) {
                if (updateStudent == null) {
                  databaseService.addStudents(student);
                } else {
                  student.id = updateStudent.id;
                  databaseService.updateStudents(student);
                }
                Navigator.pop(context);
              },
            ),
          );
        });
  }

  // delete teacher
  void deleteTeacher(int id) async {
    await databaseService.deleteTeachers(id);
  }

  // add or update teacher
  void addOrUpdateTeacher([Teacher? updateTeacher]) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return LayoutBuilder(builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight / 1.35,
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: TeacherForm(
                      teacher: updateTeacher,
                      onSave: (Teacher teacher) {
                        if (updateTeacher == null) {
                          databaseService.addTeachers(teacher);
                        } else {
                          teacher.id = updateTeacher.id;
                          databaseService.updateTeachers(teacher);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(
              child: Text('Courses'),
            ),
            Tab(
              child: Text('Students'),
            ),
            Tab(
              child: Text('Teachers'),
            ),
          ]),
        ),
        body: SafeArea(
            child: TabBarView(
          children: [
            CourseView(
              addOrUpdateCourse: addOrUpdateCourse,
              deleteCourse: deleteCourse,
            ),
            StudentView(
              addOrUpdateStudent: addOrUpdateStudent,
              deleteStudent: deleteStudent,
            ),
            TeacherView(
              addOrUpdateTeacher: addOrUpdateTeacher,
              deleteTeacher: deleteTeacher,
            ),
          ],
        )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                offset: const Offset(-2, -2),
                blurRadius: 30,
                color: Colors.black.withOpacity(0.1)),
          ]),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: addOrUpdateCourse,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 237, 237),
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      'Course +',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addOrUpdateStudent();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 237, 237, 237),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'Student +',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addOrUpdateTeacher();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 237, 237, 237),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'Teacher +',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
