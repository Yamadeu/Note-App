import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushNamed(context, "/wrapper");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 300),
          child: Center(
              child: Column(
                children: [
                  Text(
                      "Welcome",
                      style : TextStyle(color: Colors.white, fontSize: 35,letterSpacing: 2.0, fontWeight: FontWeight.bold, fontFamily: "Lobster-Regular")
                  ),
                  SizedBox(height: 30,),
                  SpinKitDoubleBounce(
                    color: Colors.white,
                      size: 100,
                  ),
                ],
              )
          ),
        )
    );
  }
}

