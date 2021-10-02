import 'package:flashcard_project/repository/auth_repo.dart';
import 'package:googleapis/drive/v2.dart';

class GDriveRepo {
  AuthRepo authRepo = AuthRepo();
  late DriveApi driveApi;
  late Future<void> init;

  GDriveRepo() {
    init = initSheetRepo();
  }

  Future<List<File>> getFiles() async {
    await init;
    final result = await driveApi.files.list();
    var files = result.items;
    if (files == null) throw UnsupportedError("No files found");
    return files
        .where((element) => element.mimeType?.contains("spreadsheet") ?? false)
        .toList();
  }

  Future<void> initSheetRepo() async {
    final client = await authRepo.getRegisteredHTTPClient();
    driveApi = DriveApi(client);
  }
}
