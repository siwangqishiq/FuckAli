import 'package:FuckAli/HttpClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'constants.dart';
import 'models.dart';
import 'widget/CommonWidget.dart';


void main() =>runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: APP_NAME),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class ParseSectionList implements ParseDataFunc<List<Section>>{
  @override
  List<Section> parseDataFromString(dynamic data) {
    List<Section> result = [];
    if(data is List){
      data.forEach((item){
        result.add(Section.fromJson(item));
      });
    }
    return result;
  }
}

class HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  List<Section> sectionList = [];//图片族 数据
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    
    _scrollController = ScrollController();
    _scrollController.addListener((){
      //print("pos = ${_scrollController.position.pixels}");
      //print("max = ${_scrollController.position.maxScrollExtent}");

      if(isLoading)
        return;

      if(_scrollController.position.pixels >= _scrollController.position.maxScrollExtent){//滑动到底部
        _loadMore();
      }
    });


    _fetchSections(false);
  }

  @override
  void dispose() {
    super.dispose();
    if(_scrollController != null){
      _scrollController.dispose();
    }
  }

  //分页加载更多
  void _loadMore(){ 
    print("loadMore...");
    var lastUpdateTime = _findLastSectionUpdateTime();
    _fetchSections(true , updateTime: lastUpdateTime);
  }

  void _fetchSections(bool isAppend , {int pagesize = 20 , num updateTime = 0}) async{
    if(isLoading)
      return;
    
    isLoading = true;
    print("fetch sections ... updateTime = $updateTime");

    final HttpResp sectionResp = await HttpClient.getInstance().sendGet(API_GET_SECTIONS, 
    {'pagesize':pagesize,'updatetime':updateTime},ParseSectionList());

    if(sectionResp.isSuccess()){
      print("request success");
      setState(() {
        if(!isAppend){
          sectionList.clear();
        }
        sectionList.addAll(sectionResp.data);
      });
    }else{
      print("request error");
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
        child: RefreshIndicator(
          child: GridView.builder(
            itemCount: sectionList.length ,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: 1/1.5,
            ),
            itemBuilder: (BuildContext context, int index){
              return createItemWidget(index, sectionList[index]);
            },
            controller: _scrollController,
          ),
          //指示器颜色
          // color: Theme.of(context).primaryColor,
          onRefresh: _refreshData
        ),
      )
    );
  }

  Widget createItemWidget(int pos , Section section){
    //return Text(section.content);
    return Container(
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 8.0,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        child: Stack(
          children: <Widget>[
            MeiziImage(section.image, section.refer),
            Align(
              child: Container(
                padding: EdgeInsets.all(4),
                color: Color.fromARGB(100, 0, 0, 0),
                child: Text(
                  section.content,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
              alignment: Alignment.bottomLeft
            )
          ],
        )
      ),
    );
  }

  Future<void> _refreshData() async{
    _fetchSections(false, pagesize: 20);
    return null;
  }

  // 获取图片簇
  num _findLastSectionUpdateTime(){
    if(sectionList.length == 0)
      return 0;
    
    return sectionList[sectionList.length - 1].updateTime;
  }

}//end class
