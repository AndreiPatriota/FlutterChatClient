import 'package:flutter/material.dart';
import 'package:flutter_chat_client/views/Home.dart';
import 'package:flutter_chat_client/views/LoginDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model.dart' show mdl, FlutterChatModel;
import 'connector.dart' show conn;
import 'dart:io';


void main(){

  startMeUp() async{

    mdl.docsDir = await getApplicationDocumentsDirectory();
    var credentialFiles = File(join(mdl.docsDir.path, 'credentials'));
    bool exists = await credentialFiles.exists();

    var credentials;
    var credParts;

    while(mdl.rootBuildContext == null){}

    if(exists){
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
                  '/Lobby' : (someContext)=>Text('Men At Work'),
                  '/Room' : (someContext)=>Text('Men At Work'),
                  '/UserList' : (someContext)=>Text('Men At Work'),
                  '/CreateRoom' : (someContext)=>Text('Men At Work')
                },
                home: Home(),
              )
        )
    );
  }

}

