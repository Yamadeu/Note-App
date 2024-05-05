import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

import '../styles/styled_icon.dart';
import '../styles/styled_text.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {


  List<Map<dynamic,dynamic>>  notes = [];

  final _formKey = GlobalKey<FormState>();
  // Declare _formKey as a global key


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map Userdata = {};

  final TextEditingController _dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {


  Map<String, dynamic> actual_note = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

  final TextEditingController _noteController = TextEditingController(text: actual_note['actual_note']['note']);


  return Scaffold(
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/home");
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        actions: [

        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[850],
        title: Text('Edit Note ${actual_note['actual_note']['key'].substring(0,9)}...', style: TextStyle(color: Colors.white, fontFamily: "Lobster-Regular", letterSpacing: 1.0)),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Edit a Note",textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[300], fontSize: 20, fontWeight: FontWeight.bold),),
            ),
            SingleChildScrollView(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _noteController,
                      maxLength: 500,
                      maxLines: 10,
                      minLines: 7,
                      style: TextStyle(color: Colors.grey[300]),
                      cursorColor: Colors.grey[500],
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[800],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Leave a Note',
                        errorStyle: TextStyle(color: Colors.grey[300]),
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                      validator: (val) => val!.isEmpty ? "Enter a note !" : null,
                    ),
                    TextFormField(
                      controller: _dateController,
                      maxLines: 10,
                      minLines: 1,
                      cursorHeight: 0,
                      cursorRadius: Radius.circular(0),
                      cursorWidth: 0,
                      readOnly: true,
                      style: TextStyle(color: Colors.grey[300]),
                      cursorColor: Colors.grey[500],
                      keyboardType: TextInputType.emailAddress,
                      showCursor: false,
                      decoration: InputDecoration(
                        prefixIcon: StyledIcon(Icons.calendar_month_outlined),
                        fillColor: Colors.grey[800],
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Set a Notifying Date',
                        errorStyle: TextStyle(color: Colors.grey[300]),
                        hintStyle: TextStyle(color: Colors.grey[700]),
                      ),
                      validator: (val) => val!.isEmpty ? "Date needed !" : null,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate :DateTime(2000),
                            lastDate : DateTime(2101)
                        );

                        if(pickedDate != null){
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                          );
                          if(pickedTime != null){
                            DateTime? _selectedDateTime = DateTime(
                              pickedDate.year,
                              pickedDate.month,
                              pickedDate.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                            setState(() {
                              _dateController.text = DateFormat.yMMMd().add_Hm().format(_selectedDateTime);
                              print(_dateController.text);
                            });
                          }

                        }else{
                          setState(() {
                            _dateController.text = "";
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton.icon(
                        onPressed: () async {
                          if ((_noteController.text.isNotEmpty || _noteController.text != "")) {
                            // Process the form data
                            String note = _noteController.text;

                            DatabaseReference ref = await FirebaseDatabase.instance.ref("users").child(actual_note['actual_note']['uid']).child("notes");
                            String recordKey = actual_note['actual_note']['key'];

                            await ref.child(recordKey).update({
                              "note": note,
                              "updated_at" : _dateController.text != ""  ? _dateController.text  : actual_note['actual_note']['date']
                            });

                            MotionToast.success(
                                title:  Text("Upadated Succefully"),
                                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                displaySideBar: false,
                                description:  Text("Note ${actual_note['actual_note']['key'].substring(0,7)}... updated")
                            ).show(context);
                          }else{
                            MotionToast.error(
                                title:  Text("Error"),
                                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                displaySideBar: false,
                                description:  Text("You must enter a note before submitting")
                            ).show(context);
                          }

                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey[800])
                        ),
                        icon: StyledIcon(Icons.add),
                        label: StyledText("Edit the Note"))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );;
  }
}
