import 'package:googleapis/drive/v2.dart';
import 'package:googleapis/sheets/v4.dart';
import 'package:http/http.dart' as http;

class SheetService {
  late SheetsApi sheetsApi;
  late DriveApi driveApi;

  SheetService(http.Client client) {
    sheetsApi = SheetsApi(client);
  }

  getSheet() async {
    final result = await sheetsApi.spreadsheets.values
        .get("12xIkohAtL3X5f7FbvqRrpSx9Od7mpF2m5HZKbGDGBIc", "A1:B5");
    print(result);
  }
}
