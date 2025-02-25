import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;



class AuthService{
  final String url="https://192.168.1.133:7173/api/Auth/login";
  // flutter secure storage
  final storage=FlutterSecureStorage();

  Future<void>saveUserData(String username,String password,String token) async{

    final prefs=await SharedPreferences.getInstance();
    
    await prefs.setString(username, username); // username

    await storage.write(key:"password",value:password); //password
    await storage.write(key:"auth_token",value:token);  // token





  }
  // login functionality

  Future<bool>login(String username,String password) async{
    final response=await http.post(
      Uri.parse(url),
      headers: {
        "Content-type":"application/json"

      },
      body:jsonEncode({
        "username":username,
        "password":password,

      }
        
      ),


    );

    print("Resonse status code : ${response.statusCode}");
    print("Response body ${response.body}");

    if(response.statusCode==200){
      final data=jsonDecode(response.body);
      final token=data["token"];

      print("token received $token");

      

      if(token!=null){
        await saveUserData(username, password, token);
        return true;

      }
    }
    return false;

  }

  Future<String?>getToken() async{
    return await storage.read(key:"auth_token");
  }





}