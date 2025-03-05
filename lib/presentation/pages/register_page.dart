// import 'package:api_in/presentation/state_mangement/auth_provider.dart';
import 'package:api_in/presentation/pages/login_page.dart';
import 'package:api_in/presentation/state_mangement/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override

  // final registerProvider=

Widget build(BuildContext context) {
    final registerProvider=Provider.of<RegisterProvider>(context);
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
                controller: registerProvider.usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  errorText: registerProvider.usernameError,
                  border: OutlineInputBorder(),
                ),
                onChanged: registerProvider.validateUsername,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: registerProvider.passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: registerProvider.passwordError,
                  border: OutlineInputBorder(),
                ),
                onChanged: registerProvider.validatePassword,

                obscureText: true, // Hide password input
              ),
              SizedBox(height: 30),
                              

              ElevatedButton(
                onPressed: registerProvider.isValid ? () => registerProvider.register(context) : null, // Disable button if invalid

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
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ), // Replace with actual login screen widget
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
