
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:clipboard/clipboard.dart';
import 'package:motion_toast/motion_toast.dart';

import '../serives/local_notification_service.dart';

Widget NoteCard(int index, List<Map<dynamic,dynamic>> notes , BuildContext context){

  bool isNotify = false;
  return MainNoteCard(isNotify: isNotify, notes: notes, context: context, index: index,);
}

class MainNoteCard extends StatefulWidget {
  List<Map<dynamic,dynamic>> notes;
  BuildContext context;
  int index;
  bool isNotify;

  MainNoteCard({
    super.key,
    required this.isNotify,
    required this.notes,
    required this.context,
    required this.index,
  });

  @override
  State<MainNoteCard> createState() => _MainNoteCardState();
}

class _MainNoteCardState extends State<MainNoteCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("${widget.index+1}", style: TextStyle(color: Colors.grey[300],fontWeight: FontWeight.bold,fontSize: 20),),
                      IconButton(
                          onPressed: () async {
                            try {
                              Navigator.pushReplacementNamed(context, '/edit', arguments: {
                                'actual_note' : widget.notes[widget.index]
                              });
                            } catch (e) {
                              print('Error sharing via Medias: $e');
                            }
                          },
                          icon: Icon(Icons.edit_note, color:Colors.grey[300])
                      ),
                      IconButton(
                          onPressed: (){
                            FlutterClipboard.copy(widget.notes[widget.index]["note"]);
                           // MotionToast.success(title: Text("Copied"),description: Text("Note No ${index+1} copied to clipboard"));
                          } ,
                          icon: Icon(Icons.copy, color : Colors.grey[300])),
                      widget.isNotify ?
                      IconButton(
                          onPressed:(){
                            tz.initializeTimeZones();
                            // Parse the string into a DateTime object using DateFormat
                            DateFormat dateFormat = DateFormat("MMMM d, yyyy HH:mm");
                            DateTime parsedDateTime = dateFormat.parse(widget.notes[widget.index]["updated_at"] ?? widget.notes[widget.index]['date']);

                            // Convert the DateTime object to a TZDateTime object using timezone package
                            tz.TZDateTime tzDateTime = tz.TZDateTime.from(parsedDateTime, tz.local);

                            LocalNotifications.cancelAll();
                            setState(() {
                              widget.isNotify = false;
                            });

                          } ,
                          icon: Icon(Icons.notifications_active_rounded,color : Colors.green))
                      :IconButton(
                          onPressed:(){
                            tz.initializeTimeZones();
                            // Parse the string into a DateTime object using DateFormat
                            DateFormat dateFormat = DateFormat("MMMM d, yyyy HH:mm");
                            DateTime parsedDateTime = dateFormat.parse(widget.notes[widget.index]["updated_at"] ?? widget.notes[widget.index]['date']);

                            // Convert the DateTime object to a TZDateTime object using timezone package
                            tz.TZDateTime tzDateTime = tz.TZDateTime.from(parsedDateTime, tz.local);


                            LocalNotifications.showScheduleNotification(
                                title: 'Note ${widget.index+1} : Hey! Check this out',
                                body: widget.notes[widget.index]["note"],
                                payload: "This is simple data",
                                scheduledDate : tzDateTime );

                            setState(() {
                              widget.isNotify = true;
                            });

                          } ,
                          icon: Icon(Icons.notifications,color : Colors.grey[300]))

                    ],
                  ),
                  Text(
                    widget.notes[widget.index]["note"],
                    style: TextStyle(color: Colors.grey[300],fontSize: 15),),
                  Divider(height: 10,color:Colors.grey[700]),
                  Text(widget.notes[widget.index]["updated_at"] != null ? 'Edited On: ' + widget.notes[widget.index]["updated_at"] : 'Notify On: ' + widget.notes[widget.index]["date"], style: TextStyle(fontStyle: FontStyle.italic,fontSize:10, color: Colors.grey[500]),),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                  onPressed: () async {
                    DatabaseReference databaseReference =
                    FirebaseDatabase.instance.ref('users').child(widget.notes[widget.index]["uid"]).child("notes");
                    await databaseReference.child(widget.notes[widget.index]["key"]).remove();
                    // print('hello');
                  },
                  icon: Icon(Icons.delete,color:Colors.grey[300],size: 25,)),
            )
          ],
        ),
      ),
    );
  }
}