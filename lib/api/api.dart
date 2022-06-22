// ignore_for_file: await_only_futures

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'http://192.168.43.235:8000/api/auth/';

  postData(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = await localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http
        .post(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $token',
    });
  }

  getData(apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = await localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http.get(Uri.parse(fullUrl), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $token',
    });
  }

  putData(data, apiUrl) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = await localStorage.getString('token');
    var fullUrl = _url + apiUrl;
    return await http.put(Uri.parse(fullUrl), body: jsonEncode(data), headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'bearer $token',
    });
  }
}
