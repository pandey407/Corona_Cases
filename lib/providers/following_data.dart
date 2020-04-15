import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'following.dart';
import 'package:flutter/material.dart';

class FollowingData extends ChangeNotifier {
  List<Following> _followings = [];
  FollowingData data;
  List<Following> get followings => _followings;
  List<String> _names;
  int get totalFollowings => _followings.length;
  SharedPreferences _prefs;
  List<String> get names=>_names;
  String key='follow';
  _initPrefs() async{
    if(_prefs==null)
    _prefs=await SharedPreferences.getInstance();
  }

  FollowingData(){
    _names=[];
    _loadFromPrefs();
    notifyListeners();
  }

  _loadFromPrefs() async{
    await _initPrefs();
    _names=_prefs.getStringList(key);
    notifyListeners();
  }

  _saveToPrefs() async{
    await _initPrefs();
    _prefs.setStringList(key, _names);
  }

  void follow(Following country) {
    _followings.add(country);
      if(!_names.contains(country.country))
        _names.add(country.country);
    _saveToPrefs();
    //print(_names);
    notifyListeners();
  }

  void unfollow(Following country) {
    _followings.remove(country);
    names.forEach((f){
      if(f==country.country)
        _names.remove(f);
         print(_names);
    });
     
    _saveToPrefs();
    //print(_names);
    notifyListeners();
    }
    
}
