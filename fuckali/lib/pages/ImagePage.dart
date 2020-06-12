import 'package:FuckAli/HttpClient.dart';
import 'package:FuckAli/model/Image.dart';
import 'package:FuckAli/widget/CommonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:preload_page_view/preload_page_view.dart';
import '../model/Section.dart';
import '../constants.dart';

class ImagePage extends StatefulWidget {
  final Section section;
  ImagePage(this.section);

  @override
  State<StatefulWidget> createState() {
    return ImagePageState(section);
  }
}//end class

class ParseImageItemFunc implements ParseDataFunc {
  @override
  parseDataFromString(dynamic data) {
    List<ImageItem> result = [];
    if(data is List){
      data.forEach((item) {
        result.add(ImageItem.fromJson(item));
      });
    }
    return result;
  }
}

class ImagePageState extends State<ImagePage> {
  Section section;
  PageController _pageController;

  List<ImageItem> imageList = [];
  ImagePageState(this.section);
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    _fetchImage();
  }

  @override
  void dispose() {
    if(_pageController != null){
      _pageController.dispose();
    }
    super.dispose();
  }

  void _fetchImage() async{
    final HttpResp resp = await HttpClient.getInstance().sendGet(API_GET_IMAGES, {'sid':section.sid},ParseImageItemFunc());
    if(resp.isSuccess()){
      setState(() {
        imageList.clear();
        imageList.addAll(resp.data);

//        for(ImageItem it  in imageList){
//          print("${it.url}");
//        }//end for each
      });
    }else{
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "请求失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: (){
          Navigator.of(context).pop();
        },
        onLongPress: (){
          print("on long press ");
        },
        child:Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child:  Stack(
            children: [
              _createPageView(context),
              Align(
                alignment: Alignment.bottomRight,
                child: Card(
                  margin: EdgeInsets.all(8),
                  color: Color.fromARGB(100, 0, 0, 0),
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0))
                  ),
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                        "${currentPage + 1} / ${section.imageCount}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0
                      ),
                    ),
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _createPageView(BuildContext context){
    return PreloadPageView(
      children: List.generate(imageList.length, (index) => _createImageItem(context , imageList[index])),
      preloadPagesCount: 5,
      onPageChanged: (index){
        print("index  = $index");
        setState(() {
          currentPage = index;
        });
      },
    );
  }

  Widget _createImageItem(BuildContext context , ImageItem item){
    final Map<String, String> imageHeader = Map<String,String>();
    imageHeader['Referer'] = item.refer;

    return PhotoView(
      backgroundDecoration: BoxDecoration(color: Colors.black),
        imageProvider: NetworkImage(
          item.url,
          headers: imageHeader
        ),
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 40.0,
          height: 40.0,
          child: CircularProgressIndicator(),
//          child: CircularProgressIndicator(
//            value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
//          ),
        ),
      ),
      loadFailedChild: Icon(Icons.network_check),
    );
  }
}//end class
