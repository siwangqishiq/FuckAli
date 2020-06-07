import 'package:flutter/material.dart';


// app 中使用的网络图片加载控件   请求时自动添加Referer字段
class MeiziImage extends StatelessWidget{
  final String _refer;
  final String _url;
  final Map<String, String> imageHeader = Map<String,String>();

  MeiziImage(this._url , this._refer);

  @override
  Widget build(BuildContext context) {
    imageHeader['Referer'] = _refer;
    return Image.network(_url,headers:imageHeader);
  }
}//end class