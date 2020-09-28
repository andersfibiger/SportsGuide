class Channel {
  final String id;
  final String title;
  final String icon;
  final String logo;
  final String svgLogo;
  final int sort;

  Channel.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    title = json['title'],
    icon = json['icon'],
    logo = json['logo'],
    svgLogo = json['svgLogo'],
    sort = json['sort'];
}