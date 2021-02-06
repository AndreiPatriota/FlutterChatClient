import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_chat_client/FlutterChatModel.dart' show mdl, FlutterChatModel;
import 'AppDrawer.dart';

class Home extends StatelessWidget{
  @override
  Widget build(BuildContext context) =>
      ScopedModel(
          model: mdl,
          child: ScopedModelDescendant<FlutterChatModel>(
            builder: (inContext, inWidget, inModel)=>
                Scaffold(
                  drawer: AppDrawer(),
                  appBar: AppBar(
                    title: Text('FlutterChat App'),
                  ),
                  body: Center(
                    child: Text(mdl.greetings),
                  ),
                )
          )
      );
}