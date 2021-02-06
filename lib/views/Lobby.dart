import 'package:flutter/material.dart';
import 'package:flutter_chat_client/views/AppDrawer.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_chat_client/FlutterChatModel.dart' show mdl, FlutterChatModel;
import 'package:flutter_chat_client/Connector.dart' show conn;

class Lobby extends StatelessWidget{

  @override
  Widget build(BuildContext context) =>
      ScopedModel(
          model: mdl,
          child: ScopedModelDescendant<FlutterChatModel>(
            builder: (inContext, inWidget, inModel) =>
                Scaffold(
                  drawer: AppDrawer(),
                  appBar: AppBar(
                    title: Text('Lobby')
                  ),
                  floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white),
                    onPressed: (){
                      Navigator.pushNamed(inContext, '/CreateRoom');
                    },
                  ),
                  body: inModel.getRoomsList.length == 0?
                      Text('There are no rooms yet. Why not add one'):
                      ListView.builder(
                        itemCount: inModel.getRoomsList.length,
                        itemBuilder: (inContext, inCount){
                          Map room = inModel.getRoomsList[inCount];

                          return Column(
                            children: [
                              ListTile(
                                leading: room['private']?
                                    Image.asset('assets/images/private.png'):
                                    Image.asset('assets/images/public.png')
                                ,
                                title: Text(room['roomName']),
                                subtitle: Text(room['description']),
                                onTap: (){
                                  if(room['private'] &&
                                      !inModel.roomInvites.containsKey(room['roomName']) &&
                                      room['creator'] != inModel.userName
                                  ){
                                    Scaffold.of(inContext).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.red,
                                          content: Text("Sorry, you can't enter this room without an invitation")
                                        )
                                    );
                                  }
                                  else{
                                    conn.join(
                                        userName: inModel.userName,
                                        roomName: room['roomName'],
                                        callback: (inStatus, inRoomDescripot){

                                          if(inStatus == 'joined'){
                                            inModel
                                              ..currentRoomName = inRoomDescripot['roomName']
                                              ..setCurrentRoomUsers = inRoomDescripot['users']
                                              ..isCurrentRoomEnabled = true
                                              ..clearCurrentRoomMessages()
                                              ..areCreatorFunctionsEnabled =
                                                  inRoomDescripot['creator'] == inModel.userName;
                                            Navigator.pushNamed(inContext, '/Room');
                                          }
                                          else if(inStatus == 'full'){
                                            Scaffold.of(inContext).showSnackBar(
                                                SnackBar(
                                                  duration: Duration(seconds: 2),
                                                  backgroundColor: Colors.red,
                                                  content: Text('Sorry, the room is full')
                                                )
                                            );
                                          }

                                        }
                                    );
                                  }
                                },
                              ),
                              Divider()
                            ],
                          );
                        }
                      )
                  ,
                )
          )
      );

}