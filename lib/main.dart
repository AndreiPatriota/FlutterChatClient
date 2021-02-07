import 'package:flutter/material.dart';
import 'package:flutter_chat_client/views/Home.dart';
import 'package:flutter_chat_client/views/LoginDialog.dart';
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;
import 'package:scoped_model/scoped_model.dart';
import 'FlutterChatModel.dart' show mdl, FlutterChatModel;
import 'Connector.dart' show conn;
import 'dart:io';
import 'views/Lobby.dart';
import 'views/CreateRoom.dart';

startMeUp() async{

  mdl.docsDir = await getApplicationDocumentsDirectory();
  var credentialFiles = File(join(mdl.docsDir.path, 'credentials'));
  var credentials;
  var credParts;

  while(mdl.rootBuildContext == null){}

  if(await credentialFiles.exists()){
    credentials = await credentialFiles.readAsString();
    credParts = credentials.split('============');
    LoginDialog.validateWithStoredCredentials(credParts[0], credParts[1]);
  }
  else{
    await showDialog(
        context: mdl.rootBuildContext,
        barrierDismissible: false,
        builder: (BuildContext inContext)=>LoginDialog()
    );
  }
}


void main(){

  WidgetsFlutterBinding.ensureInitialized();
  startMeUp();
  runApp(MaterialApp(
    home: FlutterChat(),
  )
  );
}

class FlutterChat extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    mdl.rootBuildContext = context;

    return ScopedModel<FlutterChatModel>(
        model: mdl,
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (inContext, Widget inWidget, inMdl)=>
              MaterialApp(
                initialRoute: '/',
                routes: {
                  '/Lobby' : (someContext)=>Lobby(),
                  '/Room' : (someContext)=>Text('Men At Work'),
                  '/UserList' : (someContext)=>Text('Men At Work'),
                  '/CreateRoom' : (someContext)=>CreateRoom()
                },
                home: Home(),
              )
        )
    );
  }

}

