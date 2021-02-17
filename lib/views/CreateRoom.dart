import 'package:flutter/material.dart';
import 'package:flutter_chat_client/views/AppDrawer.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_chat_client/FlutterChatModel.dart' show mdl, FlutterChatModel;
import 'package:flutter_chat_client/Connector.dart' show conn;

class CreateRoom extends StatefulWidget{

  CreateRoom({Key key}) : super(key : key);

  @override
  CreateRoomSate createState() => CreateRoomSate();
}

class CreateRoomSate extends State{

  String _title;
  String _description;
  bool _private = false;
  double _maxPeople = 25;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) =>
      ScopedModel(
          model: mdl,
          child: ScopedModelDescendant<FlutterChatModel>(
            builder: (inContext, inWidget, inModel)=>
                Scaffold(
                  resizeToAvoidBottomPadding: false,
                  appBar: AppBar(
                    title: Text('Create Room'),
                  ),
                  drawer: AppDrawer(),
                  bottomNavigationBar: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          FlatButton(
                            onPressed: (){
                              FocusScope.of(inContext).requestFocus(FocusNode());//Hide keyboard
                              Navigator.of(inContext).pop();//Remove the Screen
                            },
                            child: Text('Cancel')
                          ),
                          FlatButton(
                            onPressed: (){
                              if(_formKey.currentState.validate()){return;}
                              _formKey.currentState.save();

                              int maxPeople = _maxPeople.truncate();
                              conn.create(
                                roomName: _title,
                                creator: inModel.userName,
                                numMaxPeople: maxPeople,
                                isPrivate: _private,
                                description: _description,
                                callback: (inStatus, inRoomsMap){
                                  if(inStatus == 'created'){
                                    inModel.setRoomsList = inRoomsMap;
                                    FocusScope.of(inContext).requestFocus(FocusNode());//Hides keyboard
                                    Navigator.of(inContext).pop();//Drop screen
                                  }
                                  else if(inStatus == 'exists'){
                                    Scaffold.of(inContext).showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.red,
                                          content: Text('Room name already exists. Pick another name.')
                                        )
                                    );
                                  }
                                }
                              );
                            },
                            child: Text('Save')
                          )
                        ],
                      ),
                    ),
                  ),
                  body: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        ListTile(
                          leading: Icon(Icons.subject_rounded),
                          title: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Room name',
                                labelText: 'Room name'
                            ),
                            onSaved: (inString){
                              setState(() => _title = inString);
                            },
                            validator: (inString){
                              if(inString.length == 0 || inString.length > 14){
                                return 'Please, enter a valid room name,'
                                    ' with no more than 14 words.';
                              }
                              return null;
                            },
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.description),
                          title: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Room description',
                                labelText: 'Room description (optional)'
                            ),
                            validator: (inString){
                              return null;
                            },
                            onSaved: (inString){
                              setState(() => _description = inString);
                            },
                          ),
                        ),
                        ListTile(
                          leading: Text('Max\nPeople'),
                          title: Slider(
                            min: 1,
                            max: 99,
                            value: _maxPeople,
                            onChanged: (inValue){
                              setState(() => _maxPeople = inValue);
                            },
                          ),
                          trailing: Text('${_maxPeople.toStringAsFixed(0)}'),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              Text('Private'),
                              Switch(
                                value: _private,
                                onChanged: (inBoolean) =>
                                    setState(() => _private = inBoolean),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                    ),
                  ),
                )
          );

}