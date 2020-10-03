class Program {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> categories;
  final String title;

  const Program(this.categories,this.endTime,this.id,this.startTime,this.title);

  Program.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    title = json['title'],
    endTime = DateTime.fromMillisecondsSinceEpoch((json['stop'] as int) * 1000),
    startTime = DateTime.fromMillisecondsSinceEpoch((json['start'] as int) * 1000),
    categories = json['categories'].cast<String>();
}