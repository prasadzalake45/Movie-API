import 'package:api_in/login_screen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'model.dart';
import 'add_page.dart';
import 'auth.dart';


 AuthService auth=AuthService();
class PostPage extends StatefulWidget {
  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List items = [];
  bool isLoading = false;



  @override
  void initState() {
    super.initState();
    fetchItems();
  }
  


  // fetching the  data from API
  
  Future<void> fetchItems() async {

  

    String? token=await auth.getToken();

    if(token==null){
      print("user is not logged in");
      return;
    }
    // String token= eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNhbmlrYTEiLCJuYmYiOjE3NDA0Nzc0MjAsImV4cCI6MTc0MDU2MzgyMCwiaWF0IjoxNzQwNDc3NDIwLCJpc3MiOiJGaXJzdEFwaSIsImF1ZCI6IkZpcnN0QXBpVXNlcnMifQ.REpWHbDjBXAxeWgz_2-AnmCFp4-g75E-ocb0BAMW8j8"

    final url = "https://192.168.1.142:7173/api/Movies";
    final uri = Uri.parse(url);

    // final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNhbmlrYSIsIm5iZiI6MTc0MDQ2MTY1NCwiZXhwIjoxNzQwNTQ4MDU0LCJpYXQiOjE3NDA0NjE2NTQsImlzcyI6IkZpcnN0QXBpIiwiYXVkIjoiRmlyc3RBcGlVc2VycyJ9.DG8Ph0_-h0wq9Rp7QyfDVeaxItq5uP71F55-cdrXSko"; // Replace with actual token

    try {
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body); // Decode as list
        print(items);
        setState(() {
          items = jsonData;
          isLoading = false;
        });
      } else if (response.statusCode == 401) {
        print("Unauthorized Access: Token may be invalid or expired");
      } else {
        print("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    } 
    
  }




  // Creating Routes:
  // navigate to add page

  Future<void>navigateToAddPage() async{
    final route=MaterialPageRoute(
      builder: (context)=>AddPage(),
    );
    await Navigator.push(context,route);
    fetchItems();  // i am uable to understand why this fetch item doing again
  }
  
  // navigate to edit page

   Future<void>navigateToEditPage(Map data) async{
    final route=MaterialPageRoute(
      builder: (context)=>AddPage(data:data),
    );
    await Navigator.push(context,route);
    fetchItems();  
  }


    // deleting items
Future<void> deleteById(int id) async {
  // final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNhbmlrYSIsIm5iZiI6MTc0MDQ2MTY1NCwiZXhwIjoxNzQwNTQ4MDU0LCJpYXQiOjE3NDA0NjE2NTQsImlzcyI6IkZpcnN0QXBpIiwiYXVkIjoiRmlyc3RBcGlVc2VycyJ9.DG8Ph0_-h0wq9Rp7QyfDVeaxItq5uP71F55-cdrXSko"; // Replace with actual token
  AuthService auth=AuthService();

  String? token=await auth.getToken();

    if(token==null){
      print("user is not logged in");
      return;
    }
   
  final url = 'https://192.168.1.142:7173/api/Movies/$id';
  final uri = Uri.parse(url);

  // **Remove from UI first for instant update**
  setState(() {
    items.removeWhere((element) => element['id'] == id);
  });

  final response = await http.delete(
    uri,
    headers: {
      "Authorization": "Bearer $token",
      'Content-Type': "application/json",
    },

  );

  if (response.statusCode == 204) {
    showMessage("Deletion successful");
  } else {
    showMessage("Failed to delete: ${response.statusCode}");
    // **If deletion fails, restore item**
    fetchItems(); // Fetch again to restore correct data
  }
}


  void showMessage(String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
       
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}


// delete dialog box


void showDeleteDialog(BuildContext context,int id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deleteById(id);// Close dialog
              Navigator.of(context).pop() ;// Perform delete action
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}


// logout functionlity

void _logout() async{
   await auth.logout();
   Navigator.pushReplacement(context,
   MaterialPageRoute(builder: (context)=>Login()) ,
   );
}

// date parsing

String formatDate(String dateString){
  DateTime date=DateTime.parse(dateString); // convert string to datetime
  return DateFormat("MMMM-dd-yyyy").format(date); // convert to whatever format that  i need
}



  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Movies",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.2,color: Colors.black),
        ),
        // centerTitle: true,
        elevation: 5,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.indigoAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton( icon: Icon(Icons.search),onPressed: (){},),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchItems,
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final id = item['id'];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      
                      title: Text(
                        item['title'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Genre :${item['genre']}",
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      ),
      Text(

     
        "Release :${formatDate(item['releaseDate'])}", // Second subtitle (Example: Release Date)
        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
      ),
    ],
  ),
                      trailing: PopupMenuButton(
                        onSelected: (value) {
                          if (value == "edit") {
                            navigateToEditPage(item);
                          } else if (value == "delete") {
                            showDeleteDialog(context,id);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: "edit",
                          child: Row(children: [


                            Icon(Icons.edit,color: Colors.blue),
                            SizedBox(width: 8),
                            Text("edit"),
                          ],)
                          
                          ), 
                          
                          
                   
                           PopupMenuItem(
                            value: "delete",
                          child: Row(children: [


                            Icon(Icons.delete,color: Colors.blue),
                            SizedBox(width: 8),
                            Text("delete"),
                          ],)
                          
                          ), 

                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text("Add Movie",
        style: TextStyle(color: Colors.blue),
        ),
        icon: Icon(Icons.add),
      ),
    );
  }
}