import 'package:flashcard_project/repository/auth_repo.dart';
import 'package:googleapis/sheets/v4.dart';

class SheetRepo {
  AuthRepo authRepo = AuthRepo();
  late SheetsApi sheetsApi;
  late Future<void> init;
  final String spreadsheetId;

  SheetRepo(this.spreadsheetId) {
    init = initSheetRepo();
  }

  Future<List<List<Object>>?> getEntriesFromRange(String range) async {
    await init;
    final result =
        await sheetsApi.spreadsheets.values.get(spreadsheetId, range);
    return result.values;
  }

  Future<void> initSheetRepo() async {
    final client = await authRepo.getRegisteredHTTPClient();
    sheetsApi = SheetsApi(client);
  }
}
