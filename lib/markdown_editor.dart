import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownEditor extends StatefulWidget{
  const MarkdownEditor({Key? key,this.enableMarkdown=true,this.hintText="",required this.controller}) : super(key: key);

  final bool enableMarkdown;
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
    final FocusNode _focusNodeContent = FocusNode();
    if(widget.enableMarkdown==false){
      return TextField(
        focusNode: _focusNodeContent,
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
            focusNode: _focusNodeContent,
            controller: widget.controller,
            maxLines: null,
            style: showPreview?null:TextStyle(color: Colors.white),
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
              child: IconButton(
                  onPressed: (){
                    setState(() {
                      if(showPreview != true) {
                        _focusNodeContent.requestFocus();
                        widget.controller.text = content;
                      } else {
                        _focusNodeContent.unfocus();
                        content = widget.controller.text;
                        // widget.controller.text = "";
                      }
                      showPreview = !showPreview;

                    });
                  }, icon: const Icon(Icons.visibility)),
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
      );
    }
  }
}

class MarkdownEditorFullscreen extends StatefulWidget{
  const MarkdownEditorFullscreen({Key? key,required this.enableMarkdown}) : super(key: key);

  final bool enableMarkdown;
  @override
  State<StatefulWidget> createState() {
    return MarkdownEditorFullscreenState();
  }

}

class MarkdownEditorFullscreenState extends State<MarkdownEditorFullscreen>{
  @override
  Widget build(BuildContext context) {
    return Text("");
  }

}