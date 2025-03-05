import 'package:api_in/presentation/pages/register_page.dart';
import 'package:api_in/presentation/state_mangement/login_provider.dart';
import 'package:api_in/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override



 
  
  Widget build(BuildContext context) {


    final loginProvider=Provider.of<LoginProvider>(context);
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
                controller: loginProvider.usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  errorText: loginProvider.usernameError,
                  border: OutlineInputBorder(),
                ),
                onChanged: loginProvider.validateUsername,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: loginProvider.passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  errorText: loginProvider.passwordError,
                  border: OutlineInputBorder(),
                ),
                 onChanged: loginProvider.validatePassword,
                obscureText: true, // Hide password input
              ),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: loginProvider.isValid ? () => loginProvider.login(context) : null, // Disable button if invalid

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
                      builder: (context) => RegisterPage(),
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
