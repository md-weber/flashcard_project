import 'package:flashcard_project/domain/model/file_information.dart';
import 'package:flashcard_project/repository/sheet_repo.dart';
import 'package:googleapis/drive/v2.dart';

class FileService {
  final SheetRepo _sheetRepo = SheetRepo();

  Future<List<FileInformation>> getPossibleLectures() async {
    List<File> files = await _sheetRepo.getFiles();

    return files
        .map((file) => FileInformation(file.title ?? "", file.id ?? ""))
        .toList();
  }
}
