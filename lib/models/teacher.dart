import 'package:isar/isar.dart';
import 'package:course_manage_with_isar/models/course.dart';

part 'teacher.g.dart';

@Collection()
class Teacher {
  Id id = Isar.autoIncrement;

  late String name;

  late String image;

  final course = IsarLink<Course>();
}
