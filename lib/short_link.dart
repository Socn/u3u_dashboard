// import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:focus_widget/focus_widget.dart';
import 'package:u3u_panel/api.dart' as api;
import 'dart:ui';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:u3u_panel/markdown_editor.dart';
import 'package:u3u_panel/user.dart';
import 'package:u3u_panel/globals.dart' as globals;
import 'package:u3u_panel/classes.dart' as classes;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:html2md/html2md.dart' as html2md;

String realContent(classes.Content link,{bool? noReplaceVars}){
  if(link.needPassword == true){
    return "需要密码";
  }
  if(link.type == "memo"){
    var tmp = api.decodeBase64(link.content.toString());
    var vars = link.variable;
    if(vars!.variables.isNotEmpty && (noReplaceVars == null || !noReplaceVars)){
      for (var e in vars.variables){
        tmp = tmp.replaceAll(e.key, e.value);
      }
    }
    return tmp;
  }
  else{
    return link.content.toString();
  }
}

class ShortLink extends StatefulWidget{
  const ShortLink({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ShortLinkState();
  }
}

class ShortLinkState extends State<ShortLink>{
  Future<void> _onRefresh() async{
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context){
    String token = globals.config['token'] ?? "";
    int? limit = 20;
    int? offset = 0;
    String? order = "id";
    String? sort = "asc";
    if(token == ''){
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
    return Center(
      child: RefreshIndicator(
          onRefresh: _onRefresh,
          child:FutureBuilder(
              future:api.getShortLinks(token, limit, offset, order, sort),builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // 请求失败，显示错误
                return Text("Error: ${snapshot.error}");
              } else {
                // 请求成功，显示数据
                classes.Links links = snapshot.data;
                if(links.link.isEmpty){
                  return const Text(
                    "你还没有创建过短链接orz",
                    style: TextStyle(
                        color: globals.MyColors.secondaryText
                    ),
                  );
                }
                return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: links.link.length+1,
                    itemBuilder: (BuildContext context, int index){
                      if(index == links.link.length){
                        return const SizedBox(height:200);
                      }
                      classes.Link link = links.link[index];
                      return Column(
                        children: [
                          ListTile(
                              title: Text(link.prefix+"x"+link.suffix),
                              subtitle: Text(realContent(link.content),maxLines: 1,),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context){
                                  return ShortLinkDetail(link.prefix+"x"+link.suffix);
                                }));
                              }
                          ),
                        ],
                      );
                    });
              }
            } else {
              // 请求未结束，显示loading
              return const CircularProgressIndicator();
            }
          })
      ),
    );
  }
}

class AddShortLink extends StatefulWidget{
  final int? id;
  final classes.Content? content;
  final String? password;
  final bool? isEdit;
  const AddShortLink({this.id,this.content,this.password,this.isEdit,Key? key}) : super(key: key);
  // const AddShortLink({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>AddShortLinkState();
}

class AddShortLinkState extends State<AddShortLink>{
  bool _isMemo = false;
  bool _needPassword = false;
  final FocusNode _focusNodeContent = FocusNode();
  final FocusNode _focusNodePassWord = FocusNode();
  final FocusNode _focusNodeTitle = FocusNode();
  // var contentController = TextEditingController();
  var contentController = TextEditingController();
  var userPwdController = TextEditingController();
  var memoTitleController = TextEditingController();
  bool _submitted = false;
  bool _init = false;
  String tempText = "";
  classes.Variables vars = classes.Variables(variables: []);

  // _initF() async{
  //   contentController.insertHtml(md.markdownToHtml(widget.isEdit==null?"":realContent(widget.content!,noReplaceVars: true)));
  // }

  postData() async{
    tempText = html2md.convert(contentController.text);
    // if(widget.isEdit == null) {
    //   api.createLink(_isMemo?"memo":"url", tempText, _needPassword, userPwdController.text, memoTitleController.text,vars).then(
    //           (value){
    //         setState(() {
    //           _submitted = false;
    //           Fluttertoast.showToast(
    //               msg: value['msg'],
    //               toastLength: Toast.LENGTH_SHORT,
    //               gravity: ToastGravity.CENTER,
    //               timeInSecForIosWeb: 1,
    //               backgroundColor: Colors.black45,
    //               textColor: Colors.white
    //           );
    //           if(value['success'] == true){
    //             Navigator.pop(context,{'ok':true});
    //             // Navigator.push(context, MaterialPageRoute(builder: (context){
    //             //   return ShortLinkDetail(value['data']['prefix']+"x"+value['data']['suffix']);
    //             // }));
    //           }
    //         });
    //       });
    // }
    // else{
    //   api.editLink(widget.id!,_isMemo?"memo":"url", tempText, _needPassword, userPwdController.text, memoTitleController.text,vars).then(
    //           (value){
    //         setState(() {
    //           _submitted = false;
    //           Fluttertoast.showToast(
    //               msg: value['msg'],
    //               toastLength: Toast.LENGTH_SHORT,
    //               gravity: ToastGravity.CENTER,
    //               timeInSecForIosWeb: 1,
    //               backgroundColor: Colors.black45,
    //               textColor: Colors.white
    //           );
    //           if(value['success'] == true){
    //             Navigator.pop(context,{'ok':true});
    //             // Navigator.push(context, MaterialPageRoute(builder: (context){
    //             //   return ShortLinkDetail(value['data']['prefix']+"x"+value['data']['suffix']);
    //             // }));
    //           }
    //         });
    //       });
    // }
    setState(() {
      _submitted = true;
    });
  }


  @override
  Widget build(BuildContext context){
    // final contextMain = context;
    if(widget.isEdit != null && _init == false){
      _isMemo = widget.content!.type!="url";
      _needPassword = widget.content!.needPassword;
      vars = widget.content!.variable ?? classes.Variables(variables: []);
      _init = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit==null?"新增短链接":"编辑短链接",style:const TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        actions: [
          IconButton(
              onPressed: (){
                postData();
              },
              icon: const Icon(Icons.done)),
        ],
      ),
      body:SingleChildScrollView(
        child:Stack(
          children: [
            Offstage(
              offstage: !_submitted,
              child: const LinearProgressIndicator(),
            ),
            Padding(
                padding: const EdgeInsets.only(left:30, right:30, top:10,bottom:200),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TextField(
                      //   maxLines: _isMemo==true?null:1,
                      //   minLines: null,
                      //   focusNode: _focusNodeContent,
                      //   controller: contentController,
                      //   keyboardType: TextInputType.multiline,
                      //   scrollPhysics: const NeverScrollableScrollPhysics(),
                      //   textAlign: TextAlign.start,
                      //   textAlignVertical: TextAlignVertical.top,
                      //   decoration: InputDecoration(
                      //       border: const OutlineInputBorder(),
                      //       labelText: _isMemo==true?"备忘录内容":"网址内容",
                      //       hintText: _isMemo==true?"支持Markdown":"需要加上 https:// 或 http://"
                      //   ),
                      // ),
                      // HtmlEditor(
                      //   controller: contentController,
                      //   htmlEditorOptions: HtmlEditorOptions(
                      //     hint: _isMemo==true?"支持Markdown":"需要加上 https:// 或 http://",
                      //     initialText: md.markdownToHtml(widget.isEdit==null?"":realContent(widget.content!,noReplaceVars: true))
                      //   ),
                      // ),
                      FocusWidget(
                          child: MarkdownEditor(controller: contentController,enableMarkdown: _isMemo,focusNodeContent: _focusNodeContent,),
                          focusNode: _focusNodeContent
                      ),
                      Text(tempText),
                      const SizedBox(height:16),
                      Row(
                        children: const [
                          SizedBox(width:8.0),
                          Text("更多选项",style: TextStyle(fontSize: 13,color:globals.MyColors.secondaryText),),
                        ],
                      ),
                      ExpansionPanelList(
                        expandedHeaderPadding: const EdgeInsets.all(0),
                        elevation: 0,
                        expansionCallback: (index, isExpanded){
                          if(widget.isEdit == null){
                            setState(() {
                              _isMemo = !_isMemo;
                            });
                          }
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder: (context, isExpanded){
                              return Row(
                                children: [
                                  const SizedBox(width:8.0),
                                  const Text("便签模式"),
                                  Switch(
                                    value: _isMemo,
                                    activeColor: globals.MyColors.accentColor,
                                    onChanged: (value){
                                      if(widget.isEdit == null){
                                        setState(() {
                                          _isMemo = value;
                                        });
                                      }
                                    },
                                  )
                                ],
                              );
                            },
                            body: Column(
                              children: [
                                TextField(
                                  focusNode: _focusNodeTitle,
                                  controller: memoTitleController,
                                  maxLines: 1,
                                  decoration: const InputDecoration(
                                    labelText: "便签标题（选填）",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 50*(vars.variables.length+1)+vars.variables.length*16,
                                  width: double.infinity,
                                  child: ListView.builder(
                                      itemCount: vars.variables.length*2+1,
                                      itemBuilder: (context,index){
                                        if((index-1)%2==0){
                                          return const Divider();
                                        }
                                        if(index == vars.variables.length*2){
                                          return SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: TextButton(
                                              onPressed: (){
                                                final FocusNode _focusNodeKey = FocusNode();
                                                final FocusNode _focusNodeValue = FocusNode();
                                                var keyController = TextEditingController();
                                                var valueController = TextEditingController();
                                                showModalBottomSheet(
                                                  // enableDrag: false,
                                                  // isDismissible: false,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  backgroundColor: Colors.transparent,
                                                  builder: (BuildContext context){
                                                    return SingleChildScrollView(
                                                      child: DecoratedBox(
                                                        decoration: const BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0),topRight: Radius.circular(24.0))
                                                        ),
                                                        child: Container(
                                                          padding: EdgeInsets.only(top:18,left:24,bottom:MediaQuery.of(context).viewInsets.bottom+24,right:24),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: const [
                                                                  SizedBox(width:8),
                                                                  Align(
                                                                    alignment:Alignment.topLeft,
                                                                    child: Text("添加变量",style: TextStyle(fontSize: 15)),
                                                                  )
                                                                ],
                                                              ),
                                                              const SizedBox(height:12),
                                                              TextField(
                                                                controller: keyController,
                                                                focusNode: _focusNodeKey,
                                                                maxLines: 1,
                                                                scrollPhysics: const NeverScrollableScrollPhysics(),
                                                                textAlign: TextAlign.start,
                                                                textAlignVertical: TextAlignVertical.top,
                                                                decoration: const InputDecoration(
                                                                    border: OutlineInputBorder(),
                                                                    labelText: "key",
                                                                    hintText: "要替换的内容"
                                                                ),
                                                              ),
                                                              const SizedBox(height:24),
                                                              TextField(
                                                                controller: valueController,
                                                                focusNode: _focusNodeValue,
                                                                maxLines: 1,
                                                                scrollPhysics: const NeverScrollableScrollPhysics(),
                                                                textAlign: TextAlign.start,
                                                                textAlignVertical: TextAlignVertical.top,
                                                                decoration: const InputDecoration(
                                                                    border: OutlineInputBorder(),
                                                                    labelText: "value",
                                                                    hintText: "替换成的内容"
                                                                ),
                                                              ),
                                                              const SizedBox(height:24),
                                                              SizedBox(
                                                                  width: double.infinity,
                                                                  height: 60,
                                                                  child: TextButton(
                                                                    style: ButtonStyle(
                                                                      backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                                                                      shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)))),
                                                                    ),
                                                                    onPressed: (){
                                                                      Navigator.pop(context,[classes.Variable(key:keyController.text,value:valueController.text)]);
                                                                    },
                                                                    child: const Text("完成",style: TextStyle(color: Colors.white,),),
                                                                  )
                                                              ),
                                                              TextButton(
                                                                onPressed: (){
                                                                  Navigator.pop(context);
                                                                },
                                                                child: const Text("取消",style: TextStyle(color: globals.MyColors.secondaryText,),),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                ).then((value) {
                                                  if(value != null){
                                                    setState(() {
                                                      vars.variables.add(value[0]);
                                                    });
                                                  }
                                                });
                                                // setState(() {
                                                //   vars.variables.add(classes.Variable(key: "key"+index.toString(), value: "value"+index.toString()));
                                                // });
                                              },
                                              child: Row(
                                                children:const [
                                                  Icon(Icons.add),
                                                  Text("添加变量"),
                                                ]
                                              ),
                                            ),
                                          );
                                        }
                                        else{
                                          return SizedBox(
                                            height:50,
                                            child: ListTile(
                                              title: Text(vars.variables[index~/2].key+" -> "+vars.variables[index~/2].value),
                                              trailing: const Icon(Icons.edit),
                                              onTap: (){
                                                final FocusNode _focusNodeKey = FocusNode();
                                                final FocusNode _focusNodeValue = FocusNode();
                                                var keyController = TextEditingController();
                                                var valueController = TextEditingController();
                                                keyController.text = vars.variables[index~/2].key;
                                                valueController.text = vars.variables[index~/2].value;
                                                showModalBottomSheet(
                                                    // enableDrag: false,
                                                    // isDismissible: false,
                                                    isScrollControlled: true,
                                                    context: context,
                                                    backgroundColor: Colors.transparent,
                                                    builder: (BuildContext context){
                                                      return SingleChildScrollView(
                                                        child: DecoratedBox(
                                                          decoration: const BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0),topRight: Radius.circular(24.0))
                                                          ),
                                                          child: Container(
                                                            padding: EdgeInsets.only(top:18,left:24,bottom:MediaQuery.of(context).viewInsets.bottom+24,right:24),
                                                            // height: 400,
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: const [
                                                                    SizedBox(width:8),
                                                                    Align(
                                                                      alignment:Alignment.topLeft,
                                                                      child: Text("编辑变量",style: TextStyle(fontSize: 15)),
                                                                    )
                                                                  ],
                                                                ),
                                                                const SizedBox(height:12),
                                                                TextField(
                                                                  controller: keyController,
                                                                  focusNode: _focusNodeKey,
                                                                  maxLines: 1,
                                                                  scrollPhysics: const NeverScrollableScrollPhysics(),
                                                                  textAlign: TextAlign.start,
                                                                  textAlignVertical: TextAlignVertical.top,
                                                                  decoration: const InputDecoration(
                                                                      border: OutlineInputBorder(),
                                                                      labelText: "key",
                                                                      hintText: "要替换的内容"
                                                                  ),
                                                                ),
                                                                const SizedBox(height:24),
                                                                TextField(
                                                                  controller: valueController,
                                                                  focusNode: _focusNodeValue,
                                                                  maxLines: 1,
                                                                  scrollPhysics: const NeverScrollableScrollPhysics(),
                                                                  textAlign: TextAlign.start,
                                                                  textAlignVertical: TextAlignVertical.top,
                                                                  decoration: const InputDecoration(
                                                                      border: OutlineInputBorder(),
                                                                      labelText: "value",
                                                                      hintText: "替换成的内容"
                                                                  ),
                                                                ),
                                                                const SizedBox(height:24),
                                                                SizedBox(
                                                                    width: double.infinity,
                                                                    height: 60,
                                                                    child: TextButton(
                                                                      style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
                                                                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)))),
                                                                      ),
                                                                      onPressed: (){
                                                                        Navigator.pop(context,[classes.Variable(key:keyController.text,value:valueController.text)]);
                                                                      },
                                                                      child: const Text("完成",style: TextStyle(color: Colors.white,),),
                                                                    )
                                                                ),
                                                                const SizedBox(height:24),
                                                                SizedBox(
                                                                    width: double.infinity,
                                                                    height: 60,
                                                                    child: TextButton(
                                                                      style: ButtonStyle(
                                                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                                                                        shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4.0)))),
                                                                      ),
                                                                      onPressed: (){
                                                                        Navigator.pop(context,[classes.Variable(key:"",value:""),true]);
                                                                      },
                                                                      child: const Text("删除变量",style: TextStyle(color: Colors.white,),),
                                                                    )
                                                                ),
                                                                SizedBox(
                                                                  height: 60,
                                                                  child: TextButton(
                                                                    onPressed: (){
                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: const Text("取消",style: TextStyle(color: globals.MyColors.secondaryText,),),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                ).then((value) {
                                                  if(value != null){
                                                    if(value[1] == true){
                                                      setState(() {
                                                        vars.variables.removeAt(index~/2);
                                                      });
                                                    }
                                                    else{
                                                      setState(() {
                                                        vars.variables[index~/2]=value[0];
                                                      });
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                          );
                                        }
                                      },
                                    physics: const NeverScrollableScrollPhysics(),
                                  ),
                                ),
                                // Text(
                                //   json.encode(vars.toJson()),
                                // ),
                              ],
                            ),
                            isExpanded: _isMemo,
                            backgroundColor: Colors.transparent,
                            canTapOnHeader: true
                          ),
                        ]
                      ),
                      ExpansionPanelList(
                        expandedHeaderPadding: const EdgeInsets.all(0),
                        elevation: 0,
                        expansionCallback: (index, isExpanded){
                          if(widget.isEdit == null){
                            setState(() {
                              _needPassword = !_needPassword;
                            });
                          }
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder: (context, isExpanded){
                              return Row(
                                children: [
                                  const SizedBox(width:8.0),
                                  const Text("需要密码"),
                                  Switch(
                                    value: _needPassword,
                                    activeColor: globals.MyColors.accentColor,
                                    onChanged: (value){
                                      if(widget.isEdit == null){
                                        setState(() {
                                          _needPassword = value;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                            body: TextField(
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
                            isExpanded: _needPassword,
                            backgroundColor: Colors.transparent,
                            canTapOnHeader: true
                          )
                        ]
                      ),
                    ],
                  ),
                )
            ),
          ],
        )
      )
    );
  }
}

class ShortLinkDetail extends StatefulWidget{
  final String code;
  const ShortLinkDetail(this.code,{Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=>ShortLinkDetailState();
}

class ShortLinkDetailState extends State<ShortLinkDetail>{
  var passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> isOwner = ValueNotifier<bool>(false);
  classes.Link? link;

  Widget editButton(BuildContext context , value , Widget? child){
    if(value == true){
      return IconButton(onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context){
          return AddShortLink(id:link!.id, content:link!.content, password:"",isEdit:true);
        }));
      }, icon: const Icon(Icons.edit));
    }
    else{
      return const SizedBox(height:1,width:1);
    }
  }
  Widget deleteButton(BuildContext context , value , Widget? child){
    if(value == true){
      return IconButton(onPressed: (){
        _deleteLink(context);
      }, icon: const Icon(Icons.delete_forever));
    }
    else{
      return const SizedBox(height:0,width:0);
    }
  }

  void _deleteLink(BuildContext context) async{
    // ignore: unused_local_variable
    final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('提示'),
            content: Text('确定要删除这条'+(link!.mode=="url"?"短链接":"便签")+"吗？"),
            actions: <Widget>[
              TextButton(
                onPressed: (){
                  Navigator.pop(context,{"deleted":false});
                },
                child: const Text('我手滑了'),
              ),
              TextButton(
                onPressed: (){
                  api.deleteLink(link!.id);
                  Navigator.pop(context,{"deleted":true});
                },
                child: const Text('毁灭吧'),
              ),
            ],
          );
        }).then((value){
          if(value['deleted'] == true){
            Navigator.pop(context);
          }
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("详细",style:TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: isOwner,
            builder: deleteButton
          ),
          ValueListenableBuilder(
            valueListenable: isOwner,
            builder: editButton
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder(
              future:api.getLinkDetail(widget.code),
              builder: (context, AsyncSnapshot snapshot){
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // 请求失败，显示错误
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // 请求成功，显示数据
                    link = snapshot.data;
                    // print(link!.toJson().toString());
                    if(link!.content.needPassword){
                      return Column(
                        children: [
                          const Text("需要密码",style: TextStyle(fontSize: 23),),
                          TextField(
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                            controller: passwordController,
                            focusNode: _focusNode,
                          )
                        ],
                      );
                    }

                    if(link!.owner == globals.config['id']){
                      Future.delayed(const Duration(milliseconds: 50)).then((value) => isOwner.value = true);
                    }

                    return Column(
                      children: [
                        (link!.mode=="url"||link!.content.title=="")?const SizedBox(height:0):Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: const EdgeInsets.only(
                              top:5,
                              left:15+10,
                            ),
                            child: Row(
                              children: [
                                const DecoratedBox(
                                  decoration: BoxDecoration(color: Colors.black),
                                  child: SizedBox(width: 5, height: 23)
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  link!.content.title,
                                  style: const TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            ),
                          ),
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
                                                link!.mode=="url"?
                                                Text(
                                                  realContent(link!.content),
                                                  style: const TextStyle(
                                                      fontSize: 17
                                                  ),
                                                ):
                                                MarkdownBody(
                                                    data:realContent(link!.content),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      bottom: -15,
                                      left: -10,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          (link!.mode=="url"?"短链接":"便签" )+" #"+link!.id.toString(),
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
                              margin: const EdgeInsets.only(top:20,bottom:20,left:5,right:5),
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                      height: 50,
                                      child:GridView.count(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        padding: const EdgeInsets.only(top:5),
                                        crossAxisCount: 4,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                globals.RelativeDateFormat.format(DateTime.parse(link!.createdDate)),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    height: 1,
                                                    fontWeight: FontWeight.w400
                                                ),
                                                maxLines: 1,
                                              ),
                                              const Text("创建时间")],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                globals.RelativeDateFormat.format(DateTime.parse(link!.lastSeenDate)),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    height: 1,
                                                    fontWeight: FontWeight.w400
                                                ),
                                                maxLines: 1,
                                              ),
                                              const Text("最近访问")],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                link!.todayUsedTimes.toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    height: 1,
                                                    fontWeight: FontWeight.w400
                                                ),
                                                maxLines: 1,
                                              ),
                                              const Text("今日访问次数")],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text(
                                                link!.totalUsedTimes.toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    height: 1,
                                                    fontWeight: FontWeight.w400
                                                ),
                                                maxLines: 1,
                                              ),
                                              const Text("总访问次数")],
                                          ),
                                        ],
                                      )
                                  )//个人信息数字
                                ],
                              )
                          ),
                        ),
                      ],
                    );
                  }
                } else {
                  // 请求未结束，显示loading
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      )
    );
  }
}