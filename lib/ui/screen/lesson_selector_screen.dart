import 'package:flashcard_project/domain/files_service.dart';
import 'package:flashcard_project/domain/model/file_information.dart';
import 'package:flashcard_project/ui/screen/home_page.dart';
import 'package:flutter/material.dart';

class LessonSelectorScreen extends StatefulWidget {
  const LessonSelectorScreen({Key? key}) : super(key: key);

  @override
  State<LessonSelectorScreen> createState() => _LessonSelectorScreenState();
}

class _LessonSelectorScreenState extends State<LessonSelectorScreen> {
  FileService fileService = FileService();
  late Future<List<FileInformation>> getPossibleLectures;

  @override
  void initState() {
    super.initState();
    getPossibleLectures = fileService.getPossibleLectures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select your lesson"),
      ),
      body: FutureBuilder<List<FileInformation>>(
          future: getPossibleLectures,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final possibleLecture = snapshot.data;
              if (possibleLecture == null) return Container();
              return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(possibleLecture[index].name),
                    trailing: const Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      HomePage.navigateTo(context, possibleLecture[index].id);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: possibleLecture.length,
              );
            }
            if (snapshot.hasError) return const Text("Something wrong happend");
            return const CircularProgressIndicator();
          }),
    );
  }
}
