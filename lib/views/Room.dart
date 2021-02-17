import 'package:flutter/material.dart';
import 'package:flutter_chat_client/Connector.dart';
import 'package:flutter_chat_client/views/AppDrawer.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_chat_client/FlutterChatModel.dart' show mdl, FlutterChatModel;

class Room extends StatefulWidget{

  Room({Key key}) : super(key: key);

  @override
  RoomSate createState() => RoomSate();
}

class RoomSate extends State{

  bool _isExpanded = false;
  String _postedMessage;
  final ScrollController _controller = ScrollController();
  final TextEditingController _postEditingController = TextEditingController();

  void _inviteOrKick(final BuildContext inContext,final String inInviteOrKick){

    conn.listUsers(
      callback: (inUsers){
        mdl.setUsersList = inUsers;

        showDialog(
          context: inContext,
          builder: (inContext)=>
            ScopedModel(
              model: mdl,
              child: ScopedModelDescendant<FlutterChatModel>(
                builder: (inContext, inWidget, inModel) =>
                    AlertDialog(
                      title: Text('Select user to $inInviteOrKick'),
                      content: Container(
                        width: double.maxFinite,
                        height: double.maxFinite/2,
                        child: ListView.builder(
                          itemCount: inInviteOrKick == 'invite'?
                              inModel.getUsersList.length:
                              inModel.getCurrentRoomUsers.length,
                          itemBuilder: (inContext, inIdx){

                            Map user;

                            if(inInviteOrKick == 'invite'){
                              user = inModel.getUsersList[inIdx];

                              for(Map oneUser in inModel.getCurrentRoomUsers){
                                if(user['userName'] == oneUser['userName'] ||
                                   user['userName'] == inModel.userName){return Container();}
                              }
                            }
                            else if(inInviteOrKick == 'kick'){
                              user = inModel.getCurrentRoomUsers[inIdx];

                              if(user['userName'] == inModel.userName){return Container();}
                            }

                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                border: Border(
                                  bottom: BorderSide(),
                                  top: BorderSide(),
                                  left: BorderSide(),
                                  right: BorderSide()
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  stops: [.1, .2, .3, .4, .5, .6, .7, .8, .9],
                                  colors: [
                                    Color.fromRGBO(250, 250, 0, .75),
                                    Color.fromRGBO(250, 220, 0, .75),
                                    Color.fromRGBO(250, 190, 0, .75),
                                    Color.fromRGBO(250, 160, 0, .75),
                                    Color.fromRGBO(250, 130, 0, .75),
                                    Color.fromRGBO(250, 110, 0, .75),
                                    Color.fromRGBO(250, 80, 0, .75),
                                    Color.fromRGBO(250, 50, 0, .75),
                                    Color.fromRGBO(250, 0, 0, .75)
                                  ]
                                )
                              ),
                              margin: EdgeInsets.only(top: 10),
                              child: ListTile(
                                title: Text(user['userName']),
                                onTap: (){

                                  if(inInviteOrKick == 'invite'){
                                    conn.invite(
                                      userName: user['userName'],
                                      roomName: inModel.currentRoomName,
                                      inviterName: inModel.userName,
                                      callback: ()=> Navigator.of(inContext).pop()
                                    );
                                  }
                                  else if(inInviteOrKick == 'kick'){
                                    conn.kick(
                                      userName: user['userName'],
                                      roomName: inModel.currentRoomName,
                                      callback: ()=> Navigator.of(inContext).pop()
                                    );
                                  }
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    )
                ,
              )
            )
        );
      }
    );

  }

  @override
  Widget build(BuildContext context) =>
      ScopedModel(
        model: mdl,
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (inContext, inWidget, inModel) =>
              Scaffold(
                drawer: AppDrawer(),
                appBar: AppBar(
                  title: Text(mdl.currentRoomName),
                  actions: [
                    PopupMenuButton(
                      onSelected: (inString){
                        if(inString == 'invite'){
                          _inviteOrKick(inContext, inString);
                        }
                        else if(inString == 'leave'){
                          inModel - inModel.currentRoomName;
                          inModel
                            ..setCurrentRoomUsers = {}
                            ..currentRoomName = FlutterChatModel.DEFAULT_ROOM_NAME
                            ..isCurrentRoomEnabled = false;

                          Navigator.of(inContext).pushNamedAndRemoveUntil(
                              '/', ModalRoute.withName('/'));
                        }
                        else if(inString == 'close'){
                          conn.close(
                            roomName: inModel.currentRoomName,
                            callback: (){
                              Navigator.of(inContext)
                                  .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                            }
                          );
                        }
                        else if(inString == 'kick'){
                          _inviteOrKick(inContext, inString);
                        }
                      },
                      itemBuilder: (inContext)=>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem(child: Text('Invite'), value: 'invite'),
                          PopupMenuItem(child: Text('Leave'), value: 'leave'),
                          PopupMenuItem(child: Text('Close'), value: 'close',
                            enabled: inModel.areCreatorFunctionsEnabled),
                          PopupMenuItem(child: Text('Kick'), value: 'kick',
                              enabled: inModel.areCreatorFunctionsEnabled),
                        ]
                    )
                  ],
                ),
                body: Padding(
                  padding: EdgeInsets.fromLTRB(6, 14, 6, 6),
                  child: Column(
                    children: [
                      ExpansionPanelList(
                        expansionCallback: (inIndex, inExpanded) =>
                            setState(()=> _isExpanded = inExpanded),
                        children: [
                          ExpansionPanel(
                            isExpanded: _isExpanded,
                            headerBuilder: (inContext, inExpended)=>
                                Text('User In Room'),
                            body: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Builder(
                                builder: (inContext){
                                  List<Widget> userList = [];

                                  inModel.getCurrentRoomUsers.forEach(
                                          (userDescriptor) {
                                            userList.add(Text(userDescriptor['userName']));
                                          }
                                  );

                                  return Column(children: userList);
                                },
                              ),
                            )
                          ),
                        ],
                      ),
                      Container(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: inModel.currentRoomMessages.length,
                          itemBuilder: (inContext, inIdx){

                            Map message = inModel.currentRoomMessages[inIdx];

                            return ListTile(
                              title: Text(message['message']),
                              subtitle: Text(message['userName']),
                            );
                          }
                        )
                      ),
                      Divider(),
                      Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _postEditingController,
                              onChanged: (inString){
                                _postedMessage = inString;
                                setState((){});
                              },
                              decoration: InputDecoration.collapsed(hintText: 'Enter message'),
                            )
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                            child: IconButton(
                              icon: Icon(Icons.send),
                              color: Colors.blue,
                              onPressed: (){
                                conn.post(
                                  userName: inModel.userName,
                                  roomName: inModel.currentRoomName,
                                  messageToPost: _postedMessage,
                                  callback: (inStatus){

                                    if(inStatus == 'ok'){
                                      inModel.addMessage(
                                        userName: inModel.userName,
                                        message: _postedMessage
                                      );
                                      _controller.jumpTo(
                                          _controller.position.maxScrollExtent);//Jump to ListViews end.
                                    }
                                  }
                                );
                              },
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
        )
      );
}