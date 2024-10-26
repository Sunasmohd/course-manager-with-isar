import 'package:isar/isar.dart';
import 'package:course_manage_with_isar/models/student.dart';
import 'package:course_manage_with_isar/models/teacher.dart';

part 'course.g.dart';

@Collection()
class Course {
  Id id = Isar.autoIncrement;

  late String name;

  late byte duration;

  late double price;

  late String image;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          duration == other.duration &&
          price == other.price &&
          image == other.image;

  @override
  int get hashCode => Object.hash(id, name, duration, price, image);

  // add backlinks
  @Backlink(to: 'courses')
  final students = IsarLinks<Student>();

  @Backlink(to: 'course')
  final teacher = IsarLink<Teacher>();
}
