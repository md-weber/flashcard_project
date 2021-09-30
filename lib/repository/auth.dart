import 'package:flashcard_project/config.dart';
import 'package:googleapis/sheets/v4.dart';
import "package:googleapis_auth/auth_io.dart";
import 'package:http/http.dart' as http;

class Auth {
  Future<http.Client> getRegisteredHTTPClient() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(credentials);
    var scopes = [
      SheetsApi.spreadsheetsReadonlyScope,
      SheetsApi.driveReadonlyScope
    ];
    return await clientViaServiceAccount(accountCredentials, scopes);
  }
}
