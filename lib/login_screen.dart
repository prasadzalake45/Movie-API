import 'package:flutter/material.dart';
import 'home_page.dart';
import 'auth.dart';
import 'register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService auth = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //   Future<void> _saveUsername(String username) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('username', username);
  // }

  String? _usernameError;
  String? _passwordError;
  bool _isValid = false;
void _login() async {
  String username = _usernameController.text;
  String password = _passwordController.text;

  if (username.isEmpty) {
    setState(() {
      _usernameError = "Username is required";
    });
    return;
  } else if (password.isEmpty) {
    setState(() {
      _passwordError = "Password is required";
    });
    return;
  }

  try {
    // Get the raw API response as a string
    String responseMessage = await auth.login(username, password);

    // Show the API response message in a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(responseMessage), // Direct API response message
        backgroundColor: Colors.blue, // Set to blue by default
      ),
    );

    // Navigate to PostPage only on success (Modify based on API response)
    if (responseMessage.contains("successful") || responseMessage.contains("Success")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostPage()),
      );
    }

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("An error occurred: $e"),
        backgroundColor: Colors.red,
      ),
    );
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


  // Update form validity
  void _updateFormValidity() {
    setState(() {
      _isValid =
          (_usernameError == null && _passwordError == null) &&
          _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: Colors.blue,

        centerTitle: true, // Make the title at the center
        title: Text(
          "MovieMania",
          style: TextStyle(
            color: Colors.white,

            fontSize: 30.0, // Increase font size
            fontWeight: FontWeight.bold, // Make it bold
            letterSpacing: 2.0, // Add letter spacing for effect
          ),
        ),
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

                obscureText: true, // Hide password input
              ),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _login, // Disable button if invalid

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

                child: Text("Login"),
              ),
              SizedBox(height: 50),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ), // Replace with actual login screen widget
                  );
                },
                child: Text(
                  "Go back to Register",
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
