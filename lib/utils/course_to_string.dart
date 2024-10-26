import 'package:isar/isar.dart';
import 'package:course_manage_with_isar/models/course.dart';

String getCourseName(IsarLinks<Course> course) {
  String courseString = '';
  int limit = 2;
  for (var i = 0; i < course.length; i++) {
    if (i < limit) {
      if (i != course.length - 1) {
        courseString += '${course.toList()[i].name}, ';
      } else {
        courseString += course.toList()[i].name;
      }
    } else {
      courseString += '+${course.length - limit} more';
      break;
    }
  }
  return courseString;
}
