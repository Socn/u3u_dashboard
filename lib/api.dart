import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:u3u_panel/classes.dart' as classes;
import 'package:u3u_panel/globals.dart' as globals;

String baseURL="https://u3u.wsm.ink/api/v1";

String encodeBase64(String data){
  var content = utf8.encode(data);
  var digest = base64Encode(content);
  return digest;
}

String decodeBase64(String data){
  Uint8List base64deBody = base64Decode(data);
  return const Utf8Decoder().convert(base64deBody);
}

Future<Map<String,dynamic> >getToken(String email, String password) async {
  var uri = Uri.parse(baseURL+'/tokens/user');
  try{
    var request = await http.post(
        uri,
        headers:<String, String>{'Content-Type':'application/json',},
        body: json.encode(<String,String>{'email':email,'password':password})
    );
    var responseBody = request.body;
    Map data = json.decode(responseBody);
    String code = data['code'];
    if(code == "success"){
      return <String, dynamic>{
        'msg': data['msg'],
        'token': data['data']['token'],
        'id': data['data']['id']
      };
    }
    else{
      return <String, dynamic>{
        'msg': data['msg']
      };
    }
  }catch(e){
    return <String, dynamic>{
      'msg': e
    };
  }

}

Future<classes.Links>getShortLinks(String token,int? limit,int? offset,String? order,String? sort) async {
  limit ??= 20;
  offset ??= 0;
  order ??= "id";
  sort ??= "asc";
  // try{
    var uri = Uri.parse(baseURL+"/users/links?limit=$limit&offset=$offset&order=$order&sort=$sort");
    var request = await http.get(
      uri,
      headers:<String, String>{'Content-Type':'application/json','Authorization':token},
    );
    var responseBody = request.body;
    Map data = json.decode(responseBody);
    String payload=json.encode(data['data']);
    return classes.Links.fromJson(json.decode("{\"link\":$payload}"));
  // }catch(e){
  //   return classes.Links(link: [classes.Link(id: 0, state: false, mode: "url", prefix: "", suffix: "", rootPath: "", owner: 0, content: classes.Content(type: "",needPassword: false,content: "",title: "",variable: classes.Variables(variables: [])), createdDate: "", lastSeenDate: "", totalUsedTimes: 0, todayUsedTimes: 0)]);
  // }

}

Future<classes.User>getUserInfo(String token) async {
  try{
    if(globals.userInfo!=null){
      return globals.userInfo!;
    }
    var uri = Uri.parse(baseURL+"/users");
    var request = await http.get(
      uri,
      headers:<String, String>{'Content-Type':'application/json','Authorization':token},
    );
    var responseBody = request.body;
    Map data = json.decode(responseBody);
    return globals.userInfo = classes.User.fromJson(data['data']);
  } catch(e){
    return classes.User();
  }
}

Future<Map<String,dynamic> >createLink(String mode, String content, bool needPassword, String? password, String? title, classes.Variables? vars) async {
  try{
    var uri = Uri.parse(baseURL+'/links');
    var payload = <String,dynamic>{
      'mode':mode,
      'need_password':needPassword,
      'content':content,
    };
    if(mode == "memo"){
      payload['content'] = encodeBase64(content);
    }
    if(needPassword){
      payload['password'] = password;
    }
    if(title != null){
      payload['title'] = title;
    }
    if(vars != null){
      // print(vars.toJson().toString());
      payload['variable'] = vars.toJson();
    }
    var request = await http.post(
        uri,
        headers:<String, String>{'Content-Type':'application/json','Authorization': globals.config['token']},
        body: json.encode(payload)
    );
    var responseBody = request.body;
    Map data = json.decode(responseBody);
    String code = data['code'];
    if(code == "success"){
      return <String, dynamic>{
        'success': true,
        'msg': data['msg'],
        'data': data['data']
      };
    }
    else{
      return <String, dynamic>{
        'success': false,
        'msg': data['msg']
      };
    }
  }catch(e){
    return <String, dynamic>{
      'success': false,
      'msg': e
    };
  }
}

Future<Map<String,dynamic> >editLink(int id, String mode, String content, bool needPassword, String? password, String? title, classes.Variables? vars) async {
  try{
    var uri = Uri.parse(baseURL+'/links/'+id.toString());
    var payload = <String,dynamic>{
      'mode':mode,
      'need_password':needPassword,
      'content':content,
    };
    if(mode == "memo"){
      payload['content'] = encodeBase64(content);
    }
    if(needPassword){
      payload['password'] = password;
    }
    if(title != null){
      payload['title'] = title;
    }
    if(vars != null){
      // print(vars.toJson().toString());
      payload['variable'] = vars.toJson();
    }
    var request = await http.patch(
        uri,
        headers:<String, String>{'Content-Type':'application/json','Authorization': globals.config['token']},
        body: json.encode(payload)
    );
    var responseBody = request.body;
    Map data = json.decode(responseBody);
    String code = data['code'];
    if(code == "success"){
      return <String, dynamic>{
        'success': true,
        'msg': data['msg'],
        'data': data['data']
      };
    }
    else{
      return <String, dynamic>{
        'success': false,
        'msg': data['msg']
      };
    }
  }catch(e){
    return <String, dynamic>{
      'success': false,
      'msg': e
    };
  }
}

Future<classes.Link>getLinkDetail(String code) async{
  try{
    var uri = Uri.parse(baseURL+'/links/'+code);
    var request = await http.get(
      uri,
      headers:<String, String>{'Content-Type':'application/json','Authorization':globals.config['token']},
    );
    var responseBody = request.body;
    Map data = json.decode(responseBody);
    return classes.Link.fromJson(data['data']);
  }catch(e){
    return classes.Link(id: 0, state: false, mode: "url", prefix: "", suffix: "", rootPath: "", owner: 0, content: classes.Content(type: "",needPassword: false,content: "",title: "",variable: classes.Variables(variables: [])), createdDate: "", lastSeenDate: "", totalUsedTimes: 0, todayUsedTimes: 0);
  }
}

Future<bool>deleteLink(int id) async{
  try{
    var uri = Uri.parse(baseURL+'/links/'+id.toString());
    var request = await http.delete(
      uri,
      headers:<String, String>{'Content-Type':'application/json','Authorization':globals.config['token']},
    );
    return request.statusCode == 200;
  }catch(e){
    return false;
  }
}

Future<String?>readToken() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(!prefs.containsKey('token')){
    await prefs.setString('token', "");
  }
  String? token = prefs.getString('token');
  return token;
}
Future<bool>writeToken(String token) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('token', token);
}

Future<Map<String,dynamic>> readSettings() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(!prefs.containsKey('settings')){
    await prefs.setString('settings', json.encode(globals.settings));
  }
  Map<String,dynamic> settings = json.decode(prefs.getString('settings').toString());
  return settings;
}
Future<bool>writeSettings() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setString('settings', json.encode(globals.settings));
}


Future<int?>readId() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if(!prefs.containsKey('id')){
    await prefs.setInt('id', 0);
  }
  int? id = prefs.getInt('id');
  return id;
}
Future<bool>writeId(int id) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.setInt('id', id);
}

Future<bool>logOut() async{
  writeId(0);
  globals.config = {
    'msg': '',
    'token': '',
    'id': 0
  };
  return writeToken("");
}