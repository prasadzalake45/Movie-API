import 'package:flutter/material.dart';
import 'post_page.dart';
import 'auth.dart';
import 'login_screen.dart';
import  'auth.dart';

import 'package:shared_preferences/shared_preferences.dart';


class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _LoginState();
}

class _LoginState extends State<Register> {

  


  final AuthService auth=AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();




  //   Future<void> _saveUsername(String username) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('username', username);
  // }

  String? _usernameError;
  String? _passwordError;
  bool _isValid = false;

  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _register() async{
    String username=_usernameController.text;
    String password=_passwordController.text;
    int cnt=0;
    if(username.isEmpty || password.isEmpty){
      showError("username and passsword are required");
      

    }
   
    
    
 
   if(username.isNotEmpty && password.isNotEmpty){
     bool success=await auth.register(username, password);

   
   
    print("success $success");
    if(success){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Register Sucessful!"),
        
      ));
      // need to do push replacement
       Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ), // Navigate if valid
      );
    }
    else{
     
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Register failed!"),
        
      ));
    }
  }
  }

  // Validate Username in real-time
  void _validateUsername(String value) {
    setState(() {
      if (value.isEmpty) {
        _usernameError = "Username cannot be empty";
      } else {
        _usernameError = null;
      }
      _updateFormValidity(); // Call this after validation
    });
  }

  // Validate Password in real-time
  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = "Password cannot be empty";
      } else if (value.length < 8) {
        _passwordError = "Must be at least 8 characters";
      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
        _passwordError = "Must contain 1 uppercase letter";
      } else if (!RegExp(r'[a-z]').hasMatch(value)) {
        _passwordError = "Must contain 1 lowercase letter";
      } else if (!RegExp(r'\d').hasMatch(value)) {
        _passwordError = "Must contain 1 digit";
      } else if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
        _passwordError = "Must contain 1 special character";
      } else {
        _passwordError = null;
      }
      _updateFormValidity(); // Call this after validation
    });
  }

  // Update form validity
  void _updateFormValidity() {
    setState(() {
      _isValid =
          (_usernameError == null && _passwordError == null) &&
          _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  // Login function
  // void _login() {
  //   String username=_usernameController.text.trim();
  //       if (_isValid) {
  //      _saveUsername(username);// stores username in Hive
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => PostPage(),
  //       ), // Navigate if valid
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      resizeToAvoidBottomInset: true, 
      appBar: AppBar(
           
        backgroundColor: Colors.blue,
       
        centerTitle: true, // Make the title at the center
        title: Text("MovieMania", 
        style: TextStyle(
          
          color: Colors.white,
         
              fontSize: 30.0, // Increase font size
              fontWeight: FontWeight.bold, // Make it bold
              letterSpacing: 2.0, // Add letter spacing for effect
          
          )),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       print("Exit Clicked");
        //     },
        //     icon: Icon(Icons.exit_to_app),
        //     color: Colors.white,
        //   )
        // ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [



              // Image.asset(
              // 'assets/images/fire-flame-circle-free-vector.jpg',
              // height:80,

              // ),
               SizedBox(height: 100.0),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  errorText: _usernameError,
                  border: OutlineInputBorder(),
                ),
                onChanged: _validateUsername,
               
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: _passwordError,
                  border: OutlineInputBorder(),
                ),
                onChanged: _validatePassword,
                
                obscureText: true, // Hide password input
              ),
              SizedBox(height: 30),




              ElevatedButton(
                onPressed:_register, // Disable button if invalid
                
            


                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  
                ),

                child: Text("Register"),

             



                
              ),
              SizedBox(height: 20), // Add spacing

TextButton(
  onPressed: () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()), // Replace with actual login screen widget
    );
  },
  child: Text(
    "Already registered? Login",
    style: TextStyle(
      color: Colors.blue,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  ),
),

            ],

            
          ),
        ),
        
      ),
    );
  }
}
