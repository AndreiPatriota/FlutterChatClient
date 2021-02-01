import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'model.dart' show mdl, FlutterChatModel;

class Connector{
  String serverURL = 'http://raspzero.local';

  SocketIO _io;

  void _showPleaseWait(){

    showDialog(
        context: mdl.rootBuildContext,
        barrierDismissible: false,
        builder: (BuildContext inContext)=>
            Dialog(
              child: Container(
                width: 150,
                height: 150,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(
                    color: Colors.blue[200]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(
                          value: null,
                          strokeWidth: 10,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          'Please wait, connecting server...',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
    );
  }

  void _hidePleaseWait(){
    Navigator.of(mdl.rootBuildContext).pop();
  }

//Client requests
  void connectToServer({@required final BuildContext context,
    @required final Function callback}){

    _io = SocketIOManager().createSocketIO(serverURL, '/',
        query: '',
        socketStatusCallback: (inData){
          if(inData == 'connect'){
            _io.subscribe('newUser', _newUser);
            _io.subscribe('created', _created);
            _io.subscribe('closed', _closed);
            _io.subscribe('joined', _joined);
            _io.subscribe('left', _left);
            _io.subscribe('kicked', _kicked);
            _io.subscribe('invited', _invited);
            _io.subscribe('posted', _posted);
          }
          _io.init();
          _io.connect();
        });
  }

  void validate({@required final String userName,
    @required final String password,
    @required final Function callback}){

    _showPleaseWait();
    var message = '{\"userName\" : \"$userName\",'
                   '\"password\" : \"$password\"}';
    _io.sendMessage('validate', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          callback(response['status']);
        }
    );

  }

  void listRooms({@required final Function callback}){
    _showPleaseWait();
    var message = '{}';
    _io.sendMessage('listRooms', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          callback(response);
        }
    );
  }

  void create({@required final String roomName,
    final String description = '',
    final int numMaxPeople = 20,
    final bool isPrivate = false,
    @required final String creator,
    @required final Function callback}){

    _showPleaseWait();
    var message = '{\"Name\" : \"$roomName\",'
        '\"description\" : \"$description\",'
        '\"maxPeople\" : \"$numMaxPeople\",'
        '\"private\" : \"$isPrivate\",'
        '\"creator\" : \"$creator\"}';
    _io.sendMessage('create', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          if(response['status'] == 'exists'){
            callback(response['status'], {});
          }
          else if(response['status'] == 'created'){
            callback(response['status'], response['rooms']);
          }
        }
    );

  }

  void join({@required final String userName,
    @required final String roomName,
    @required final Function callback}){

    _showPleaseWait();
    var message = '{\"userName\" : \"$userName\",'
                   '\"roomName\" : \"$roomName\"}';
    _io.sendMessage('join', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          if(response['status'] == 'full'){
            callback(response['status'], {});
          }
          else if(response['status'] == 'joined'){
            callback(response['status'], response['room']);
          }
        }
    );
  }

  void leave({@required final String userName,
    @required final String roomName,
    @required final Function callback}){

    _showPleaseWait();
    var message = '{\"userName\" : \"$userName\",'
        '\"roomName\" : \"$roomName\"}';
    _io.sendMessage('leave', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          callback();
        }
    );

  }

  void listUsers({@required final Function callback}){

    _showPleaseWait();
    var message = '{}';
    _io.sendMessage('listRooms', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          callback(response);
        }
    );

  }

  void invite({@required final String userName,
    @required final String roomName,
    @required final String inviterName,
    @required final Function callback}){

    _showPleaseWait();
    var message = '{\"userName\" : \"$userName\",'
        '\"roomName\" : \"$roomName\",'
        '\"inviterName\" : \"$inviterName\"}';
    _io.sendMessage('invite', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          callback();
        }
    );

  }

  void post({@required final String userName,
    @required final String roomName,
    @required final String messageToPost,
    @required final Function callback}){

    _showPleaseWait();
    var message = '{\"userName\" : \"$userName\",'
        '\"roomName\" : \"$roomName\",'
        '\"message\" : \"$messageToPost\"}';
    _io.sendMessage('post', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          callback(response['status']);
        }
    );

  }

  void close({@required final String roomName,
    @required final Function callback}){

    _showPleaseWait();
    var message =  '{\"roomName\" : \"$roomName\"}';
    _io.sendMessage('close', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          callback();
        }
    );
  }

  void kick({@required final String userName,
    @required final String roomName,
    @required final Function callback}){
    _showPleaseWait();
    var message = '{\"userName\" : \"$userName\",'
                   '\"roomName\" : \"$roomName\"}';
    _io.sendMessage('kick', message,
            (inData){
          Map<String, dynamic> response = jsonDecode(inData);
          _hidePleaseWait();
          callback();
        }
    );

  }

//Server broadcast`s handlers
  void _newUser(inData){
    Map<String, dynamic> payload = jsonDecode(inData);
    mdl.setUsersList = payload;
  }

  void _created(inData){
    Map<String, dynamic> payload = jsonDecode(inData);
    mdl.setRoomsList = payload;
  }

  void _closed(inData){
    Map<String, dynamic> payload = jsonDecode(inData);
    mdl.setRoomsList = payload;

    if(payload['roomName'] == mdl.currentRoomName){
      mdl - payload['roomName'];
      mdl..setCurrentRoomUsers = {}
        ..currentRoomName = FlutterChatModel.DEFAULT_ROOM_NAME
        ..isCurrentRoomEnabled = false
        ..greetings = 'The room you were in was closed by its creator';
      Navigator.of(mdl.rootBuildContext)
          .pushNamedAndRemoveUntil("/", ModalRoute.withName('/'));
    }
    else{
      mdl- payload['roomName'];
    }
  }

  void _joined(inData){
    Map<String, dynamic> payload = jsonDecode(inData);

    if(mdl.currentRoomName == payload['roomName']){
      mdl.setCurrentRoomUsers = payload['users'];
    }
  }

  void _left(inData){
    Map<String, dynamic> payload = jsonDecode(inData);

    if(mdl.currentRoomName == payload['roomName']){
      mdl.setCurrentRoomUsers = payload['users'];
    }
  }

  void _kicked(inData){
    Map<String, dynamic> payload = jsonDecode(inData);

    if(!payload['users'].keys.contains(mdl.userName)){
      if(payload['roomName'] == mdl.currentRoomName){
        mdl - payload['roomName'];
        mdl..setCurrentRoomUsers = {}
          ..currentRoomName = FlutterChatModel.DEFAULT_ROOM_NAME
          ..isCurrentRoomEnabled = false
          ..greetings = 'You have been kicked out of this room. Fuck off!!';
        Navigator.of(mdl.rootBuildContext)
            .pushNamedAndRemoveUntil("/", ModalRoute.withName('/'));
      }
      else{
        mdl - payload['roomName'];
      }
    }
    else if(payload['roomName'] == mdl.currentRoomName){
      mdl.setCurrentRoomUsers = payload['users'];
    }
    
  }

  void _invited(inData){
    Map<String, dynamic> payload = jsonDecode(inData);

    if(payload['userName'] == mdl.userName){
      mdl + payload['roomName'];

      Scaffold.of(mdl.rootBuildContext).showSnackBar(
        SnackBar(
          content: Text('You have been invited to the room\n'
                '${payload["roomName"]} by user ${payload["inviterName"]}\n'
                'You can now enter from the lobby.'),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: (){},
          ),
        ),
      );
    }
  }

  void _posted(inData){
    Map<String, dynamic> payload = jsonDecode(inData);

    if(mdl.currentRoomName == payload['roomName']){
      mdl.addMessage(userName: payload['userName'],
                     message: payload['message']);
    }
  }

}

Connector conn = Connector();

