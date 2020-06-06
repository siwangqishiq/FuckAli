// 图片族
class Section {
  int sid;
  String content;
  String link;
  String refer;
  String image;
  num updateTime;
  int imageCount;

  Section(){
  }

  static Section fromJson(Map<String,dynamic> jsonMap){
    Section section = new Section();
    section.sid = jsonMap['sid'];
    section.content = jsonMap['content'];
    section.link = jsonMap['link'];
    return section;
  }
}//class


