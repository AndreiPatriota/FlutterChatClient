import 'package:flutter/material.dart';
import 'package:flutter_chat_client/views/AppDrawer.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_chat_client/FlutterChatModel.dart' show mdl, FlutterChatModel;

class UserList extends StatelessWidget{

  @override
  Widget build(BuildContext context) =>
      ScopedModel(
          model: mdl,
          child: ScopedModelDescendant<FlutterChatModel>(
            builder: (inContext, inWidget, inModel)=>
                Scaffold(
                  appBar: AppBar(title: Text('Users List')),
                  drawer: AppDrawer(),
                  body: GridView.builder(
                    itemCount: inModel.getUsersList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3
                    ),
                    itemBuilder: (inContext, inIdx){

                      Map user = inModel.getUsersList[inIdx];

                      return Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: GridTile(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  child: Image.asset('assets/images/user.png'),
                                ),
                              ),
                              footer: Text(
                                user['userName'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  ),
                )
          )
      );
}