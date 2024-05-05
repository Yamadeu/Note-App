import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../serives/auth.dart';
import '../styles/styled_icon.dart';

class Login extends StatefulWidget {
  final Function isViewSignIn;
  const Login({super.key, required this.isViewSignIn});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  String email= "";
  String fullName = "";
  String password = "";
  String error = "";

  bool loading = false;

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[700],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 30),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // ElevatedButton(
                    //   onPressed: (){
                    //     Navigator.of(context).pop();
                    //   },
                    //   child: StyledIcon(Icons.close),
                    //   style: ButtonStyle(
                    //     backgroundColor: MaterialStateProperty.all(Colors.grey[800]),
                    //   ),
                    // ),
                    ElevatedButton(
                        onPressed: (){
                          widget.isViewSignIn();
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey[800])
                        ),
                        child: StyledIcon(Icons.app_registration_outlined)
                    ),
                  ],
                ),
                SizedBox(height: 60,),
                Container(
                  child: Column(
                    children: [
                      Card(
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),

                                Text("LOGIN", style: TextStyle(color:Colors.grey[300],letterSpacing: 2.0, fontSize: 25),),

                                SizedBox(height: 20,),

                                TextFormField(
                                  style: TextStyle(color: Colors.grey[300]),
                                  cursorColor: Colors.grey[500],
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    fillColor: Colors.grey[800],
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: 'Email',
                                    errorStyle: TextStyle(color: Colors.grey[300]),
                                    hintStyle: TextStyle(color: Colors.grey[700]),
                                    prefixIcon: StyledIcon(Icons.email),
                                  ),
                                  onChanged: (val){
                                    setState(() {
                                      email = val;
                                    });
                                  },
                                  validator: (val) => val!.isEmpty ? "The email is needed" : null,
                                ),

                                SizedBox(height: 20,),

                                TextFormField(
                                    obscureText: true,
                                    style: TextStyle(color: Colors.grey[300]),
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey[800],
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: 'Paswword',
                                      hintStyle: TextStyle(color: Colors.grey[700]),
                                      errorStyle: TextStyle(color: Colors.grey[300]),
                                      prefixIcon: StyledIcon(Icons.lock),
                                    ),
                                    onChanged: (val){
                                      setState(() {
                                        password = val;
                                      });
                                    },
                                    validator: (val) {
                                      if(val!.isNotEmpty){
                                        if(val!.length >= 7){
                                          return null;
                                        }else{
                                          return "Password should have atleaast 7 chars";
                                        }
                                      }else{
                                        return "Password is needed";
                                      }

                                    }
                                ),

                                SizedBox(height: 20,),

                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: FilledButton(
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                              EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Set your padding here
                                            ),
                                            backgroundColor: MaterialStateProperty.all(Colors.grey[700]), // Change the color here
                                          ),
                                          onPressed: () async {
                                            setState(() {
                                              loading = true;
                                            });
                                            if(_formkey.currentState!.validate()){
                                              dynamic result = await AuthService().signIn(email, fullName, password);
                                              if(result == null){
                                                setState(() {
                                                  loading = false;
                                                });
                                                error = "Invalid Credentials";
                                              }
                                            }else{
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          },
                                          child: Text('LOGIN NOW', style: TextStyle(letterSpacing: 1.5))),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Text(error,style: TextStyle(color: Colors.grey[300]),)
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30,),
                      loading ? SpinKitCircle(
                        color: Colors.grey[300],
                        size: 70,
                      ) : Text("")
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}
