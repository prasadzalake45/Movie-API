
import 'dart:convert';


class UserModel{
  final String username;
  final String password;

  UserModel({required this.username,required this.password});

  Map<String,dynamic>toJson(){
    return {
      
      "username":username,
    "password":password
    };
  }



  static UserModel fromJson(Map<String,dynamic>json){
    return UserModel(username: json["username"], password: json["password"]);
  }
}