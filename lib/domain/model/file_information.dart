class LectureInformation {
  final String name;
  final String id;

  LectureInformation(this.name, this.id);
}

class LectureFolder {
  final String name;
  final List<LectureInformation> spreadsheets;

  LectureFolder(this.name, this.spreadsheets);
}
