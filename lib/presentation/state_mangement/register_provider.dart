

import 'package:api_in/domain/entities/user_entity.dart';
import 'package:api_in/domain/repositories/auth_repository.dart';
import 'package:api_in/presentation/pages/login_page.dart';
// import 'package:api_in/domain/use_cases/register_usecase.dart';
import 'package:flutter/material.dart';
// import user_entity
// import register_usecase



class RegisterProvider with ChangeNotifier{
 
  final AuthRepository authRepo;  // auth repo

  RegisterProvider(this.authRepo);




  String? usernameError;
  String? passwordError;
  bool isValid = false;

  TextEditingController usernameController = TextEditingController();
 


  TextEditingController passwordController = TextEditingController();


  // void showError(String message) {
  //   final snackBar = SnackBar(
  //     content: Text(message),
  //     backgroundColor: Colors.red,
  //   );

  //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
  // }

  


  void validateUsername(String value) {
    if (value.isEmpty) {
      usernameError = "Username cannot be empty";
    } else {
      usernameError = null;
    }
    _updateFormValidity();
    notifyListeners();
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError = "Password cannot be empty";
    } else if (value.length < 8) {
      passwordError = "Must be at least 8 characters";
    } else {
      passwordError = null;
    }
    _updateFormValidity();
    notifyListeners();
  }

  void _updateFormValidity() {
    isValid = usernameError == null && passwordError == null &&
              usernameController.text.isNotEmpty &&
              passwordController.text.isNotEmpty;
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {
    print(isValid);
    if (!isValid) return;

    final user = UserEntity(
      username: usernameController.text,
    
      password: passwordController.text,
    );
    print(user.username);
    print(user);

    try {
      String responseMessage = await authRepo.register(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseMessage), backgroundColor: Colors.blue),
      );

     if (responseMessage.toLowerCase().contains("success")) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
  );
}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected Error"), backgroundColor: Colors.red),
      );
    }
  }
}