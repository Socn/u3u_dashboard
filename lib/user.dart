import 'dart:core';
// import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:u3u_panel/classes.dart' as classes;
import 'package:u3u_panel/api.dart' as api;
import 'package:u3u_panel/globals.dart' as globals;
import 'package:u3u_panel/settings.dart';


Color buttonColor = Colors.blueAccent;
WidgetsBinding? widgetsBinding = WidgetsBinding.instance;

class PersonalHome extends StatefulWidget{
  const PersonalHome({Key? key}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => PersonalHomeState(key:key);

}


class PersonalHomeState extends State<PersonalHome>{
  PersonalHomeState({Key? key});

  @override
  Widget build(BuildContext context) {
    //print("Loading");
    TextStyle _title = const TextStyle(fontWeight: FontWeight.w700,fontSize: 18);
    TextStyle _subtitle = const TextStyle(fontWeight: FontWeight.w400,fontSize: 13,color: Color.fromARGB(255, 140, 140, 140));

    return Center(
      child: FutureBuilder(
        future:api.getUserInfo(globals.config['token']??""), builder: (context, AsyncSnapshot<classes.User>snapshot){
        if(globals.config['token'] == ""){
          return Center(
            child: InkWell(
              child: const Text("你还没登录呢orz\n点我去登录\n\n",textAlign: TextAlign.center,style:TextStyle(color: globals.MyColors.secondaryText)),
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context){
                      return const Login();
                    })
                ).then((value){
                  if(value != null){
                    setState(() {
                      globals.config=value;
                    });
                  }
                });
              },
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // 请求失败，显示错误
            return Text("Error: ${snapshot.error}");
          } else {
            // 请求成功，显示数据
            return Column(
              children: <Widget>[
                Card(
                    margin: const EdgeInsets.only(
                      top:15,
                      bottom:15,
                      left:15,
                      right:15,
                    ),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    elevation: 0,
                    color: globals.MyColors.blockColor,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            child:Column(
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          snapshot.data!.email.toString(),
                                          style: const TextStyle(
                                              fontSize: 17
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: -15,
                              left: 0,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  "#"+globals.config['id'].toString(),
                                  style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      color: Color.fromRGBO(0, 0, 0, 0.15)
                                  ),
                                ),
                              )
                          ),
                        ],
                      ),
                    )
                ),

                Card(
                  margin: const EdgeInsets.only(
                    top:15,
                    bottom:15,
                    left:15,
                    right:15,
                  ),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  elevation: 0,
                  color: globals.MyColors.blockColor,
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget>[
                                  Text(
                                    "短链接",
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //用户名等
                          SizedBox(
                              height: 70,
                              child:GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(top:15),
                                crossAxisCount: 3,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.links!.count.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      const Text("我的短链接数")],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.links!.sumTotal.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      const Text("总短链接数")],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.links!.sumToday.toString(),
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400
                                        ),
                                      ),
                                      const Text("今日新增短链接数")],
                                  ),
                                ],
                              )
                          )//个人信息数字
                        ],
                      )
                  ),
                ),

                Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: const EdgeInsets.only(left:20,right:20),
                      title: Text(
                        "设置",
                        style: _title,
                      ),
                      trailing: Text(
                        "APP设置",
                        style: _subtitle,
                      ),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return const SettingsPage();
                        }));
                      },
                    ),
                    _logOut(context)
                  ],
                ),
              ],
            );
          }
        } else {
          // 请求未结束，显示loading
          return const CircularProgressIndicator();
        }
      })
    );
  }

  Widget _logOut(context){
    return SizedBox(
      width: double.infinity,
      child: Card(
        margin: const EdgeInsets.only(top:15,bottom:15,left:15,right:15),
        shadowColor: Colors.redAccent,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        color: Colors.redAccent,
        elevation: 0.0,
        child: TextButton(
          child: const Text(
            "退出登录",
            style: TextStyle(
                color:Colors.white,
                fontSize: 15
            ),
          ),
          onPressed: (){
            _showIfLogout(context);
          },
        ),
      ),
    );
  }

  void _showIfLogout(context){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: const Text('确定要退出登录吗？'),
            actions: <Widget>[
              TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: (){
                  api.logOut();
                  Navigator.pop(context);
                  setState(() {

                  });
                },
                child: const Text('确定'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

}

class Login extends StatefulWidget{
  const Login({Key? key}) : super(key: key);

  // final Function callBack;
  // bool doPop;
  // Login({Key? key,required this.callBack,required this.doPop});
  @override
  createState ()=>LoginState();
}
class LoginState extends State<Login>{
  // final Function callBack;
  // bool doPop=true;
  // LoginState({Key? key,required this.callBack,required this.doPop});
  final FocusNode _focusNodeUserName = FocusNode();
  final FocusNode _focusNodePassWord = FocusNode();
  var usernameController = TextEditingController();
  var userPwdController = TextEditingController();
  String? accessToken;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          elevation: 0,
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
              color: Colors.black
          ),
        ),
        body:
        // Center(
        //     child:
      SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                      height:40
                  ),
                  const Text("    欢迎回来！",
                    style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        height: 1.5
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(
                      height:10
                  ),
                  const Text("    υ3υ",
                    style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        height: 1
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                      height:80
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left:50, right:50, top:0,bottom:200),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            focusNode: _focusNodeUserName,
                            controller: usernameController,
                            keyboardType: TextInputType.emailAddress,
                            maxLines: 1,
                            autocorrect: true,
                            decoration: const InputDecoration(
                              labelText: "用户名或邮箱",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          TextField(
                            focusNode: _focusNodePassWord,
                            controller: userPwdController,
                            maxLines: 1,
                            autocorrect: true,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: "密码",
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 80,),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child:TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                                  shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)))),
                                ),
                                onPressed: () {
                                  if (usernameController.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "用户名或邮箱不能为空",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black45,
                                        textColor: Colors.white
                                    );
                                  }
                                  else if (userPwdController.text.isEmpty) {
                                    Fluttertoast.showToast(
                                        msg: "密码不能为空",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black45,
                                        textColor: Colors.white
                                    );
                                  }
                                  else {
                                    _focusNodeUserName.unfocus();
                                    _focusNodePassWord.unfocus();

                                    setState(() {
                                      isLoading = true;
                                    });

                                    api.getToken(usernameController.text, userPwdController.text).then((value){
                                      if(mounted){
                                        setState(() {
                                          accessToken=value['token'];
                                          isLoading = false;
                                          if( accessToken != null){
                                            Fluttertoast.showToast(
                                                msg: "登录成功",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black45,
                                                textColor: Colors.white
                                            );
                                            Navigator.of(context).pop(value);
                                            api.writeToken(accessToken.toString());
                                            api.writeId(value['id']);
                                          }
                                          else{
                                            isLoading=false;
                                            // print(value['msg']);
                                            Fluttertoast.showToast(
                                                msg: value['msg'].toString(),
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.CENTER,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.black45,
                                                textColor: Colors.white
                                            );
                                          }
                                        });
                                      }
                                    });
                                  }
                                },
                                child: loginButton()
                            ),
                          ),
                          Card(
                            margin: const EdgeInsets.only(top:20),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0))),
                            color: Colors.transparent,
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(top:10,bottom:10,left:30,right:30),
                              child: InkWell(
                                child: const Text("暂不登录",style: TextStyle(color: Colors.black45),),
                                onTap: ()=>Navigator.of(context).pop(<String,dynamic>{
                                  'msg': '',
                                  'token': '',
                                  'id': 0
                                }),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                ],
              ),
            )
        // )
    );
  }
  Widget loginButton(){
    if(isLoading == true){
      buttonColor = Colors.blueAccent.shade200;
      return const Padding(
          padding: EdgeInsets.only(top:5,bottom:5,left:80,right:80),
          child: SizedBox(
            width: 30,
            height:30,
            child: CircularProgressIndicator(
              backgroundColor: Colors.transparent,
              color: Colors.white,
            ),
          )
      );
    }
    else{
      buttonColor = Colors.blueAccent;
      return const Padding(
        padding: EdgeInsets.only(top:5,bottom:5,left:80,right:80),
        child: Text(
          '登录',
          style: TextStyle(
              color: Colors.white, fontSize: 16.0),
        ),
      );
    }
  }
  @override
  void initState() {
    super.initState();
//    widgetsBinding.addPostFrameCallback((callBack){
//      //print("ME Loading OK");
//      this.callBack(true);
//      return true;
//    });
  }
}