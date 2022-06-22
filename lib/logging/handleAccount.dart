import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:scannerapp/api/api.dart';
import 'package:scannerapp/logging/bloc.dart';
import 'package:scannerapp/logging/login.dart';
import 'package:scannerapp/logging/upload.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account {
  static register(BuildContext context, String type, Bloc bloc) async {
    var data = {
      'name': bloc.namec,
      'email': bloc.emailc,
      'password': bloc.passwordc,
      'phone_number': bloc.phonec,
      'type': type,
      // 'password_confirmation': Rbloc.Confc,
    };

    print(type);

    Response res = await CallApi().postData(data, "register");
    var body = json.decode(res.body);
    print(body['message']);
    if (res.statusCode == 200) {
      if (body['user'] == "User") {
        Navigator.pushNamed(context, '/sign-in');
      } else {
        Navigator.pushNamed(context, '/upload');
      }
    } else if (res.statusCode == 501) {
      snack("account already exist", context);
    } else {
      print(res.statusCode);
    }
  }

  static login(BuildContext context) async {
    var data = {
      'email': Lbloc.emailc,
      'password': Lbloc.passwordc,
    };

    Response res = await CallApi().postData(data, "login");
    print(data);
    var body = json.decode(res.body);
    print(body['type']);
    print(body['user']);
    print(body['token']);
    print(res.statusCode);
    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token'].toString());

      localStorage.setString('user', json.encode(body['user']));
      if (body['user']['type'] == "User") {
        Navigator.pushNamed(context, '/myview');
      } else if (body['user']['type'] == "TaxiD") {
        Navigator.pushReplacementNamed(context, '/live-location');
      }
    } else if (res.statusCode == 403) {
      snack("Not Verified", context);
    } else if (res.statusCode == 500) {
      snack("account doesn't exist", context);
    }
    // else if (res.statusCode == 401) {
    //   snack("Not a User account", context);
    // } else if (res.statusCode == 407) {
    //   snack("Not a Driver account", context);
    // } else if (res.statusCode == 404) {
    //   snack("No Internet Connection", context);
    // }
  }

  static logout(BuildContext context) async {
    // logout from the server ..
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = localStorage.getString('token');
    print(data);
    var res = await CallApi().postData(data, "logout");
    var body = json.decode(res.body);

    print(body['message']);

    if (body['message'] == 'User logged out successfully') {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.pop(context);
    }
  }

  static token(BuildContext context, var riders) async {
    var finalval = riders * 200;
    var data;
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    var user = json.decode(userJson.toString());

    print(user);
    if (user != null)
      data = {
        'email': '${user['email']}',
        'amount': '$finalval',
      };
    var res = await CallApi().postData(data, 'qrtoken');
    var body = json.decode(res.body);
    print(body['msg']);
  }

  // ignore: non_constant_identifier_names
  static Btrips(BuildContext context, var qrCode) async {
    var data;
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    var userJson = localStorage.getString('user');
    var user = json.decode(userJson.toString());

    print(user);
    if (user != null && qrCode != null)
      data = {
        'name': '${user['name']}',
        'email': '${user['email']}',
        'qr': '$qrCode',
      };
    var res = await CallApi().postData(data, 'bustrip');
    var body = json.decode(res.body);
    print(body['msg']);
  }
}

snack(String text, BuildContext context) {
  var snackbar = SnackBar(
    content: SizedBox(
      height: 16,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
        textAlign: TextAlign.center,
      ),
    ),
    backgroundColor: Colors.black45,
    duration: const Duration(milliseconds: 3000),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackbar);
}
