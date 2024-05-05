import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:note/serives/auth.dart';
import 'package:note/widgets/note_card.dart';
import 'package:intl/intl.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late Stream<User?> _authStream;

  User? _currentUser;

  List<Map<dynamic,dynamic>>  notes = [];

  final _formKey = GlobalKey<FormState>();
  // Declare _formKey as a global key

  final TextEditingController _noteController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map Userdata = {};


  // void checkNotes(){
  //   if(notes.length == 0){
  //       WidgetsBinding.instance.addPostFrameCallback((_){
  //         MotionToast.info(
  //             title:  Text("Notification"),
  //             description:  Text("No note present yet !")
  //         ).show(context);
  //       });
  //
  //   }
  // }

  void readUserData(User? user) async {
    String userId = await (user != null ? user.uid : "");
    DatabaseReference ref = await FirebaseDatabase.instance.ref("users").child(userId);
    await ref.onValue.listen((event) {
      dynamic data = event.snapshot.value;
      setState(() {
        Userdata = data;
      });
    });
  }
  
  
  void readUserNotes(User? user) async {
    String userId = await (user != null ? user.uid : "");
    DatabaseReference ref = await FirebaseDatabase.instance.ref("users").child(userId).child("notes");
    await ref.onValue.listen((event) {
      dynamic data = event.snapshot.value;
      notes.clear();
      data.forEach((id,data) {
        data['uid'] = userId;
        notes.add(data);
      });
    });

  }



  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    // checkNotes();
    _authStream = FirebaseAuth.instance.authStateChanges();
     _authStream.listen((User? user) {
        setState(() {
          _currentUser = user;
          readUserData(user);
          readUserNotes(user);
        });
    });


  }


  @override
  Widget build(BuildContext context) {

    // Timer.periodic(Duration(seconds: 1), (Timer timer) {
    //   setState(() {
    //   });
    // });


    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[850],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/egypt.png"),
                    radius: 35,
                  ),
                  SizedBox(height: 10,),
                  Text(Userdata['fullName'] ?? "No Name", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "lobster-regular", letterSpacing: 1.5, color: Colors.grey[300], fontSize: 20)),
                  Text(Userdata['email'] ?? "No Email", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "lobster-regular", letterSpacing: 1.5, color: Colors.grey[300], fontSize: 15)),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Divider(height: 0,color: Colors.grey,),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: (){
                Navigator.pop(context);
              },
            ),
            Divider(height: 0,color: Colors.grey,),

            _currentUser != null ?
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () async {
                    await AuthService().signOut();
                    Navigator.pushReplacementNamed(context, '/authenticate');
                  },
                )
                :ListTile(
                  leading: Icon(Icons.app_registration),
                  title: Text("Register"),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, "/wrapper");
                  },
                ),
                Divider(height: 0,color: Colors.grey,),

          ],
        ),
      ),
      backgroundColor: Colors.grey[700],
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
          color: Colors.white,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                readUserNotes(_currentUser);
              });
            },
            icon: Icon(Icons.refresh),
            color: Colors.white,
          ),
          IconButton(
              onPressed: () {
              },
              icon: Icon(Icons.search),
              color: Colors.white,
          ),
          IconButton(
            onPressed: () async {
                await AuthService().signOut();
                Navigator.pushReplacementNamed(context, "/wrapper");
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[850],
        title: Text('Note App', style: TextStyle(color: Colors.white, fontFamily: "Lobster-Regular", letterSpacing: 1.0)),
      ),
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushReplacementNamed(context, '/create');
        },
        elevation: 15,
        child: Icon(Icons.add, color: Colors.white,),
        backgroundColor: Colors.grey[850],
      ),
      body: notes.length == 0 ?
      Center(child: Text("No Note Yet!", style: TextStyle(color: Colors.grey[500], fontSize: 40, fontFamily: "Lobster-Regular",letterSpacing: 1.5),)):
      ListView.builder(
          itemCount:  notes.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
              child: Container(
                  child: NoteCard(index,notes, context)
              ),
            );
          }
      ),
    );
  }
}
