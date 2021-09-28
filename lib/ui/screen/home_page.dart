import 'dart:io';

import 'package:flashcard_project/design_system.dart';
import 'package:flashcard_project/domain/csv_reader.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CSVReader csvReader = CSVReader();
  late Map<String, String> questionAnswerMap;
  late MapEntry<String, String> flashCardHeader;
  List<String>? questions;
  List<String>? answers;

  @override
  initState() {
    super.initState();
    var file = File(
        "/Users/maxweber/AndroidStudioProjects/flashcard_project/test_data/learn english/lesson_1.csv");
    questionAnswerMap = csvReader.readLessonFrom(file);
    flashCardHeader = questionAnswerMap.entries.toList().removeAt(1);
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
              child: questionAnswerMap.isEmpty
                  ? _buildLoadingSpinner()
                  : Card(
                      elevation: 8.0,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(flashCardHeader.key),
                            Expanded(
                              child: Center(
                                child: Text(
                                  questionAnswerMap.entries.first.key,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.cancel)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.check_circle)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column _buildLoadingSpinner() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text("Your flashcards getting loaded"),
        SizedBox(height: Insets.large),
        CircularProgressIndicator(),
      ],
    );
  }
}
