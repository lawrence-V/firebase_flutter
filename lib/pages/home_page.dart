import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //firestore
  final FirestoreService firestoreService = FirestoreService();
  // text controlerr
  final TextEditingController textController = TextEditingController();

  // open a dialoag box and add a new note
  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(controller: textController),
            actions: [
              //button to save the note
              ElevatedButton(
                onPressed: () {
                  if (docID == null) {
                    firestoreService.addNote(textController.text);
                  }
                  // update an existing note
                  else {
                    firestoreService.updateNote(docID, textController.text);
                  }

                  //clear the text controller
                  textController.clear();
                  // close the box
                  Navigator.pop(context);
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Home Page')),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            if (notesList.isNotEmpty) {
              return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data['note'];

                  return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => openNoteBox(docID: docID),
                          icon: const Icon(Icons.settings),
                        ),
                        IconButton(
                          onPressed: () {
                            firestoreService.deleteNote(docID);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else {
              // empty list → no notes
              return const Center(child: Text('No Notes Found'));
            }
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else {
            // loading state
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
