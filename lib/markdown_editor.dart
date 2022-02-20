import 'dart:core';
import 'dart:ui';
import 'package:flutter/material.dart';

class MarkdownEditor extends StatefulWidget{
  const MarkdownEditor({Key? key,this.enableMarkdown=true,this.hintText=""}) : super(key: key);

  final bool enableMarkdown;
  final String hintText;
  @override
  State<StatefulWidget> createState() {
    return MarkdownEditorState();
  }

}

class MarkdownEditorState extends State<MarkdownEditor>{
  @override
  Widget build(BuildContext context) {
    if(widget.enableMarkdown==false){
      var contentController = TextEditingController();
      final FocusNode _focusNodeContent = FocusNode();
      return TextField(
        focusNode: _focusNodeContent,
        controller: contentController,
        maxLines: 1,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      );
    }
    else{

    }
  }

}