import 'package:flashcard_project/repository/sheet_repo.dart';

typedef QuestionString = String;
typedef AnswerString = String;
typedef HintString = String;
typedef SolutionString = String;

class FlashcardService {
  final SheetRepo _sheetRepo;

  FlashcardService(this._sheetRepo);

  Future<MapEntry<HintString, SolutionString>> getHeadline() async {
    List<List<Object>>? entryList =
        await _sheetRepo.getEntriesFromRange("A1:B1");

    if (entryList == null) throw UnsupportedError("The entries are null");

    final List<String> firstEntry =
        entryList.first.map((element) => element.toString()).toList();
    return MapEntry(firstEntry[0], firstEntry[1]);
  }

  Future<Map<QuestionString, AnswerString>> getQuestionsAndAnswers() async {
    List<List<Object>>? entryList =
        await _sheetRepo.getEntriesFromRange("A2:B1000");
    if (entryList == null) {
      throw UnsupportedError("There are no questions nor answers.");
    }

    Map<QuestionString, AnswerString> questionsAndAnswers = {};

    for (var element in entryList) {
      if (element.isEmpty) continue;

      if (element.length != 2) {
        throw UnsupportedError("The csv must have exactly 2 columns");
      }

      questionsAndAnswers.putIfAbsent(
        element[0].toString().trim(),
        () => element[1].toString().trim(),
      );
    }

    return questionsAndAnswers;
  }
}
