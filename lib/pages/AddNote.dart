import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/DatabaseHelper.dart';
import '../model/Note.dart';

class AddNote extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  AddNote(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<AddNote> {
  static var _priorities = ['Penting', 'Biasa'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      appBar: AppBar(
          title: Text(
            appBarTitle,
            style: TextStyle(
                color: Color.fromRGBO(1, 255, 255, 100),
                fontWeight: FontWeight.bold,
                fontSize: 30 // Atur warna teks menjadi putih
                ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            },
            color: Color.fromRGBO(1, 255, 255, 100),
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: Color.fromRGBO(1, 255, 255, 100),
              ),
              itemBuilder: (BuildContext context) {
                return _priorities.map((String priority) {
                  return PopupMenuItem<String>(
                    value: priority,
                    child: Text(priority, style: TextStyle(color: Colors.white)),
                  );
                }).toList();
              },
              onSelected: (String selectedValue) {
                setState(() {
                  debugPrint('User selected $selectedValue');
                  updatePriorityAsInt(selectedValue);
                });
              },
              color: Color.fromARGB(255,26, 35, 44),
            ),
          ]),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
          
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: TextField(
                controller: titleController,
                style: TextStyle(color: Colors.white, fontSize: 24),
                onChanged: (value) {
                  debugPrint('Something changed in Title Text Field');
                  updateTitle();
                },
                decoration: InputDecoration(
                    hintText: 'Judul',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 24),
                    labelStyle: textStyle,
                    border: InputBorder.none),
                    
              ),
            ),

            // Third Element
            Padding(
              // padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              padding: EdgeInsets.fromLTRB(10, 5, 30, 10),
              child: TextField(
                controller: descriptionController,
                style: TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (value) {
                  debugPrint('Something changed in Description Text Field');
                  updateDescription();
                },
                decoration: InputDecoration(
                    // labelText: 'Description',
                    hintText: 'Isi Catatan',
                    labelStyle: textStyle,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    border: InputBorder.none
                    ),
                  maxLines: 20,

              ),
            ),

            // Fourth Element
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(1, 255, 245, 100), // Background color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(vertical: 10), // Padding inside the button
                        textStyle: TextStyle(
                          fontSize: 14, // Font size of the text
                        ),
                      ),
                      child: Text(
                        'Simpan',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Save button clicked");
                          _save();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Convert the String priority in the form of integer before saving it to Database
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'Penting':
        note.priority = 1;
        break;
      case 'Biasa':
        note.priority = 2;
        break;
    }
  }

  // Convert int priority to String priority and display it to user in DropDown
  String getPriorityAsString(int value) {
    String? priority;
    switch (value) {
      case 1:
        priority = _priorities[0]; // 'High'
        break;
      case 2:
        priority = _priorities[1]; // 'Low'
        break;
    }
    return priority!;
  }

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    result = await helper.insertNote(note);

    if (result != 0) {
      // Success
      // _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      // Failure
      // _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
