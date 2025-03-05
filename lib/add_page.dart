import 'package:api_in/home_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class AddPage extends StatefulWidget {
  final Map? data;

  AddPage({super.key, this.data});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  String BASE_URL = "https://192.168.1.10:7173/api/Movies";

  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController releaseController = TextEditingController();

  String? _titleError;
  String? _genereError;
  String? _releaseError;

  //   void validateAndSubmit(){
  //     setState(() {

  //       _titleError=titleController.text.isEmpty?"enter the tile":null;

  //       _genereError=genreController.text.isEmpty?"enter the genre":null;

  //       _releaseError=releaseController.text.isEmpty?"enter the release data":null;

  //       if(_titleError==null &&_genereError==null && _releaseError==null){
  //         isEdit? updateData():submitData()
  // ;      }
  //     });

  //   }

  bool isEdit = false;

  void initState() {
    super.initState();
    final data = widget.data;
    if (data != null) {
      isEdit = true;

      final title = data['title'];
      final genre = data['genre'];
      final releaseD = data['releaseDate'];

      titleController.text = title;
      genreController.text = genre;
      releaseController.text = releaseD;
    }
  }

  // update logic

  Future<void> updateData() async {
    AuthService auth = AuthService();
    String? token = await auth.getToken();

    if (token == null) {
      print("User is not logged in");
      return;
    }

    final data = widget.data;
    if (data == null || data['id'] == null) {
      print("Invalid data for update");
      return;
    }

    final id = data['id'];
    final title = titleController.text.trim();
    final genre = genreController.text.trim();
    final releaseDate = releaseController.text.trim();

    // Reset previous error messages
    setState(() {
      _titleError = title.isEmpty ? "Enter the title" : null;
      _genereError = genre.isEmpty ? "Enter the genre" : null;
      _releaseError = releaseDate.isEmpty ? "Enter the release date" : null;
    });

    // Stop execution if there are validation errors
    if (title.isEmpty || genre.isEmpty || releaseDate.isEmpty) return;

    final body = {
      "id": id,
      "title": title,
      "genre": genre,
      "releaseDate": releaseDate,
    };

    final url = '${BASE_URL}/$id';
    final uri = Uri.parse(url);

    try {
      final response = await http.put(
        uri,
        body: jsonEncode(body),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      print("Updating movie ID: $id");
      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Successfully updated on the server");
        showMessage("Update successful");
      } else {
        showError("Update failed: ${response.body}");
      }
    } catch (e) {
      print("Error updating data: $e");
      showError("Something went wrong. Please try again.");
    }
  }

  //create the data
  Future<void> submitData() async {
    AuthService auth = AuthService();
    bool isSubmitting;

    String? token = await auth.getToken();

    if (token == null) {
      print("user is not logged in");
      return;
    }

    final title = titleController.text.trim();
    final genre = genreController.text.trim();
    final release = releaseController.text.trim();

    setState(() {
      _titleError = title.isEmpty ? "Enter the title" : null;
      _genereError = genre.isEmpty ? "Enter the genre" : null;
      _releaseError = release.isEmpty ? "Enter the release date" : null;
    });

    if (_titleError != null || _genereError != null || _releaseError != null) {
      return; // Stop execution if validation fails
    }

    final body = {"title": title, "genre": genre, "releaseDate": release};

    final url = BASE_URL;
    final uri = Uri.parse(url);

    // Disable button to prevent multiple clicks
    setState(() {
      isSubmitting = true;
    });

    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        "Authorization": "Bearer $token",
        'Content-Type': "application/json",
      },
    );

    // Enable button after response
    setState(() {
      isSubmitting = false;
    });

    if (response.statusCode == 201) {
      titleController.clear();
      genreController.clear();
      releaseController.clear();
      print("Successfully created on server");
      showMessage("Creation successful");
    } else {
      showError("Creation Failed: ${response.body}");
    }
  }

  // show the success message;
  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Future.delayed(Duration(seconds: 3));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostPage()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  //show error message
  void showError(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // dropdown menu

  void showDropdown(
    BuildContext context,
    TextEditingController controller,
    List<String> options,
  ) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 200, 400, 200),

      items:
          options.map((String option) {
            return PopupMenuItem<String>(value: option, child: Text(option));
          }).toList(),
    ).then((value) {
      if (value != null) {
        controller.text = value;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> options = [
      "Action Thriller",
      "Historical Epic",
      "Romantic Drama",
      "Comedy",
      "Horror",
      "Musical Drama",
      "Biopic",
      "Thrillers and Suspense",
    ];
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? "Edit Movies" : "Add Movies")),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          TextFormField(
            controller: titleController,
            onChanged:
                (_) => setState(() {
                  _titleError = null;
                }),
            decoration: InputDecoration(
              hintText: 'Title',
              errorText: _titleError,
            ),
          ),
          const SizedBox(height: 50),
          TextFormField(
            readOnly: true,

            onTap: () {
              showDropdown(context, genreController, options);
              setState(() {
                _genereError = null; // Clear error when dropdown opens
              });
            },

            controller: genreController,
            decoration: InputDecoration(
              hintText: 'genre',
              errorText: _genereError,
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ),
          const SizedBox(height: 80),
          TextFormField(
            readOnly: true,
            controller: releaseController,

            decoration: InputDecoration(
              hintText: 'release date',
              errorText: _releaseError,
              suffixIcon: Icon(Icons.calendar_today),
            ),
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(), // Current date
                firstDate: DateTime(2000), // Minimum date
                lastDate: DateTime(2100), // Maximum date
              );

              if (pickedDate != null) {
                String formattedDate = DateFormat(
                  "yyyy-MM-dd",
                ).format(pickedDate); // Format date
                setState(() {
                  releaseController.text =
                      formattedDate; // Set selected date to TextField
                  _releaseError = null;
                });
              }
            },
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: () => isEdit ? updateData() : submitData(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Background color
              foregroundColor: Colors.white, // Text color
              shadowColor: Colors.black, // Shadow color
            ),

            child: Text(isEdit ? "Edit" : "Submit"),
          ),
        ],
      ),
    );
  }
}
