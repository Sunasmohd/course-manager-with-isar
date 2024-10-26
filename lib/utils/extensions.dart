extension Capitalize on String {
  String toCapitalize() {
    return isNotEmpty ? substring(0, 1).toUpperCase() + substring(1) : '';
  }
}
