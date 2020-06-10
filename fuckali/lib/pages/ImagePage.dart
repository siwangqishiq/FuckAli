import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models.dart';

class ImagePage extends StatefulWidget {
  final Section section;
  ImagePage(this.section);

  @override
  State<StatefulWidget> createState() {
    return ImagePageState(section);
  }
}//end class

class ImagePageState extends State<ImagePage> {
  Section section;

  ImagePageState(this.section);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("XXX,adddd"),
      // ),
      body: Text(section.content)
    );
  }

}//end class
