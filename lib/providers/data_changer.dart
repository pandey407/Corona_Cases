import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataChanger extends ChangeNotifier {
  final String key = "data";
  SharedPreferences _prefs;
  bool _isglobal;
  bool get isglobal => _isglobal;

  DataChanger() {
    _isglobal = true;
    _loadFromPrefs();
  }

  setData() {
    _isglobal = !_isglobal;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _isglobal = _prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _isglobal);
  }
}
