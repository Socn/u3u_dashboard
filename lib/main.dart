import 'package:flutter/material.dart';
import 'package:u3u_panel/launch_page.dart';
import 'package:u3u_panel/settings.dart';
import 'package:u3u_panel/user.dart';
import 'dart:io';
import 'dart:ui' as ui;
// import 'dart:html' as html;
// import 'package:u3u_panel/launch_page.dart';
import 'short_link.dart';
import 'package:u3u_panel/globals.dart' as globals;

String? token;

void main() {
  runApp(const MaterialApp(home:LaunchPage()));
}

String launchText = "";


String title = "υ3υ";
Widget page = Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(launchText),
    ],
  ),
);
class U3UApp extends StatelessWidget {
  const U3UApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'υ3υ 面板',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const U3UHomePage(),
    );
  }
}

class U3UHomePage extends StatefulWidget {
  const U3UHomePage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<U3UHomePage> createState() => U3UHomePageState();
}

class U3UHomePageState extends State<U3UHomePage> {

  @override
  void initState(){
    if(globals.settings['initPage'] == '用户'){
      page = const PersonalHome();
      title = '用户';
    }
    if(globals.settings['initPage'] == '短链接'){
      page = const ShortLink();
      title = '短链接';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Map<String,List<Widget>> actions={
      "短链接":[
        IconButton(
            onPressed: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>const AddShortLink())
              ).then((value){
                if(value!=null && value['ok'] == true){
                  setState(() {
                    page = const ShortLink();
                  });
                }
              });
            },
            icon: const Icon(Icons.add))
      ]
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title,style:const TextStyle(color: Colors.black)),
        actions: actions[title],
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.black
        ),
      ),
      body: page,
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: (Platform.isAndroid==true?MediaQueryData.fromWindow(ui.window).padding.top:0)
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("用户"),
              onTap: ()=>setPage("用户"),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("短链接"),
              onTap: ()=>setPage("短链接"),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("设置"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                  return const SettingsPage();
                }));
              }
            )
          ],
        ),
      ),
    );
  }

  void setPage(String o){
    title = o;
    switch(o){
      case "用户":{
        setState(() {
          if(globals.config['token'] != '') {
            page=const PersonalHome();
            Navigator.of(context).pop();
          } else{
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context){
                return const Login();
              })
            ).then((value){
              if(value['token'] != ''){
                globals.config=value;
                token=value['token'];
                setState(() {
                  page=const PersonalHome();
                  Navigator.of(context).pop();
                });
              }
              else{
                setState(() {
                  Navigator.of(context).pop();
                });
              }
            });
          }
        });
      }
      break;
      case "短链接":{
        setState(() {
          Navigator.of(context).pop();
          page=const ShortLink();
        });
      }
    }
  }
}
