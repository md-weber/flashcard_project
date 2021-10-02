import 'package:flashcard_project/design_system.dart';
import 'package:flashcard_project/domain/flashcard_service.dart';
import 'package:flashcard_project/repository/sheet_repo.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static navigateTo(context, String spreadsheetId) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return HomePage(spreadsheetId: spreadsheetId);
      },
    ));
  }

  final String spreadsheetId;

  const HomePage({Key? key, required this.spreadsheetId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FlashcardService _flashcardService;
  late List<MapEntry<String, String>> questionAnswerList;
  late MapEntry<String, String> questionAnswerHeader;
  late MapEntry<String, String> currentQuestionAndAnswer;
  bool cardFlipped = false;
  bool allCardsFinished = true;

  @override
  initState() {
    super.initState();
    _flashcardService = FlashcardService(SheetRepo(widget.spreadsheetId));
    startLesson();
  }

  Future<void> startLesson() async {
    Map<String, String> _questionAnswerList =
        await _flashcardService.getQuestionsAndAnswers();
    questionAnswerList = _questionAnswerList.entries.toList();
    questionAnswerHeader = await _flashcardService.getHeadline();

    setState(() {
      questionAnswerList.shuffle();
      currentQuestionAndAnswer = questionAnswerList.removeAt(0);
      cardFlipped = false;
      allCardsFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flashcard Application"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Insets.small),
        child: Column(
          children: [
            Expanded(
              child: allCardsFinished
                  ? _buildLoadingSpinner()
                  : IgnorePointer(
                      ignoring: cardFlipped,
                      child: InkWell(
                        onTap: () => setState(() => cardFlipped = !cardFlipped),
                        child: Card(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  cardFlipped
                                      ? questionAnswerHeader.value
                                      : questionAnswerHeader.key,
                                ),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      cardFlipped
                                          ? currentQuestionAndAnswer.value
                                          : currentQuestionAndAnswer.key,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            cardFlipped
                ? Row(
                    children: [
                      IconButton(
                        onPressed: getNextCard,
                        icon: const Icon(Icons.cancel),
                      ),
                      IconButton(
                        onPressed: getNextCard,
                        icon: const Icon(Icons.check_circle),
                      ),
                      IconButton(
                        onPressed: startLesson,
                        icon: const Icon(Icons.redo),
                      ),
                    ],
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  void getNextCard() {
    if (questionAnswerList.isEmpty) {
      setState(() => allCardsFinished = true);
      return;
    }
    setState(() {
      cardFlipped = false;
      currentQuestionAndAnswer = questionAnswerList.removeAt(0);
    });
  }

  Column _buildLoadingSpinner() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Congratulations! You finished all your cards."),
        SizedBox(height: Insets.large),
        Text("Your stats are: 42 % correct answered"),
      ],
    );
  }
}
