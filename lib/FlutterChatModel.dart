import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class FlutterChatModel extends Model{

  //Class Parameter
  static final String DEFAULT_ROOM_NAME = 'Not currently in a room';

  //Instance Parameters
  BuildContext rootBuildContext;
  Directory docsDir;
  String _greetings;
  String _userName;
  String _currentRoomName;
  List _currentRoomUsers;
  List _currentRoomMessages;
  bool _isCurrentRoomEnabled;
  List _roomsList;
  List _usersList;
  bool _areCreatorFunctionsEnabled;
  Map _roomInvites;

  //Constructor
  FlutterChatModel(){
     _greetings = '';
     _userName = '';
     _currentRoomName = DEFAULT_ROOM_NAME;
     _currentRoomUsers = [];
     _isCurrentRoomEnabled = false;
     _currentRoomMessages = [];
     _roomsList = [];
     _usersList = [];
     _areCreatorFunctionsEnabled = false;
     _roomInvites = {};
  }

  //Setters and Getters
  set greetings(final String inGreetings){
    _greetings = inGreetings;
    notifyListeners();
  }

  String get greetings => _greetings;

  set userName(final String inUserName){
    _userName = inUserName;
    notifyListeners();
  }

  String get userName => _userName;

  set currentRoomName (final String inCurrentRoomName){
    _currentRoomName = inCurrentRoomName;
    notifyListeners();
  }

  String get currentRoomName => _currentRoomName;

  set isCurrentRoomEnabled (final bool inRoomState){
    _isCurrentRoomEnabled = inRoomState;
    notifyListeners();
  }

  bool get isCurrentRoomEnabled => _isCurrentRoomEnabled;

  set areCreatorFunctionsEnabled (final bool inCreatorFunctionsState){
    _isCurrentRoomEnabled = inCreatorFunctionsState;
    notifyListeners();
  }

  bool get areCreatorFunctionsEnabled => _areCreatorFunctionsEnabled;

  List get currentRoomMessages => _currentRoomMessages;

  set setRoomsList(final Map inRoomsList){
    var rooms = [];

    inRoomsList.keys.forEach((roomName) {
      rooms.add(inRoomsList[roomName]);
    });

    _roomsList = rooms;
    notifyListeners();
  }

  List get getRoomsList => _roomsList;

  set setUsersList(final Map inUsersList){
    var users = [];

    inUsersList.keys.forEach((userName) {
      users.add(inUsersList[userName]);
    });

    _usersList = users;
    notifyListeners();
  }

  List get getUsersList => _usersList;

  set setCurrentRoomUsers(final Map inCurrentRoomUsers){
    var currentUsers = [];

    inCurrentRoomUsers.keys.forEach((userName) {
      currentUsers.add(inCurrentRoomUsers[userName]);
    });

    _currentRoomUsers = currentUsers;
    notifyListeners();
  }

  List get getCurrentRoomUsers => _currentRoomUsers;

  void operator + (final String inRoomName){
    this._roomInvites[inRoomName] = true;
  }

  void operator - (final String inRoomName){
    this._roomInvites.remove(inRoomName);
  }

  Map get roomInvites => _roomInvites;

  //Other methods
  void addMessage({@required final String userName,
                   @required final String message}){

    var mens = {'userName':userName, 'message':message};
    _currentRoomMessages.add(mens);
    notifyListeners();
  }

  void clearCurrentRoomMessages(){
    _currentRoomMessages.clear();
  }
}

FlutterChatModel mdl = FlutterChatModel();