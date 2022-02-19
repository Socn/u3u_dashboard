import 'package:flutter/material.dart';
import 'package:u3u_panel/globals.dart' as globals;
import 'package:u3u_panel/api.dart' as api;
import 'dart:core';
import 'package:flutter/cupertino.dart';

class SettingsPage extends StatefulWidget{
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }

}

class SettingsPageState extends State<SettingsPage>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("设置",style:TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("域名"),
            subtitle: globals.settings['host']==null||globals.settings['host']==""?null:Text(globals.settings['host']),
            onTap: (){
              showDialog(context: context, builder: (context){
                return SimpleDialog(
                  title: const Text("域名"),
                  children: [
                    SimpleDialogOption(
                      child: Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 20,
                            child: Radio(
                              onChanged: (value) {},
                              value: "https://u3u.app",
                              groupValue: globals.settings['host'],

                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("https://u3u.app",style: TextStyle(fontSize: 17),),
                        ],
                      ),
                      onPressed: (){
                        globals.settings['host'] = "https://u3u.app";
                        api.writeSettings();
                        api.baseURL = globals.settings['host']+'/api/v1';
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 20,
                            child: Radio(
                              onChanged: (value) {},
                              value: "https://u3u.wsm.ink",
                              groupValue: globals.settings['host'],

                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("https://u3u.wsm.ink",style: TextStyle(fontSize: 17),),
                        ],
                      ),
                      onPressed: (){
                        globals.settings['host'] = "https://u3u.wsm.ink";
                        api.writeSettings();
                        api.baseURL = globals.settings['host']+'/api/v1';
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              }).then((value){
                setState(() {

                });
              });
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("启动后显示页面"),
            subtitle: globals.settings['initPage']==null||globals.settings['initPage']==""?null:Text(globals.settings['initPage']),
            onTap: (){
              showDialog(context: context, builder: (context){
                return SimpleDialog(
                  title: const Text("启动后显示页面"),
                  children: [
                    SimpleDialogOption(
                      child: Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 20,
                            child: Radio(
                              onChanged: (value) {},
                              value: "无",
                              groupValue: globals.settings['initPage'],

                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("无",style: TextStyle(fontSize: 17),),
                        ],
                      ),
                      onPressed: (){
                        globals.settings['initPage'] = "无";
                        api.writeSettings();
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 20,
                            child: Radio(
                              onChanged: (value) {},
                              value: "用户",
                              groupValue: globals.settings['initPage'],

                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("用户",style: TextStyle(fontSize: 17),),
                        ],
                      ),
                      onPressed: (){
                        globals.settings['initPage'] = "用户";
                        api.writeSettings();
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 20,
                            child: Radio(
                              onChanged: (value) {},
                              value: "短链接",
                              groupValue: globals.settings['initPage'],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("短链接",style: TextStyle(fontSize: 17),),
                        ],
                      ),
                      onPressed: (){
                        globals.settings['initPage'] = "短链接";
                        api.writeSettings();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              }).then((value){
                setState(() {

                });
              });
            },
          ),
          const Divider(),
        ],
      ),
    );
  }

}