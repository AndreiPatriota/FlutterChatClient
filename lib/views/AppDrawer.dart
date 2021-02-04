import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_chat_client/model.dart' show mdl, FlutterChatModel;
import 'package:flutter_chat_client/connector.dart' show conn;

class AppDrawer extends StatelessWidget{

  @override
  Widget build(BuildContext context) =>
      ScopedModel(
          model: mdl,
          child: ScopedModelDescendant<FlutterChatModel>(
            builder: (inContext, inWidget, inModel)=>
                Drawer(
                  child: Column(
                    children: [
                      Container(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 30, 0, 15),
                          child: ListTile(
                            title: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Center(
                                child: Text(
                                  mdl.userName,
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                            subtitle: Center(
                              child: Text(
                                mdl.currentRoomName,
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/drawback01.jpg')
                          )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: ListTile(
                          leading: Icon(Icons.list),
                          title: Text('Lobby'),
                          onTap: (){
                            Navigator.of(inContext)
                                .pushNamedAndRemoveUntil('Lobby', ModalRoute.withName('/'));
                            conn.listRooms(
                                callback: (inRoomList){
                                  mdl.setRoomsList = inRoomList;
                                }
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: ListTile(
                          leading: Icon(Icons.chat),
                          title: Text('Current Room'),
                          onTap: (){
                            Navigator.of(inContext)
                                .pushNamedAndRemoveUntil('Room', ModalRoute.withName('/'));
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: ListTile(
                          leading: Icon(Icons.supervised_user_circle_outlined),
                          title: Text('User List'),
                          onTap: (){
                            Navigator.of(inContext)
                                .pushNamedAndRemoveUntil('UserList', ModalRoute.withName('/'));
                            conn.listRooms(
                                callback: (inUserList){
                                  mdl.setUsersList = inUserList;
                                }
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
          )
      );

}