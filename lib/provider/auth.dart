import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _name;
  String _session;

  bool get isAuth {
    return session != null;
  }

  String get session {
    if (_session != null) {
      return _session;
    }
    return null;
  }

  Future<void> login(String email, String password) async {
    final url =
        'https://testonliant.griffins.com/?p=connect&req=UserLogin&fmt=JSON';

    try {
      final response = await http.post(url, body: {
        'userId': email,
        'password': password,
      });
      final resData = json.decode(response.body);
      final resDataSuccess = int.parse(resData['content']['success']);
      if (resDataSuccess > 0) {
        _name = resData['userId'];
        _session = resData['header']['rlSession'];
        notifyListeners();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'session': _session,
        });
        var userDataSaved = await prefs.setString('userData', userData);
        print(userDataSaved);
      } else {
        throw HttpException('Login failed!');
      }
    } catch (err) {}
  }

  _getPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final extractedUserData = json.decode(prefs.getString('userData'));
    return extractedUserData;
  }

  Future<bool> tryAutoLogin() async {
    final userData = await _getPreferences();

    final url =
        "https://testonliant.griffins.com/?p=connect&req=SessionStatus&rlSession=$userData['session']";
    final response = await http.post(url);
    final resData = json.decode(response.body);

    if(userData['session'] != resData['header']['rlSession']) {
      print('Not equal');
      _session = null;
      return false;
    }
    _session = resData['header']['rlSession'];
    notifyListeners();
    if (userData == null) {
      return false;
    }
    return true;
  }
}
