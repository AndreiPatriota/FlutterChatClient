import 'package:flutter/material.dart';
import 'package:flutter_chat_client/Connector.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_chat_client/FlutterChatModel.dart' show mdl, FlutterChatModel;
import 'dart:io' show File, exit;
import 'package:path/path.dart' show join;

class LoginDialog extends StatelessWidget{

  static final GlobalKey<FormState> _loginFormKey = new GlobalKey<FormState>();

  String _userName;
  String _password;

  static void validateWithStoredCredentials(String name, String password){

    conn.connectToServer(
      context: mdl.rootBuildContext,
      callback: (){
        conn.validate(
            userName: name,
            password: password,
            callback: (inStatus)async{
              if(inStatus == 'ok' || inStatus == 'created'){
                mdl..userName = name
                    ..greetings = 'Glad to have you back, $name!!';
              }
              else if(inStatus == 'fail'){
                showDialog(
                  barrierDismissible: false,
                  context: mdl.rootBuildContext,
                  builder: (inContext)=>
                        AlertDialog(
                          title: Text('Validation failed'),
                          content: Text('It appears that the server has been restarted, '
                              'and the username you last used was subsequently taken by someonelse'
                              '\n\nPlease re-start FlutterChat and pick a different username.'),
                          actions: [
                            RaisedButton(
                              child: Text('Ok'),
                              onPressed: (){
                                var credentialFile = File(join(mdl.docsDir.path, 'credentials'));
                                credentialFile.deleteSync();
                                exit(0);
                              }
                            )
                          ],
                        )
                );
              }
            }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) =>
      ScopedModel(
          model: mdl,
          child: ScopedModelDescendant<FlutterChatModel>(
            builder: (inContext, inWidget, inModel)=>
                AlertDialog(
                  content: Container(
                    child: Form(
                      child: Column(
                        children: [
                          Text('Enter username and password to register'
                              'with the server',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(mdl.rootBuildContext).accentColor
                            ),
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            validator: (inString){
                              if(inString.length == 0 || inString.length > 10){
                                return 'Please , enter a valid username '
                                    'with no more the 10 character.';
                              }
                              return null;
                            },
                            onSaved: (inString){
                              _userName = inString;
                            },
                            decoration: InputDecoration(
                              hintText: 'Username', labelText: 'Username'
                            ),
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (inString){
                              if(inString.length == 0){
                                return 'Please, enter a valid password.';
                              }
                              return null;
                            },
                            onSaved: (inString){
                              _password = inString;
                            },
                            decoration: InputDecoration(
                                hintText: 'Password', labelText: 'Password'
                            ),
                          )
                        ],
                      ),
                      key: _loginFormKey,
                    ),
                    height: 220,
                  ),
                  actions: [
                    RaisedButton(
                      child: Text('Login'),
                      onPressed: (){
                        if(_loginFormKey.currentState.validate()){
                          _loginFormKey.currentState.save();
                          conn.connectToServer(
                            context: mdl.rootBuildContext,
                            callback: (){
                              conn.validate(
                                  userName: _userName,
                                  password: _password,
                                  callback: (inSatus)async{
                                    if(inSatus == 'ok'){
                                      mdl..userName = _userName
                                         ..greetings = 'Welcome $_userName!';
                                      Navigator.of(mdl.rootBuildContext).pop();
                                    }
                                    else if(inSatus == 'fail'){
                                      Scaffold.of(mdl.rootBuildContext)
                                          .showSnackBar(
                                          SnackBar(
                                            content: Text('Sorry, this username has already been taken'),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 5),
                                          )
                                      );
                                    }
                                    else if(inSatus == 'created'){
                                      var credentialFile =
                                          File(join(mdl.docsDir.path, 'credentials'));
                                      await credentialFile.writeAsString('$_userName============$_password');

                                      mdl..userName = _userName
                                        ..greetings = 'Welcome to the server $_userName';
                                    }
                                  }
                              );
                            }
                          );

                        }


                      }
                      )
                  ],
                )
          )
      );
  
}