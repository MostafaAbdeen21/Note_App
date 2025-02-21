import 'package:flutter/material.dart';
import 'database.dart';
import 'notes.dart';


class ArchieveScreen extends StatefulWidget {
   ArchieveScreen({super.key});


  @override
  State<ArchieveScreen> createState() => ArchieveScreenState();
}

class ArchieveScreenState extends State<ArchieveScreen> {
  List<Map<String, dynamic>> archivedNotes = [];


  @override
  void initState() {
    super.initState();
    fetchArchivedNotes();
  }

  Future<void> fetchArchivedNotes() async {
    final data = await DBHelper.getArchivedNotes();
    setState(() {
      archivedNotes = data ?? [];
    });
  }
  Future<void> unarchiveNote(int id) async{
    try {
      await DBHelper.updateArchivedStatus(id, 0);
      setState(() {
        archivedNotes.removeWhere((notes)=>notes['id']== id);
      });
    }
    catch (e){
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Archived Notes",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: archivedNotes.isEmpty
            ? const Center(
          child: Text(
            "No archived notes available.",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
            itemCount: archivedNotes.length,
            itemBuilder: (context, index) {
              final note = archivedNotes[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: Dismissible(
                  key: ValueKey(archivedNotes[index]['id']),
                  direction: DismissDirection.endToStart ,
                  background: Container(
                    color: Colors.green,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.archive,color: Colors.white,),
                  ),
                  child: ListTile(
                    title: Text(
                      note['Title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(note['Note']),
                  ),
                  onDismissed: (direction) {
                    unarchiveNote(archivedNotes[index]['id']);
                    fetchArchivedNotes();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Notes()));
                  },

                ),
              );
            },
            ),
        );
    }
}
