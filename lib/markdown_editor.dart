import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:u3u_panel/globals.dart' as globals;
import 'package:focus_widget/focus_widget.dart';

class MarkdownEditor extends StatefulWidget{
  const MarkdownEditor({Key? key,this.enableMarkdown=true,this.hintText="",required this.controller, required this.focusNodeContent}) : super(key: key);

  final bool enableMarkdown;
  final FocusNode focusNodeContent;
  final String hintText;
  final controller;
  @override
  State<StatefulWidget> createState() {
    return MarkdownEditorState();
  }

}

class MarkdownEditorState extends State<MarkdownEditor>{
  bool showPreview = true;
  String content = "";

  @override
  void initState(){
    showPreview = true;
    content = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.enableMarkdown==false){
      return TextField(
        focusNode: widget.focusNodeContent,
        controller: widget.controller,
        maxLines: 1,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      );
    }
    else{
      return Stack(
        // alignment: AlignmentDirectional.bottomEnd,
        fit: StackFit.passthrough,
        children: [
          TextField(
            focusNode: widget.focusNodeContent,
            controller: widget.controller,
            maxLines: null,
            // style: showPreview?null:const TextStyle(color: Colors.white),
            enabled: showPreview,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isCollapsed: false,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        if(showPreview != true) {
                          widget.focusNodeContent.requestFocus();
                          widget.controller.text = content;
                        } else {
                          widget.focusNodeContent.unfocus();
                          content = widget.controller.text;
                          // widget.controller.text = "";
                          widget.controller.text = '\n'*('\n'.allMatches(content).length);
                        }
                        showPreview = !showPreview;

                      });
                    }, icon: Icon(showPreview?Icons.visibility_off:Icons.visibility),color: showPreview?globals.MyColors.iconColorDisabled:globals.MyColors.iconColor,
                      padding: const EdgeInsets.only(left: 8, right: 0, top: 8, bottom: 8)
                  ),
                  IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return MarkdownEditorFullscreen(enableMarkdown: widget.enableMarkdown,controller: widget.controller,);
                      }));
                    }, icon: const Icon(Icons.fullscreen_rounded),color: globals.MyColors.iconColor,
                    padding: const EdgeInsets.only(left: 0, right: 8, top: 8, bottom: 8)
                  ),

                ],
              )
            ),
          ),
          Offstage(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: MarkdownBody(
                data: content,
                selectable: true,
              ),
            ),
            offstage: showPreview,
          ),
        ],
      );
    }
  }
}

class MarkdownEditorFullscreen extends StatefulWidget{
  MarkdownEditorFullscreen({Key? key,required this.enableMarkdown, required this.controller}) : super(key: key);

  final bool enableMarkdown;
  final controller;
  @override
  State<StatefulWidget> createState() {
    return MarkdownEditorFullscreenState();
  }

}

class MarkdownEditorFullscreenState extends State<MarkdownEditorFullscreen>{
  String content = "";
  bool showPreview = true;
  final FocusNode _focusNodeContent = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("",style:TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
            color: Colors.black
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 24),
          child: Stack(
            children: [
              FocusWidget(
                  child: TextField(
                    focusNode: _focusNodeContent,
                    controller: widget.controller,
                    maxLines: null,
                    // style: widget.showPreview?null:const TextStyle(color: Colors.white),
                    enabled: showPreview,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ), focusNode: _focusNodeContent),
              Positioned(
                bottom: 0,
                right: 0,
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: IconButton(
                        onPressed: (){
                          setState(() {
                            if(showPreview != true) {
                              _focusNodeContent.requestFocus();
                              widget.controller.text = content;
                            } else {
                              _focusNodeContent.unfocus();
                              content = widget.controller.text;
                              widget.controller.text = '\n'*('\n'.allMatches(content).length);
                            }
                            showPreview = !showPreview;

                          });
                        }, icon: Icon(showPreview?Icons.visibility_off:Icons.visibility),color: showPreview?globals.MyColors.iconColorDisabled:globals.MyColors.iconColor,
                        padding: const EdgeInsets.only(left: 8, right: 0, top: 8, bottom: 8)
                    ),
                ),
              ),
              Offstage(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: MarkdownBody(
                      data: content
                  ),
                ),
                offstage: showPreview,
              ),

            ],
          ),
        ),
      )
    );
  }

}