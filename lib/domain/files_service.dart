import 'package:flashcard_project/domain/model/file_information.dart';
import 'package:flashcard_project/repository/gdrive_repo.dart';
import 'package:googleapis/drive/v2.dart';

class FileService {
  final GDriveRepo _sheetRepo = GDriveRepo();

  Future<List<LectureFolder>> getPossibleLectures() async {
    List<File> filesAndFolders = await _sheetRepo.getFilesAndFolders();

    final spreadsheets = filesAndFolders
        .where((element) => element.mimeType?.contains("spreadsheet") ?? false)
        .toList();

    final folders = filesAndFolders
        .where((element) => element.mimeType?.contains("folder") ?? false)
        .where((element) => element.title != "Flashcard App")
        .toList();

    List<LectureFolder> t =
        folders.map((folder) => LectureFolder(folder.title ?? "", [])).toList();

    for (var spreadsheet in spreadsheets) {
      final folder = folders.firstWhere(
        (element) => element.id == spreadsheet.parents?[0].id,
      );
      final lectureFolder =
          t.firstWhere((element) => element.name == folder.title);

      lectureFolder.spreadsheets.add(
        LectureInformation(spreadsheet.title ?? "", spreadsheet.id ?? ""),
      );
    }

    return t;
  }
}
