import 'package:flutter/material.dart';
import 'constants.dart';
import 'models.dart';
import 'widget/CommonWidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

class HomePageState extends State<HomePage> {
  //List<>

  @override
  void initState() {
    super.initState();
  }

  void _fetchSections({int pagesize , num updateTime}) async{

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
            itemCount: 100,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 10.0,
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
