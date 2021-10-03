import 'package:flashcard_project/design_system.dart';
import 'package:flashcard_project/ui/screen/lesson_selector_screen.dart';
import 'package:flutter/material.dart';

class CompletionWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const CompletionWidget({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Congratulations! You finished all your cards."),
        const SizedBox(height: Insets.medium),
        ElevatedButton(
          onPressed: onPressed,
          child: const Text("Repeat Lesson"),
        ),
        const SizedBox(height: Insets.medium),
        ElevatedButton(
          onPressed: () {
            LessonSelectorScreen.navigateTo(context);
          },
          child: const Text("Back to Lecture Selection"),
        )
      ],
    );
  }
}
