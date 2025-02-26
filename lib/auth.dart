import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class AuthService{
  final String urll="https://192.168.1.95:7173/api/Auth/login";
  final String urlR="https://192.168.1.95:7173/api/Auth/register";
  // flutter secure storage
  final storage=FlutterSecureStorage();

  Future<void>saveUserData(String username,String password,String token) async{

    final prefs=await SharedPreferences.getInstance();
    
    await prefs.setString(username, username); // username
    await prefs.setBool("isLogged", true);

    await storage.write(key:"password",value:password); //password
    await storage.write(key:"auth_token",value:token);  // token





  }
  // login functionality


  // register functionality

  Future<bool>register(String username,String password) async{

    try{

      final response=await http.post(
        Uri.parse(urlR),

        headers: {
          "Content-type":"application/json",
        

        },

        body:jsonEncode({
          "username":username,
          "password":password


        }),


      );

      print("user name is $username");

      if(response.statusCode==200 || response.statusCode==201){
        final data=jsonDecode(response.body);
        return true;

        print("the data is $data");
      }
      else{
        print("Something went Wrong ${response.statusCode}");
      }



    }
    catch(e){
      print("Error during login $e");

    }

    return false;


  }

Future<bool> login(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse(urll),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    print("Response status code: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Ensure 'token' exists and is a String
      if (data != null && data["token"] is String) {
        final token = data["token"];
        await saveUserData(username, password, token);
        return true;
      } else {
        print("Error: Token is missing or invalid in API response.");
      }
    } else {
      print("Login failed with status: ${response.statusCode}");
    }
  } catch (e) {
    print("Error during login: $e");
  }
  return false;
}

  Future<String?>getToken() async{
    return await storage.read(key:"auth_token");
  }


  // logout

  Future<void>logout() async{
    final prefs=await SharedPreferences.getInstance();
    await prefs.remove("username");
    await storage.deleteAll();
  }





}