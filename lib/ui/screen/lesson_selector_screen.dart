import 'package:flashcard_project/domain/files_service.dart';
import 'package:flashcard_project/domain/model/file_information.dart';
import 'package:flashcard_project/repository/gdrive_repo.dart';
import 'package:flashcard_project/ui/screen/home_page.dart';
import 'package:flutter/material.dart';

class LessonSelectorScreen extends StatefulWidget {
  const LessonSelectorScreen({Key? key}) : super(key: key);

  @override
  State<LessonSelectorScreen> createState() => _LessonSelectorScreenState();

  static void navigateTo(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return const LessonSelectorScreen();
      },
    ));
  }
}

class _LessonSelectorScreenState extends State<LessonSelectorScreen> {
  FilesService fileService = FilesService(GDriveRepo());
  late Future<List<LectureFolder>> getPossibleLectures;

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
      body: FutureBuilder<List<LectureFolder>>(
          future: getPossibleLectures,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final possibleLectureFolders = snapshot.data;
              if (possibleLectureFolders == null) return Container();
              return CustomScrollView(
                slivers: [
                  for (var lectureFolder in possibleLectureFolders) ...[
                    SliverAppBar(
                      title: Text(
                        lectureFolder.name,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.black),
                      ),
                      centerTitle: false,
                      backgroundColor: Colors.white,
                      forceElevated: true,
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return ListTile(
                          title: Text(lectureFolder.spreadsheets[index].name),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            HomePage.navigateTo(
                              context,
                              lectureFolder.spreadsheets[index].id,
                            );
                          },
                        );
                      }, childCount: lectureFolder.spreadsheets.length),
                    )
                  ]
                ],
              );
            }
            if (snapshot.hasError) return const Text("Something wrong happend");
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
