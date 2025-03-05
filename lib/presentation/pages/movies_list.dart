import 'package:api_in/presentation/state_mangement/movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<MoviesPage> createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  @override


  void initState(){
    super.initState();
    Provider.of<MoviesProvider>(context,listen:false).fetchItems;
  }





   Widget build(BuildContext context) {

     final provider = Provider.of<MoviesProvider>(context);
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
      body: provider.isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh:provider. fetchItems,
              child: ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: provider.items.length,
                itemBuilder: (context, index) {
                  final item = provider.items[index];
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