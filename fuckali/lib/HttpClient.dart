import 'package:dio/dio.dart';
import 'constants.dart';

class HttpResp{
  int code = -1;
  String msg;
  dynamic data;

  bool isSuccess(){
    return code == 200;
  }
}

/**
 *  解析 接口返回数据的自定义回调
 */
abstract class ParseDataFunc<T>{
  T parseDataFromString(dynamic data);
}

class HttpClient {
  Dio dio;
  static HttpClient instance;

  HttpClient(){
    dio = new Dio();
    dio.options.baseUrl = API_HOST;
    dio.options.connectTimeout = 30 * 1000; //
    dio.options.receiveTimeout = 30 * 1000; //
    dio.options.responseType = ResponseType.json;
    //dio.options.responseType = ResponseType.plain;
  }

  static HttpClient getInstance(){
    if(instance == null){
      instance = new HttpClient();
    }
    return instance;
  }

  /**
   *  发送get请求
   */
  Future<HttpResp> sendGet(String apiUrl , Map<String, dynamic> params,ParseDataFunc parseFunc) async {
    try{
      Response resp;
      resp = await dio.get(apiUrl , queryParameters: params);
      //print("code = ${resp.statusCode}");

      if(resp.statusCode == 200){
        //String respString = resp.data.toString();
        //print(respString);
        
        //Map<String,dynamic> jsonMap = json.decode(respString);
        var jsonMap = resp.data;
        //print("map data = {${jsonMap['data'].runtimeType}");

        // print("code = ${jsonMap['code']}");
        // print("msg = ${jsonMap['msg']}");
        // print("data = ${jsonMap['data']}");
        return await _generatorHttpResp(jsonMap['code'] , jsonMap['msg'] , jsonMap['data'], parseFunc);
      }else{
        //httpResp.code = resp.statusCode;
        return _generatorHttpResp(resp.statusCode , resp.statusMessage , null, parseFunc);
      }
    }catch(e){
      print(e);
      return _generatorHttpResp(-1 , e.toString() , null , parseFunc);
    }
  }

  /**
   * 解析服务端返回的data  
   */
  Future<HttpResp> _generatorHttpResp(int code , String msg, dynamic data , ParseDataFunc parseFunc) async{
    HttpResp resp = new HttpResp();
    resp.code = code;
    resp.msg = msg;
    if(parseFunc != null){
      //print(data.runtimeType);
      //print("dataStr = ${data}");
      resp.data = parseFunc.parseDataFromString(data);
    }
    return resp;
  }

}//end class