import 'package:flutter/cupertino.dart';
import 'package:note/pages/login.dart';
import 'package:note/pages/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool isSignIn = false;

  void isViewSignIn() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isSignIn ? Login(isViewSignIn : isViewSignIn) : Register(isViewSignIn: isViewSignIn);
  }
}
