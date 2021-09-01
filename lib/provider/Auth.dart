import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_shop/models/HttpException.dart';

class Auth with ChangeNotifier {
  static var token = '';
  DateTime _expireDate = DateTime.now();
  static String userId = '';



  bool get isAuth{
    return token1 != null;
  }

  String? get token1 {
    if (token != '' &&
        _expireDate.isAfter(DateTime.now()) &&
        _expireDate != DateTime.now()

    ) {
      return token;
    }
    return null;
  }

  Future<void> _authenticate(
      String? email, String? password, String segmentUrl) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$segmentUrl?key=AIzaSyAW66L1Zc-NUMYkZELSBxiYCTDsC4YNbF0';
    Uri myUri = Uri.parse(url);
    try {
      final response = await http.post(myUri,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']['message'].toString());
        throw HttpException(responseData['error']['message']);
      }
      if(segmentUrl=='signInWithPassword') {
        token = 'vMXEKrQqyHYdBvrsX69LFchfkDF2D19hP7fmoQR9';
        userId = responseData['localId'].toString();
        print('token :$token');
        print('userId :$userId');
        _expireDate = DateTime.now().add(
          Duration(
            seconds: int.parse(
              responseData['expiresIn'],
            ),
          ),
        );

        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> signUp(String? email, String? password) async {
    _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(String? email, String? password) async {
    _authenticate(email, password, 'signInWithPassword');
  }

  void logOut(){
    token='';
    userId='';
    _expireDate=DateTime.now();

    notifyListeners();
  }

 /* void autoLogOut(){
    if(_authTimer!=null as Timer){
      _authTimer.cancel();
    }
    final timeToExpire=_expireDate.difference(DateTime.now()).inSeconds;
    _authTimer=Timer(Duration(seconds:timeToExpire),logOut);
  }*/
}
