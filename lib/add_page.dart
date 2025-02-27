import 'package:api_in/post_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'package:http/http.dart' as http;
import 'post_page.dart';

class AddPage extends StatefulWidget {


  final Map? data;

  
   AddPage({
    super.key,
    this.data,
    
    });

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {





  TextEditingController titleController = TextEditingController();
  TextEditingController genreController = TextEditingController();
  TextEditingController releaseController = TextEditingController();



  bool isEdit=false;

  void initState(){
    super.initState();
    final data=widget.data;
    if(data!=null){

      isEdit=true;

      final title=data['title'];
      final genre=data['genre'];
      final releaseD=data['releaseDate'];

      

      titleController.text=title;
      genreController.text=genre;
      releaseController.text=releaseD;

      




    }
  }

  // update logic


  Future<void>updateData() async{
    // final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNhbmlrYSIsIm5iZiI6MTc0MDQ2MTY1NCwiZXhwIjoxNzQwNTQ4MDU0LCJpYXQiOjE3NDA0NjE2NTQsImlzcyI6IkZpcnN0QXBpIiwiYXVkIjoiRmlyc3RBcGlVc2VycyJ9.DG8Ph0_-h0wq9Rp7QyfDVeaxItq5uP71F55-cdrXSko"; // Replace with actual token
     AuthService auth=AuthService();

  String? token=await auth.getToken();

    if(token==null){
      print("user is not logged in");
      return;
    }
    final data=widget.data;

    if(data==null){
      print("something wrong");
      return;
    }

    final id=data['id'];

    final title=titleController.text;
    final genre=genreController.text;
    final realese=releaseController.text;
  
    if(title.isEmpty){
      showError("enter the title");
      return;
    }
     if(genre.isEmpty){
      showError("enter the genre");
      return;
    }

 if(realese.isEmpty){
      showError("enter the release");
      return;
    }

    final body={
      "title":title,
      "genre":genre,
      "releaseDate":realese,

    };
     print("Updating movie with ID: $id");
  print("Request Body: ${jsonEncode(body)}");

    final url='https://192.168.1.142:7173/api/Movies/$id';
    final uri=Uri.parse(url);

     final response = await http.patch(
      uri, 
      body: jsonEncode(body),
      headers: {
        "Authorization": "Bearer $token",
      'Content-type': "application/json",
      "Accept": "application/json",
    });

    print("Response Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

    if (response.statusCode == 204 || response.statusCode == 200) {
      print("successfully updated on server");
      showMessage("Updation sucessfully");
    }
    //show success or failed messafe
    // print(response.body);
    else {
      showError("Updation failed");
    }

  }



  //create the data
  Future<void> submitData() async {
    // Get the data
        // final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNhbmlrYSIsIm5iZiI6MTc0MDQ2MTY1NCwiZXhwIjoxNzQwNTQ4MDU0LCJpYXQiOjE3NDA0NjE2NTQsImlzcyI6IkZpcnN0QXBpIiwiYXVkIjoiRmlyc3RBcGlVc2VycyJ9.DG8Ph0_-h0wq9Rp7QyfDVeaxItq5uP71F55-cdrXSko"; // Replace with actual token
     AuthService auth=AuthService();

  String? token=await auth.getToken();

    if(token==null){
      print("user is not logged in");
      return;
    }
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




    final body = {
      "title": title,
      "genre": genre,
      "releaseDate": release, // Use formatted date
    };

    // Submit data to server
    final url = 'https://192.168.1.142:7173/api/Movies';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
         "Authorization": "Bearer $token",
        'Content-Type': "application/json"
        
        },
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
                MaterialPageRoute(builder:(context)=> PostPage()) ,
              
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

  void showDropdown(BuildContext context,TextEditingController controller,List<String>options){
    showMenu(
      context:context ,
      position: RelativeRect.fromLTRB(100, 200, 400, 200),

      
      items: options.map((String option){
        return PopupMenuItem<String>(
          value:option,
          child:Text(option)
          
          
          
          );

      }).toList(),

      
      
      
      ).then((value){
        if(value!=null){
          controller.text=value;
        }
      });

  }

  @override
  Widget build(BuildContext context) {

    
    List<String>options=["Action Thriller","Historical Epic","Romantic Drama","Comedy","Horror","Musical Drama","Biopic","Thrillers and Suspense"];
    return Scaffold(
     
      appBar: AppBar(title: Text(isEdit?"Edit Movies":"Add Movies")),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          TextFormField(
            controller: titleController,
              
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 50),
          TextFormField(
            readOnly: true,

            onTap: ()=>{
              showDropdown(context,genreController,options),
            },

            controller: genreController,
            decoration: const InputDecoration(
              hintText: 'genre',
              suffixIcon: Icon(Icons.arrow_drop_down),
              ),
          ),
          const SizedBox(height: 80),
          TextFormField(
              readOnly: true, 
            controller: releaseController,
            
            decoration: const InputDecoration(
              hintText: 'release date',
              suffixIcon: Icon(Icons.calendar_today)
              
              
              ),
             onTap: () async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime(2000), // Minimum date
      lastDate: DateTime(2100), // Maximum date
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat("yyyy-MM-dd").format(pickedDate); // Format date
      setState(() {
        releaseController.text = formattedDate; // Set selected date to TextField
      });
    }}
    
          ),
          const SizedBox(height: 80),
          ElevatedButton(
            onPressed: (){
              isEdit?updateData():
              submitData();
              
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Background color
              foregroundColor: Colors.white, // Text color
              shadowColor: Colors.black, // Shadow color
          
            ),

            child: Text(isEdit?"Edit":"Submit"),
          ),
        ],
      ),
    );
  }
}
