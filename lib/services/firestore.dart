import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get colletion notes

  final CollectionReference notes = FirebaseFirestore.instance.collection(
    'notes',
  );

  // Add : add a new note
  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  //READ : get notes from database
  Stream<QuerySnapshot> getNotesStream() {
    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();
    return noteStream;
  }

  // Update: upate notes given a doc id
  Future<void> updateNote(String docId, String newNote) {
    return notes.doc(docId).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

  // Delete: delete notes given a doc id
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
