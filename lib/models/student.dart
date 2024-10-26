import 'package:isar/isar.dart';
import 'package:course_manage_with_isar/models/course.dart';

part 'student.g.dart';

@Collection()
class Student {
  Id id = Isar.autoIncrement;

  late String name;

  late String image;

  final courses = IsarLinks<Course>();
}
