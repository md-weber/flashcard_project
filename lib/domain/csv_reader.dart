import 'dart:io';

class CSVReader {
  Map<String, String> readLessonFrom(File file) {
    if (!file.path.endsWith(".csv")) {
      throw UnsupportedError("Only csv is currently supported");
    }

    final rows = file.readAsLinesSync();

    if (rows.isEmpty) {
      throw UnsupportedError(
          "The csv is empty, please provide at least 1 header and one q&a");
    }

    Map<String, String> questionAnswerMap = {};

    for (var row in rows) {
      var split = row.split(',');

      if (split.length != 2) {
        throw UnsupportedError("The csv must have exactly 2 columns");
      }

      questionAnswerMap.putIfAbsent(split[0].trim(), () {
        return split[1].trim();
      });
    }

    return questionAnswerMap;
  }
}
