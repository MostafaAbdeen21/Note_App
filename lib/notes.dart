import 'package:flutter/material.dart';
import 'package:note_app/add_note.dart';
import 'package:note_app/edit_notes.dart';
import 'database.dart';
import 'favorite_note_page.dart';
import 'archieve.dart';


class Notes extends StatefulWidget {
  const Notes({super.key});


  @override
  State<Notes> createState() => NotesState();
}

class NotesState extends State<Notes> {
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final data = await DBHelper.getDataFromDB();
    setState(() {
      notes = data ?? [];
    });
  }
  Future<void> archiveNote(int id) async{
    try {
      await DBHelper.updateArchivedStatus(id, 1);
      setState(() {
        notes.removeWhere((notes)=>notes['id']== id);
      });
    }
    catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.book,
          color: Colors.black,
          size: 30,
        ),
        title: const Text(
          "All Notes",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Favorites()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.archive, color: Colors.blue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ArchieveScreen()),
              );
            },
          ),
        ],
      ),
      body: notes.isEmpty ? const Center(
        child: Text(
          "No notes available.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: ValueKey(notes[index]['id']),
              background: Container(
                color: Colors.blue,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20),
                child: Icon(Icons.archive,color: Colors.white,),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.delete,color: Colors.white,),

              ),
              onDismissed: (direction) async{
                if(direction== DismissDirection.endToStart){
                  await DBHelper.deleteDB(notes[index]['id']);
                }
                else if (direction== DismissDirection.startToEnd){
                  await archiveNote(notes[index]['id']);
                }
                else {}

              },
              child: noteItem(notes[index]));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => addnotes(),
          ),
        );

        if (result != null) {
          await DBHelper.insertToDB(result["title"], result["note"]);
          fetchNotes();
        }
        },
        backgroundColor: Colors.grey[200],
        child: const Icon(
          Icons.add,
          color: Colors.grey,
          size: 30,
        ),
      ),
    );
  }

  Widget noteItem(Map<String, dynamic> note) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading:IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>editnotes(text: note['Title'], note: note['Note'],id: note['id'],)));
            },
            icon: Icon(Icons.edit)
        ),
        title:        Row(
          children: [
            Text(
              note['Title'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Text(note['Note']),
        trailing: IconButton(
          icon: Icon(
            note['isFavorite'] == 1 ? Icons.favorite : Icons.favorite_border,
            color: Colors.redAccent,
          ),
          onPressed: () async {
            final newStatus =
            note['isFavorite'] == 1 ? 0 : 1;
            await DBHelper.updateeFavoriteStatus(note['id'], newStatus);
            fetchNotes();
          },
        ),
      ),
    );
  }
}
