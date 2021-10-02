import 'package:flashcard_project/domain/model/file_information.dart';
import 'package:flashcard_project/repository/gdrive_repo.dart';
import 'package:googleapis/drive/v2.dart';

class FilesService {
  final GDriveRepo _gDriveRepo;

  FilesService(this._gDriveRepo);

  Future<List<LectureFolder>> getPossibleLectures() async {
    List<File> filesAndFolders = await _gDriveRepo.getFilesAndFolders();

    final spreadsheets = filesAndFolders
        .where((element) => element.mimeType?.contains("spreadsheet") ?? false)
        .toList();

    final folders = filesAndFolders
        .where((element) => element.mimeType?.contains("folder") ?? false)
        .where((element) => element.title != "Flashcard App")
        .toList();

    List<LectureFolder> result =
        folders.map((folder) => LectureFolder(folder.title ?? "", [])).toList();

    for (var spreadsheet in spreadsheets) {
      final folder = folders.firstWhere(
        (element) => element.id == spreadsheet.parents?[0].id,
      );
      final lectureFolder =
          result.firstWhere((element) => element.name == folder.title);

      lectureFolder.spreadsheets.add(
        LectureInformation(spreadsheet.title ?? "", spreadsheet.id ?? ""),
      );
    }

    return result;
  }
}
