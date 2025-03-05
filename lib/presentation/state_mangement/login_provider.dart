

import 'package:api_in/domain/entities/user_entity.dart';
import 'package:api_in/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class LoginProvider with ChangeNotifier{
  
  final AuthRepository authRepo;

  LoginProvider(this.authRepo);

  



 String? usernameError;
  String? passwordError;
  bool isValid = false;
  bool isLoading = false;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();



    // ✅ Validate Username
  void validateUsername(String value) {
    if (value.isEmpty) {
      usernameError = "Username cannot be empty";
    } else {
      usernameError = null;
    }
    _updateFormValidity();
    notifyListeners();
  }

  // ✅ Validate Password
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

  // ✅ Update Form Validity
  void _updateFormValidity() {
    isValid = usernameError == null &&
        passwordError == null &&
        usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
    notifyListeners();
  }

  // ✅ Login Function
  Future<void>login(BuildContext context) async {
    if (!isValid) return;

    final user = UserEntity(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    try {
      isLoading = true;
      notifyListeners();

      String responseMessage = await authRepo.login(user);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseMessage), backgroundColor: Colors.blue),
      );

      // if (responseMessage.toLowerCase().contains("success")) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => PostPage()),
      //   );
      // }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected Error"), backgroundColor: Colors.red),
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



}