import 'dart:io';

import 'package:flashcard_project/domain/csv_reader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("CSV Reader", () {
    CSVReader subject = CSVReader();

    test("WHEN we pass a csv file into the method THEN it should return a table", () {
      File file = File("test/test_data/learn english/lesson_1.csv");
      expect(subject.readLessonFrom(file)[1][1], "Hello");
    });

    test("WHEN we not pass a csv file into the method THEN it should throw", () {
      File file = File("test/domain/csv_reader_test.dart");
      expect(() => subject.readLessonFrom(file), throwsUnsupportedError);
    });
  });
}
