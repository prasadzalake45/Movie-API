import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController releaseController = TextEditingController();

  //create the data
  Future<void> submitData() async {
    // Get the data
    final title = titleController.text.trim();
    final genre = genreController.text.trim();
    final release = releaseController.text.trim();

    if(title.isEmpty){
      showError("enter the title");
      return;
    }
     if(genre.isEmpty){
      showError("enter the genre");
      return;
    }

 if(release.isEmpty){
      showError("enter the release");
      return;
    }


    // date format

      String formattedReleaseDate;
  try {
    DateTime parsedDate = DateTime.parse(release); // Parse input date
    formattedReleaseDate = DateFormat("yyyy-MM-dd").format(parsedDate); // Format it
  } catch (e) {
    showError("Invalid date format! Use YYYY-MM-DD.");
    return; // Stop execution if date is invalid
  }


    final body = {
      "title": title,
      "genre": genre,
      "releaseDate": formattedReleaseDate, // Use formatted date
    };

    // Submit data to server
    final url = 'https://192.168.1.115:7173/api/movies';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': "application/json"},
    );

    if (response.statusCode == 201) {
      titleController.clear();
      genreController.clear();
      releaseController.clear();
      print("Successfully created on server");
      showMessage("Creation successful");
    } else {
      showError("Creation failed: ${response.body}");
    }
  }

  // show the success message;
  void showMessage(String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //show error message
  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Movies")),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          TextFormField(
            controller: titleController,
              
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 50),
          TextFormField(
            controller: genreController,
            decoration: const InputDecoration(hintText: 'genre'),
          ),
          const SizedBox(height: 80),
          TextFormField(
            controller: releaseController,
            decoration: const InputDecoration(hintText: 'release date'),
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: (){
              submitData();
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Background color
              foregroundColor: Colors.white, // Text color
              shadowColor: Colors.black, // Shadow color
          
            ),

            child: Text("add movies"),
          ),
        ],
      ),
    );
  }
}
