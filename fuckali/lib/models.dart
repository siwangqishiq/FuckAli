// 图片族
class Section {
  int sid;
  String content;
  String link;
  String refer;
  String image;
  num updateTime;
  int imageCount;

  Section();
  
  void showInfo(){
    print("section: sid = ${sid} , content = ${content} , link=${link}, "+
    "refer = ${refer} , image = ${image} , updatime = ${content} , imageCount = ${imageCount}");
  }

  static Section fromJson(Map<String,dynamic> jsonMap){
    Section section = new Section();
    section.sid = jsonMap['sid'];
    section.content = jsonMap['content'];
    section.link = jsonMap['link'];
    section.refer = jsonMap['refer'];
    section.image = jsonMap['image'];
    section.updateTime = jsonMap['updateTime'];
    section.imageCount = jsonMap['imageCount'];

    return section;
  }


}//class


