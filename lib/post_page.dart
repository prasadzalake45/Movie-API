import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart';
import 'add_page.dart';

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
   

    final url = "https://192.168.1.115:7173/api/movies";
    final uri = Uri.parse(url);

    final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNhbmlrYSIsIm5iZiI6MTc0MDM3OTUxOCwiZXhwIjoxNzQwMzg2NzE4LCJpYXQiOjE3NDAzNzk1MTgsImlzcyI6IkZpcnN0QXBpIiwiYXVkIjoiRmlyc3RBcGlVc2VycyJ9.m7kJF1J6Z1ovvPimWuxkE3AVhJbXwQlcQwGjLok-EMg"; // Replace with actual token

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
    fetchItems();
  }
  
  // navigate to edit page

   Future<void>navigateToEditPage(Map data) async{
    final route=MaterialPageRoute(
      builder: (context)=>AddPage(),
    );
    await Navigator.push(context,route);
  }


    // deleting items
Future<void> deleteById(int id) async {
  final url = 'https://192.168.1.115:7173/api/movies/$id';
  final uri = Uri.parse(url);

  // **Remove from UI first for instant update**
  setState(() {
    items.removeWhere((element) => element['id'] == id);
  });

  final response = await http.delete(
    uri,
    headers: {
      'Authorization': "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6InNhbmlrYSIsIm5iZiI6MTc0MDM3OTUxOCwiZXhwIjoxNzQwMzg2NzE4LCJpYXQiOjE3NDAzNzk1MTgsImlzcyI6IkZpcnN0QXBpIiwiYXVkIjoiRmlyc3RBcGlVc2VycyJ9.m7kJF1J6Z1ovvPimWuxkE3AVhJbXwQlcQwGjLok-EMg",
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
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Movies"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchItems,
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final id = item['id'];
                  return ListTile(
                    leading: CircleAvatar(child: Text("${index + 1}")),
                    title: Text("${item['title']}"),
                    subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the left
    children: [
      Text("${item['genre']}"),
    
     
    ],
  ),
                  
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == "edit") {
                          // Navigate to edit page
                        } else if (value == 'delete') {
                          // Delete item
                        deleteById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text("Edit"),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: Text("Delete"),
                            value: 'delete',
                          ),
                        ];
                      },
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:navigateToAddPage,
        label: Text("Add Movies"),
      ),
    );
  }
}
