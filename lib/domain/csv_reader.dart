import 'dart:io';

class CSVReader {
  List<List<String>> readLessonFrom(File file) {
    if (!file.path.endsWith(".csv")) throw UnsupportedError("Only csv is currently supported");

    final rows = file.readAsLinesSync();
    List<List<String>> table = rows.map((String row) => row.split(',')).toList();
    return table;
  }
}
