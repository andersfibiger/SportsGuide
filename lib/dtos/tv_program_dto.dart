
import 'package:SportsGuide/models/program.dart';

class TvProgramDto {
  List<Program> programs;
  String channelLogo;
  
  TvProgramDto(this.channelLogo, this.programs);
}