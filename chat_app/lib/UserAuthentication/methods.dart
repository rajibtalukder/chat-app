import 'package:chat_app/UserAuthentication/logInScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _firestore= FirebaseFirestore.instance;
  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    if (user != null) {
      print("Sign In Success");
      
              user.updateProfile(displayName: name);
              
                        await _firestore.collection('UserStoreData').add({
                        "name": name,
                        "email": email,
                        "password" : password,
                        "status" :"Unavailable",
                        "uid": _auth.currentUser!.uid,
                      }); 
      
      return user;

    } else {
      print("Sign In failed!!!");
      return user;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
        if(user!=null){
          print("LogIn Successfully");
          return user;
        }
        else{
          print("User not found");
          return user;
        }
  } catch (e) {
    print(e);
    return null;
  }
}

Future logOut(BuildContext context)async{
  FirebaseAuth _auth= FirebaseAuth.instance;
  try{
    await _auth.signOut().then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (_)=>LogInScreen()));
    });
  }
  catch(e){
    print("Error");
  }
}
