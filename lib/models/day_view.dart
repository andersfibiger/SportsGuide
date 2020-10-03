import 'program.dart';

class DayView {
  String channelId;
  List<Program> programs;

  DayView(this.channelId,this.programs);

  DayView.fromJson(Map<String, dynamic> json) :
    channelId = json['id'],
    programs = (json['programs'] as List).map((e) => Program.fromJson(e)).toList();

  @override
  bool operator ==(other) {
    return this.channelId == other.channelId;
  }

  @override
  int get hashCode => this.channelId.hashCode;
}

