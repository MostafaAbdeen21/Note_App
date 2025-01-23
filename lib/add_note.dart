import 'package:flutter/material.dart';

class addnotes extends StatelessWidget {
  addnotes({super.key});

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          Navigator.pop(context, {
            "title": titleController.text,
            "note": noteController.text
          });
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
