class TvProgramDto  {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> categories;
  final String title;
  final String channelId;
  
  const TvProgramDto(this.categories,this.endTime,this.id,this.startTime,this.title, this.channelId);
}