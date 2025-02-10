import 'package:flutter/material.dart';
import 'package:note_app/database.dart';

import 'notes.dart';

class editnotes extends StatelessWidget {
  final String text;
  final String note;
  final int id;
  editnotes({super.key, required this.text, required this.note, required this.id});
  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController(text:text);
    final TextEditingController noteController = TextEditingController(text: note);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:FloatingActionButton(onPressed: (){
        if (titleController.text.isEmpty || noteController.text.isEmpty) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  title: Text("Alert"),
                  content: Text(
                      "Please Make sure to fill the title or note area"),
                );
              });
        } else {
          DBHelper.updateDB(id, titleController.text, noteController.text);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Notes()));
        }



      },
        backgroundColor: Colors.grey[200],
        child: Icon(Icons.edit),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)
        ),
        title: Text("App Note",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.save,size: 25,))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Title",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                    hintText: "Add s new Title",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
              SizedBox(height: 30,),
              const Text("Description",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: noteController,
                maxLines: 10,
                decoration: InputDecoration(
                    fillColor: Colors.grey[300],
                    filled: true,
                    hintText: "Add a new description for note",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}
