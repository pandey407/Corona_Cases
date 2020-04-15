import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LanguageChanger extends ChangeNotifier {
  final String key= "language";
  SharedPreferences _prefs;
  bool _isNepali;
  bool get isNepali => _isNepali;

  LanguageChanger(){
    _isNepali=false;
    _loadFromPrefs();
  }

  
  setLang() {
    _isNepali=!_isNepali;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async{
    if(_prefs==null)
    _prefs=await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async{
    await _initPrefs();
    _isNepali=_prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async{
    await _initPrefs();
    _prefs.setBool(key, _isNepali);
  }
}
