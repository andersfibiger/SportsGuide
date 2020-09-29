class Program {
  String id;
  DateTime startTime;
  DateTime endTime;
  List<String> categories;
  String title;

  Program.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    title = json['title'],
    endTime = DateTime.fromMillisecondsSinceEpoch((json['stop'] as int) * 1000),
    startTime = DateTime.fromMillisecondsSinceEpoch((json['start'] as int) * 1000),
    categories = json['categories'].cast<String>();
}