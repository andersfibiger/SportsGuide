class TvProgramDto implements Comparable<TvProgramDto>  {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> categories;
  final String title;
  final String channelId;
  
  const TvProgramDto(this.categories,this.endTime,this.id,this.startTime,this.title, this.channelId);

  @override
  int compareTo(TvProgramDto other) {
    return this.startTime.compareTo(other.startTime);
  }
}