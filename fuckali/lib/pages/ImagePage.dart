import 'package:FuckAli/HttpClient.dart';
import 'package:FuckAli/model/Image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:preload_page_view/preload_page_view.dart';
import '../model/Section.dart';
import '../constants.dart';

class ImagePage extends StatefulWidget {
  final Section section;
  final int _initPageIndex;
  ImagePage(this.section , this._initPageIndex);

  @override
  State<StatefulWidget> createState() {
    return ImagePageState(section , _initPageIndex);
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

  List<ImageItem> imageList = [];
  int currentPage;
  int initPage;
  PreloadPageController _mPageViewController;
  bool hasFetchData = false;

  ImagePageState(Section sec , int init){
    this.section = sec;
    this.currentPage = 0;
    this.initPage = init;
    _mPageViewController = PreloadPageController();
    //print("Image Page State construct $initPage");
  }

  @override
  void initState() {
    super.initState();
    //SystemChrome.setEnabledSystemUIOverlays([]);
    _fetchImage();
  }

  // @override
  // void didUpdateWidget(ImagePage oldWidget){
  //   super.didUpdateWidget(oldWidget);
  //   print("didUpdateWidget");
  // }

  @override
  void dispose() {
    if(_mPageViewController != null){
      _mPageViewController.dispose();
    }
    super.dispose();
  }

  void _fetchImage() async{
    final HttpResp resp = await HttpClient.getInstance().sendGet(API_GET_IMAGES, {'sid':section.sid},ParseImageItemFunc());
    if(resp.isSuccess()){
      setState(() {
        imageList.clear();
        imageList.addAll(resp.data);
        
        currentPage = initPage;
        _mPageViewController.jumpToPage(initPage);
      });
    }else{
      Navigator.of(context).pop(0);
      Fluttertoast.showToast(msg: "请求失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: (){
          Navigator.of(context).pop(currentPage);
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
    //print("_mPageViewController.initialPage = ${_mPageViewController.initialPage}");

    return PreloadPageView.builder(
      itemBuilder: (context , index){
        return _createImageItem(context , imageList[index]);
      },
      itemCount: imageList.length,
      scrollDirection: Axis.horizontal,
      preloadPagesCount: 3,
      onPageChanged: (index){
        setState(() {
          currentPage = index;
        });
      },
      controller: _mPageViewController,
    );

    // return PreloadPageView(
    //   children: List.generate(imageList.length, (index) => _createImageItem(context , imageList[index])),
    //   preloadPagesCount: 5,
    //   onPageChanged: (index){
    //     //print("index  = $index");
    //     setState(() {
    //       currentPage = index;
    //     });
    //   },
    //   controller: _mPageViewController,
    //   scrollDirection: Axis.horizontal,
    // );
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
