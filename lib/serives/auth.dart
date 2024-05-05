import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:note/models/user.dart';

class AuthService{


  final FirebaseAuth _auth = FirebaseAuth.instance;

  ActualUser? _actualUser(dynamic user, String fullName, String email){
    return user == null ? ActualUser(fullName: fullName, email: email, uid: user.uid) : null;
  }

  // sign in method


  /// Register function
  Future register(String email, String fullName, String password) async {
    try{
      dynamic result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user;

      /// save data to the database
      DatabaseReference ref = FirebaseDatabase.instance.ref("users");

      await ref.child(user.uid).set({
        'fullName':fullName,
        'email' : email,
      });

      return _actualUser(user, fullName, email);

    } on FirebaseAuthException catch(e){
      print(e.code);
    }catch(e){
      print(e);
      return null;
    }
  }

  /// Logout function
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e);
    }
  }


  /// Login function
  Future signIn(String email, String fullName, String password) async {
    try{
      dynamic result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user;
      return _actualUser(user, fullName, email);

    } on FirebaseAuthException catch(e){
      print(e.code);
    }catch(e){
      print(e);
      return null;
    }
  }


}