import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:u3u_panel/main.dart';
import 'package:u3u_panel/api.dart' as api;
import 'package:u3u_panel/globals.dart' as globals;
import 'package:permission_handler/permission_handler.dart';

class LaunchPage extends StatelessWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const LaunchPageWidget();
  }
}

class LaunchPageWidget extends StatefulWidget {
  const LaunchPageWidget({Key? key}) : super(key: key);

  // BuildContext context;
  // LaunchPageWidget({Key? key, required this.context}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LaunchState();
}




String launchText="υ3υ";
bool loadingOk=false;
class LaunchState extends State<LaunchPageWidget> {
  // BuildContext context;
  // LaunchState({required this.context});
  Future<bool> permissions() async{
    launchText = "获取储存权限状态";
    final status = await Permission.storage.status;
    launchText = "获取状态完成";

    if (status.isDenied) {
      launchText = "获取储存权限";
      await Permission.storage.request();
    }
    launchText = "获取权限完成";
    return true;
  }
  Future<bool> _init() async{
    String? token = await api.readToken();
    int? id = await api.readId();
    globals.settings = await api.readSettings();
    api.baseURL = globals.settings['host']+'/api/v1';
    globals.config=<String,dynamic>{
      'msg': '',
      'token': token ?? "",
      'id': id ?? 0
    };
    launchText = "获取Token完成";
    return true;
  }


  @override
  void initState() {
    super.initState();
    permissions();
    _init().then((value){
      // setState(() {
        loadingOk = true;
        Future.delayed(const Duration(seconds: 1),(){
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return const U3UApp();
          }));
        });
        launchText = "获取token完成";
      // });
    });
  }

  @override
  void dispose() {
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: FutureBuilder(
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    Text(launchText)
                  ],
                ),
              );
            }),
      ),
    );
  }
}
