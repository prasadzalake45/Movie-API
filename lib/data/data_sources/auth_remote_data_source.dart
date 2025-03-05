import 'dart:convert';
import 'package:api_in/core/constants.dart';
import 'package:api_in/data/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  Future<String> register(UserModel user) async {

   
    try {
      final url = Uri.parse(REGISTER_API);
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };

      final body = jsonEncode(user.toJson());

      print("Request URL: $url");
      print("Request Headers: $headers");
      print("Request Body: $body");

      final response = await http.post(url, headers: headers, body: body);
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      switch (response.statusCode) {
        case 200:
        case 201:
          return "Username successfully created";
        case 400:
        case 409:
        case 500:
          return response.body;
        default:
          return "Unexpected Error: ${response.body}";
      }
    }
     catch (e) {
      print("Error during registration: $e");
      return "Network Error Occurred";
    }
  }

  Future<String>login(UserModel user) async {
    try {
      final url = Uri.parse(LOGIN_API);
      final headers = {
        "Content-Type": "application/json",
        "Accept": "application/json"
      };

      final body = jsonEncode(user.toJson());

      print("Request URL: $url");
      print("Request Headers: $headers");
      print("Request Body: $body");

      final response = await http.post(url, headers: headers, body: body);
      print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      switch (response.statusCode) {
        case 200:
        case 201:
          return "User successfully logged in";
        case 400:
        case 409:
        case 500:
          return response.body;
        default:
          return "Unexpected Error: ${response.body}";
      }
    } catch (e) {
      print("Error during login: $e");
      return "Network Error Occurred";
    }
  }
}
