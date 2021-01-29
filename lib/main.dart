import 'package:flutter/material.dart';
import 'model.dart' show mdl;

void main() {
  //runApp(MyApp());
  var user = 'Joao Chinelao';
  var message = 'Xablau';

  mdl.addMessage(userName: user, message: message);

  print(mdl.currentRoomMessages);
}

