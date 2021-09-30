import 'package:flashcard_project/repository/auth_repo.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:googleapis/sheets/v4.dart';

class SheetRepo {
  AuthRepo authRepo = AuthRepo();
  late SheetsApi sheetsApi;
  late DriveApi driveApi;
  late Future<void> init;

  SheetRepo() {
    init = initSheetRepo();
  }

  Future<List<List<Object>>?> getEntriesFromRange(String range) async {
    await init;
    final result = await sheetsApi.spreadsheets.values
        .get("12xIkohAtL3X5f7FbvqRrpSx9Od7mpF2m5HZKbGDGBIc", range);
    return result.values;
  }

  Future<void> initSheetRepo() async {
    final client = await authRepo.getRegisteredHTTPClient();
    sheetsApi = SheetsApi(client);
    driveApi = DriveApi(client);
  }
}
