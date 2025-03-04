import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'error_messages.dart';
class AuthService {
  final String LOGIN_API = "https://192.168.1.45:7173/api/Auth/login";
  final String REGISTER_API = "https://192.168.1.45:7173/api/Auth/register";
  // flutter secure storage
  final storage = FlutterSecureStorage();

  Future<void> saveUserData(
    String username,
    String password,
    String token,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(username, username); // username
    await prefs.setBool("isLogged", true);

    await storage.write(key: "password", value: password); //password
    await storage.write(key: "auth_token", value: token); // token
  }

  // register functionality

  Future<String> register(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(REGISTER_API),

        headers: {"Content-type": "application/json"},

        body: jsonEncode({"username": username, "password": password}),
      );

      print("user name is $username");
      print("status code is ${response.statusCode}");
      print("xxxxxxxxxxxxxxxxxxxxxxxxxx${response.body}");

      switch(response.statusCode){

        case 200:
        case 201: // all ok something is created
          print(response.body);
           return "Username successfully created";

        case 400:
         return response.body;


         case 409:
         return response.body;

         case 500:
         return response.body;


         default:
         return response.body;

      }
      
  
    } catch (e) {
    print("Error during registration: $e");
    return "Network Error is Occured";
  }
   
  }

  // login functionality

  Future<String> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse(LOGIN_API),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"username": username, "password": password}),
    );

    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    switch (response.statusCode) {
      case 200:
        final data = jsonDecode(response.body);
        if (data != null && data["token"] is String) {
          final token = data["token"];
          await saveUserData(username, password, token);
          return "Login Success"; // Return full response body
        }
        return "Invalid response from server.";
        
      case 401:
        return response.body; // Unauthorized response body
      
      case 403:
        return response.body; // Forbidden response body
      
      case 404:
        return response.body; // Not found response body
      
      case 409:
        return response.body; // Conflict response body
      
      case 503:
        return response.body; // Service unavailable response body

      default:
        return response.body; // Unknown error response body
    }
  } catch (e) {
    return "Network error: $e";
  }
}


  Future<String?> getToken() async {
    return await storage.read(key: "auth_token");
  }

  // logout

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("username");
    await storage.deleteAll();
  }
}
