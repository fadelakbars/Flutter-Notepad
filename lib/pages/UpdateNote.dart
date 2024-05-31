import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../db/DatabaseHelper.dart';
import '../model/Note.dart';

class UpdateNote extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  UpdateNote(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return UpdateNoteState(this.note, this.appBarTitle);
  }
}

class UpdateNoteState extends State<UpdateNote> {
  static var _priorities = ['Penting', 'Biasa'];

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  UpdateNoteState(this.note, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    // Set initial values for text controllers
    titleController.text = note.title;
    descriptionController.text = note.description;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleMedium;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle,style: TextStyle(
                color: Color.fromRGBO(1, 255, 255, 100),
                fontWeight: FontWeight.bold,
                fontSize: 30 // Atur warna teks menjadi putih
                ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back when back button is pressed
            moveToLastScreen();
          },color: Color.fromRGBO(1, 255, 255, 100),
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
            color: Color.fromARGB(255, 26, 35, 44),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
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
                  border: InputBorder.none
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 30, 10),
              child: TextField(
                controller: descriptionController,
                style: TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (value) {
                  debugPrint('Something changed in Description Text Field');
                  updateDescription();
                },
                decoration: InputDecoration(
                  hintText: 'Isi Catatan',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  labelStyle: textStyle,
                  border: InputBorder.none
                ),
                maxLines: 20,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(1, 255, 245, 100),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        textStyle: TextStyle(fontSize: 14),
                      ),
                      child: Text(
                        'Simpan',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Update button clicked");
                          _update();
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

  // Update the title of Note object
  void updateTitle() {
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _update() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    result = await helper.updateNote(note);
    if (result != 0) {
      // Success
      // _showAlertDialog('Status', 'Note Updated Successfully');
    } else {
      // Failure
      // _showAlertDialog('Status', 'Problem Updating Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
