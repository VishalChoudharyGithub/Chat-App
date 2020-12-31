import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHelper {
  SharedPreferences _prefs;
  String baseUrl = "<Your server address here>", token;
  int _pageNo = 1;

  NetworkHelper() {
    loadPrefs();
  }
  void loadPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    token = _prefs.get("token") ?? null;
  }

  Future<http.Response> registerUser({String email, String password}) async {
    var body = jsonEncode({"email": email, "password": password});

    http.Response response = await http.post(baseUrl + "/api/users",
        headers: {"content-type": "application/json"}, body: body);
    return response;
  }

  Future<http.Response> loginUser({String email, String password}) async {
    var body = jsonEncode({"email": email, "password": password});

    http.Response response = await http.post(baseUrl + "/api/auth",
        headers: {"content-type": "application/json"}, body: body);
    return response;
  }

  Future<http.Response> sendMessage({String email, String message}) async {
    var body = jsonEncode({"email": email, "message": message});
    http.Response response = await http.post(baseUrl + "/api/messages",
        headers: {"content-type": "application/json"}, body: body);
    return response;
  }

  Future<http.Response> getMessages() async {
    var body = jsonEncode({"pageNo": _pageNo});
    http.Response response = await http.post(baseUrl + "/api/messages",
        headers: {"content-type": "application/json", "x-auth-token": token},
        body: body);

    if (response.statusCode == 200) {
      List<dynamic> messagesList = jsonDecode(response.body);
      if (messagesList.length > 0) _pageNo++;
    }
    return response;
  }
}
