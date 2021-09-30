import 'dart:io';

import 'package:flashcard_project/design_system.dart';
import 'package:flashcard_project/domain/csv_reader.dart';
import 'package:flashcard_project/repository/auth.dart';
import 'package:flashcard_project/repository/sheet_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CSVReader csvReader = CSVReader();
  late List<MapEntry<String, String>> questionAnswerList;
  late MapEntry<String, String> questionAnswerHeader;
  late MapEntry<String, String> currentQuestionAndAnswer;
  bool cardFlipped = false;
  bool allCardsFinished = false;

  @override
  initState() {
    super.initState();
    startLesson();
  }

  void startLesson() {
    var file = File(
        "/Users/maxweber/AndroidStudioProjects/flashcard_project/test_data/learn english/lesson_1.csv");

    setState(() {
      questionAnswerList = csvReader.readLessonFrom(file).entries.toList();
      questionAnswerHeader = questionAnswerList.removeAt(0);
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
                          elevation: 8.0,
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
                      IconButton(
                        onPressed: () async {
                          final client = await Auth().getRegisteredHTTPClient();
                          SheetService(client).getSheet();
                        },
                        icon: const Icon(Icons.ac_unit),
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
