import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'model.dart' show mdl;

String serverURL = 'http://raspzero.local';

SocketIO _io;

void showPleaseWait(){

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

void hidePleaseWait(){
  Navigator.of(mdl.rootBuildContext).pop();
}

//Client requests
void connectToServer({@required final BuildContext context,
                      @required final Function callback}){

  _io = SocketIOManager().createSocketIO(serverURL, '/',
      query: '',
      socketStatusCallback: (inData){
        if(inData == 'connect'){
          _io.subscribe('newUser', newUser);
          _io.subscribe('newUser', created);
          _io.subscribe('newUser', closed);
          _io.subscribe('newUser', joined);
          _io.subscribe('newUser', left);
          _io.subscribe('newUser', kicked);
          _io.subscribe('newUser', invited);
          _io.subscribe('newUser', posted);
        }
        _io.init();
        _io.connect();
      });
}

void validate({@required final String userName,
               @required final String password,
               @required final Function callback}){

  showPleaseWait();
  var message = '{\"userName\" : \"$userName\",'
                 '\"password\" : \"$password\"}';
  _io.sendMessage('validate', message,
      (inData){
        Map<String, dynamic> response = jsonDecode(inData);
        hidePleaseWait();
        callback(response['status']);
    }
  );

}

void listRooms({@required final Function callback}){
  showPleaseWait();
  var message = '{}';
  _io.sendMessage('listRooms', message,
      (inData){
        Map<String, dynamic> response = jsonDecode(inData);
        hidePleaseWait();
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

  showPleaseWait();
  var message = '{\"Name\" : \"$roomName\",'
                 '\"description\" : \"$description\",'
                 '\"maxPeople\" : \"$numMaxPeople\",'
                 '\"private\" : \"$isPrivate\",'
                 '\"creator\" : \"$creator\"}';
  _io.sendMessage('create', message,
          (inData){
            Map<String, dynamic> response = jsonDecode(inData);
            hidePleaseWait();
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

  showPleaseWait();
  var message = '{\"userName\" : \"$userName\",'
                 '\"roomName\" : \"$roomName\"}';
  _io.sendMessage('join', message,
          (inData){
              Map<String, dynamic> response = jsonDecode(inData);
              hidePleaseWait();
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

  showPleaseWait();
  var message = '{\"userName\" : \"$userName\",'
                 '\"roomName\" : \"$roomName\"}';
  _io.sendMessage('leave', message,
          (inData){
            Map<String, dynamic> response = jsonDecode(inData);
            hidePleaseWait();
            callback();
          }
  );

}

void listUsers({@required final Function callback}){

  showPleaseWait();
  var message = '{}';
  _io.sendMessage('listRooms', message,
          (inData){
            Map<String, dynamic> response = jsonDecode(inData);
            hidePleaseWait();
            callback(response);
          }
  );

}

void invite({@required final String userName,
             @required final String roomName,
             @required final String inviterName,
             @required final Function callback}){

  showPleaseWait();
  var message = '{\"userName\" : \"$userName\",'
                 '\"roomName\" : \"$roomName\",'
                 '\"inviterName\" : \"$inviterName\"}';
  _io.sendMessage('invite', message,
          (inData){
            Map<String, dynamic> response = jsonDecode(inData);
            hidePleaseWait();
            callback();
          }
  );

}

void post({@required final String userName,
           @required final String roomName,
           @required final String messageToPost,
           @required final Function callback}){

  showPleaseWait();
  var message = '{\"userName\" : \"$userName\",'
                 '\"roomName\" : \"$roomName\",'
                 '\"message\" : \"$messageToPost\"}';
  _io.sendMessage('post', message,
          (inData){
            Map<String, dynamic> response = jsonDecode(inData);
            hidePleaseWait();
            callback(response['status']);
          }
  );

}

void close({@required final String roomName,
            @required final Function callback}){

  showPleaseWait();
  var message =  '{\"roomName\" : \"$roomName\"}';
  _io.sendMessage('close', message,
          (inData){
            Map<String, dynamic> response = jsonDecode(inData);
            hidePleaseWait();
            callback();
          }
  );
}

void kick({@required final String userName,
           @required final String roomName,
           @required final Function callback}){
  showPleaseWait();
  var message = '{\"userName\" : \"$userName\",'
                 '\"roomName\" : \"$roomName\"}';
  _io.sendMessage('kick', message,
          (inData){
        Map<String, dynamic> response = jsonDecode(inData);
        hidePleaseWait();
        callback();
      }
  );

}

//Server broadcast`s handlers
void newUser(){}

void created(){}

void closed(){}

void joined(){}

void left(){}

void kicked(){}

void invited(){}

void posted(){}

