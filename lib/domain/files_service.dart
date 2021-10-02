import 'package:flashcard_project/domain/model/file_information.dart';
import 'package:flashcard_project/repository/gdrive_repo.dart';
import 'package:googleapis/drive/v2.dart';

class FileService {
  final GDriveRepo _sheetRepo = GDriveRepo();

  Future<List<FileInformation>> getPossibleLectures() async {
    List<File> files = await _sheetRepo.getFiles();

    return files
        .map((file) => FileInformation(file.title ?? "", file.id ?? ""))
        .toList();
  }
}
