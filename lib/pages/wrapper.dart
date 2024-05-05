import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:note/pages/authenticate.dart';
import 'package:note/pages/home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late Stream<User?> _authStream;
  User? _currentUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges();
    _authStream.listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return _currentUser == null ? Authenticate() : Home();
  }
}
