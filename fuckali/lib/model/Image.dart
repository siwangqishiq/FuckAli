//图片
class ImageItem{
  int id;
  int sid;
  String name;
  String refer;
  int updateTime;
  String url;

  static ImageItem fromJson(Map<String,dynamic> jsonMap){
    ImageItem section = ImageItem();
    section.id = jsonMap['id'];
    section.sid = jsonMap['sid'];
    section.name = jsonMap['name'];
    section.refer = jsonMap['refer'];
    section.updateTime = jsonMap['updateTime'];
    section.url = jsonMap['url'];
    return section;
  }
}