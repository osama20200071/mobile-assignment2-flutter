import 'package:first_app/services/context/AuthContext.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';

const String baseUrl = "http://10.0.2.2:3000";

class Api {
  var client = http.Client();

  Future<dynamic> get(String api) async {
    var uri = Uri.parse(baseUrl + api);
    var token = "ff";
    var _headers = {
      "Authorization": "Bearer $token",
      "content-type": "application/json"
    };

    var response = await client.get(uri, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // handling errors
    }
  }

  Future<dynamic> post(String api, dynamic payload) async {
    var uri = Uri.parse(baseUrl + api);
    var token = "ff";
    var _payload = json.encode(payload);
    var _headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    var response = await client.post(uri, headers: _headers, body: _payload);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      // handling errors
    }
  }

  static void login(BuildContext context, String email, String password) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    const String apiUrl = 'http://10.0.2.2:3000/users/login';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final receivedToken = responseData['token'];

      authProvider.setToken(receivedToken);

      // Navigate to the stores screen
      // Navigator.pushNamed(context, '/stores');
      Navigator.pushNamed(context, '/');
    } else {
      // Handle login failure
    }
  }

  static void signup(
      BuildContext context, String name, String email, String password) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    const String apiUrl = 'http://10.0.2.2:3000/users/signup';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final receivedToken = responseData['token'];

      debugPrint("receivedToken = $receivedToken");

      authProvider.setToken(receivedToken);
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // Handle login failure
    }
  }
}
