import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_making/pages/AddNote.dart';
import 'package:sqflite/sqflite.dart';

import '../db/DatabaseHelper.dart';
import '../model/Note.dart';
import 'UpdateNote.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = [];
      updateListView();
      print("Size: ${noteList?.length}");
    }

    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 37, 60, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(26, 37, 60, 1),
        elevation: 0,
        title: const Text(
          'Onyx Note',
          style: TextStyle(
              color: Color.fromRGBO(1, 255, 255, 100),
              fontWeight: FontWeight.bold,
              fontSize: 30),
        ),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // debugPrint('FAB clicked');
          navigateToAddNote(Note('', '', 2), 'Catatan');
        },
        // tooltip: 'Add Note',
        child: Icon(
          Icons.add,
          color: Color.fromRGBO(1, 255, 245, 100),
        ),
        // backgroundColor: Color.fromRGBO(42, 59, 95, 100),
        backgroundColor: Color.fromARGB(255, 42, 59, 95),
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = const TextStyle(
      color: Colors.white, // Ubah warna teks menjadi putih
      fontSize: 16.0, // Tambahkan ukuran font jika diperlukan
      fontWeight: FontWeight.bold, // Tambahkan gaya font jika diperlukan
    );

    TextStyle dateStyle = const TextStyle(
      color: Colors.grey, // Ubah warna teks tanggal menjadi abu-abu
      fontSize: 14.0,
    );

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Color.fromRGBO(26, 35, 44, 100),
          elevation: 2.0,
          child: ListTile(
            //
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            leading: Container(
              width: 8.0, // Lebar persegi panjang
              height: 50.0, // Tinggi persegi panjang
              decoration: BoxDecoration(
                color: getPriorityColor(this.noteList![position].priority),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(
                    8.0), // Untuk membuat sudut membulat, jika diperlukan
              ),
              // child: Center(
              //   child: getPriorityIcon(this.noteList![position].priority),
              // ),
            ),

            title: Text(
              this.noteList![position].title,
              style: titleStyle,
            ),
            subtitle: Text(
              this.noteList![position].date,
              style: dateStyle,
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, noteList![position]);
              },
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToUpdateNote(this.noteList![position], 'Catatan');
            },
          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToAddNote(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddNote(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void navigateToUpdateNote(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UpdateNote(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
