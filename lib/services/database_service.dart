import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:course_manage_with_isar/models/course.dart';
import 'package:course_manage_with_isar/models/student.dart';
import 'package:course_manage_with_isar/models/teacher.dart';

class DatabaseService {
  DatabaseService._internal();

  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  static late Isar isar;

  // initialize db
  static Future<void> initializeDb() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([CourseSchema, StudentSchema, TeacherSchema],
        directory: dir.path);
  }

  void addCourses(Course course) async {
    await isar.writeTxn(() => isar.courses.put(course));
  }

  void updateCourses(Course newCourse) async {
    Course? oldCourse =
        await isar.courses.filter().idEqualTo(newCourse.id).findFirst();

    if (oldCourse != null) {
      oldCourse = newCourse;
      await isar.writeTxn(() async {
        await isar.courses.put(oldCourse!);
        newCourse.students.save();
      });
    }
  }

  void updateStudents(Student newStudent) async {
    Student? oldStudent =
        await isar.students.filter().idEqualTo(newStudent.id).findFirst();

    if (oldStudent != null) {
      await isar.writeTxn(() async {
        // resetting the old link this ensures
        // the previous values are cleared
        await oldStudent.courses.reset();
        await isar.students.put(newStudent);
        await newStudent.courses.save();
      });
    }
  }

  void updateTeachers(Teacher newTeacher) async {
    Teacher? oldTeacher =
        await isar.teachers.filter().idEqualTo(newTeacher.id).findFirst();

    if (oldTeacher != null) {
      await isar.writeTxn(() async {
        // resetting the old link this ensures
        // the previous values are cleared
        await oldTeacher.course.reset();
        await isar.teachers.put(newTeacher);
        await newTeacher.course.save();
      });
    }
  }

  Future<int?> deleteCourses(int id) async {
    final course = await isar.courses.get(id);
    if (course != null) {
      final studentCount = course.students.length;
      if (studentCount == 0) {
        await isar.writeTxn(() => isar.courses.delete(id));
        return null;
      } else {
        return studentCount;
      }
    }
    return null;
  }

  Future<void> deleteStudents(int id) async {
    await isar.writeTxn(() => isar.students.delete(id));
  }

  Future<void> deleteTeachers(int id) async {
    await isar.writeTxn(() => isar.teachers.delete(id));
  }

  void addStudents(Student students) async {
    await isar.writeTxn(() async {
      await isar.students.put(students);
      await students.courses.save();
    });
  }

  void addTeachers(Teacher teachers) async {
    await isar.writeTxn(() async {
      await isar.teachers.put(teachers);
      await teachers.course.save();
    });
  }

  Future<List<Course>> getAllCourses() async {
    return await isar.courses.where().findAll();
  }

  Future<List<Course>> getCoursesWithoutTeacher() async {
    return await isar.courses.filter().teacherIsNull().findAll();
  }

  Stream<List<Course>> listenToCourses() async* {
    yield* isar.courses.where().watch(fireImmediately: true);
  }

  Stream<List<Student>> listenToStudents() async* {
    yield* isar.students.where().watch(fireImmediately: true);
  }

  Stream<List<Teacher>> listenToTeachers() async* {
    yield* isar.teachers.where().watch(fireImmediately: true);
  }

  Future<void> cleanDb() async {
    await isar.writeTxn(() => isar.clear());
  }

  Future<List<Student>> getStudentsFor(Course course) async {
    return await isar.students
        .filter()
        .courses((q) => q.idEqualTo(course.id))
        .findAll();
  }

  Future<Teacher?> getTeacherFor(Course course) async {
    return await isar.teachers
        .filter()
        .course((q) => q.idEqualTo(course.id))
        .findFirst();
  }
}
