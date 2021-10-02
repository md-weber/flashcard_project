import 'package:flashcard_project/domain/files_service.dart';
import 'package:flashcard_project/repository/gdrive_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'files_service_test.mocks.dart';

@GenerateMocks([GDriveRepo])
void main() {
  group("FilesService", () {
    final mockGDriveRepo = MockGDriveRepo();
    final subject = FilesService(mockGDriveRepo);

    test(
        "WHEN the GDrive returns an empty list THEN the service return also an empty",
        () async {
      when(mockGDriveRepo.getFilesAndFolders()).thenAnswer(
        (realInvocation) async => [],
      );

      expect(await subject.getPossibleLectures(), []);
    });

    test(
        " WHEN the GDrive returns an folder with one spreadsheet THEN service returns it",
        () async {
      when(mockGDriveRepo.getFilesAndFolders()).thenAnswer(
        (realInvocation) async => [
          File(mimeType: "folder", title: "Learning English"),
          File(mimeType: "spreadsheet", title: "Lesson 1")
        ],
      );

      var result = await subject.getPossibleLectures();
      expect(result[0].name, "Learning English");
      expect(result[0].spreadsheets.length, 1);
      expect(result[0].spreadsheets[0].name, "Lesson 1");
    });
  });
}
