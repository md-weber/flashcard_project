import 'package:flashcard_project/domain/flashcard_service.dart';
import 'package:flashcard_project/repository/sheet_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'flashcard_service_test.mocks.dart';

@GenerateMocks([SheetRepo])
main() {
  group("FlashcardService", () {
    final mockSheetRepo = MockSheetRepo();
    final subject = FlashcardService(mockSheetRepo);

    group("getHeadline", () {
      test("WHEN the SheetRepo return null THEN an UnsupportedError is thrown",
          () async {
        when(mockSheetRepo.getEntriesFromRange("A1:B1")).thenAnswer(
          (realInvocation) async => null,
        );

        try {
          await subject.getHeadline();
        } catch (e) {
          expect(e, isInstanceOf<UnsupportedError>());
        }
      });

      test(
          "WHEN we provide a real entry THEN we want to receive a Header MapEntries object",
          () async {
        when(mockSheetRepo.getEntriesFromRange("A1:B1")).thenAnswer(
          (realInvocation) async => [
            ["German", "English"]
          ],
        );

        MapEntry<String, String> result = await subject.getHeadline();
        expect(result.key, "German");
        expect(result.value, "English");
      });
    });

    group("getQuestionsAndAnswers", () {
      test("WHEN the SheetRepo return null THEN an UnsupportedError is thrown",
          () async {
        when(mockSheetRepo.getEntriesFromRange("A2:B1000")).thenAnswer(
          (realInvocation) async => null,
        );

        try {
          await subject.getQuestionsAndAnswers();
        } catch (e) {
          expect(e, isInstanceOf<UnsupportedError>());
        }
      });

      test(
          "WHEN we return a mapentry with one element THEN an UnsupportedError is thrown",
          () async {
        when(mockSheetRepo.getEntriesFromRange("A2:B1000")).thenAnswer(
          (realInvocation) async => [
            ["Deutsch"],
          ],
        );

        try {
          await subject.getQuestionsAndAnswers();
        } catch (e) {
          expect(e, isInstanceOf<UnsupportedError>());
        }
      });

      test(
          "WHEN we provide 2 entries with an empty space between THEN we return a Map with two entries",
          () async {
        when(mockSheetRepo.getEntriesFromRange("A2:B1000")).thenAnswer(
          (realInvocation) async => [
            ["Deutsch", "German"],
            [],
            ["Fahrrad", "Bicycle"]
          ],
        );

        Map<String, String> result = await subject.getQuestionsAndAnswers();
        expect(result.length, 2);
        expect(result.values, ["German", "Bicycle"]);
      });
    });
  });
}
