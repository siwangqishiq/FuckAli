import 'package:FuckAli/HttpClient.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'dart:convert';
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
  List<Section> parseDataFromString(String rawStr) {
    print("parse json str = " + rawStr);
    List<Section> result = [];

    List listJson = json.decode(rawStr);
    listJson.forEach((element) {
      print("parse ${element}");
      result.add(Section.fromJson(element));
    });
    return result;
  }
}

class HomePageState extends State<HomePage> {
  List<Section> sectionList = [];//图片族 数据

  @override
  void initState() {
    super.initState();
    _fetchSections();
  }

  void _fetchSections({int pagesize = 20 , num updateTime = 0}) async{
    print("fetch sections ...");

    final HttpResp sectionResp = await HttpClient.getInstance().sendGet(API_GET_SECTIONS, {'pagesize':pagesize,'updateTime':updateTime},ParseSectionList());

    if(sectionResp.isSuccess()){
      sectionList.clear();
      sectionList.addAll(sectionResp.data);
    }
    
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: RefreshIndicator(
          child: GridView.builder(
            itemCount: sectionList.length ,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
            ),
            itemBuilder: (BuildContext context, int index){
              return Text("Hello ${index}");
            }
          ),
          //指示器颜色
          color: Theme.of(context).primaryColor,
          onRefresh: _refreshData
        ),
      )
    );
  }

  Future<List<Map>> _refreshData() async{
    print("refresh data hahah");
    return null;
  }

}//end class
