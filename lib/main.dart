import 'package:flutter/material.dart';
import 'model.dart' show mdl;
import 'connector.dart' show conn;

void main() {
  //runApp(MyApp());
  var user = 'Joao Chinelao';
  var message = 'Xablau';

  conn.post(
      userName: 'Joao Silva',
      roomName: 'Reuniao Mensal',
      messageToPost: 'Nao consigo logar',
      callback: (){});

  print(mdl.currentRoomMessages);
}

