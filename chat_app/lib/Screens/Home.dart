

import 'package:chat_app/Screens/ChatRoom.dart';
import 'package:chat_app/UserAuthentication/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  Map<String, dynamic>? userMap;
  bool isLoading= false;
  TextEditingController _search = TextEditingController();

          String chatRoomId(String user1, String user2){
            if(user1[0].toLowerCase()
            .codeUnits[0]>user2
            .toLowerCase()
            .codeUnits[0]){
              return "$user1$user2";
            }
            else{
              return "$user2$user1";
            }
          }

      void onSearch()async{
        FirebaseFirestore _firestore= FirebaseFirestore.instance;
        setState(() {
          isLoading=true;
        });
        try{
          await _firestore.collection("UserStoreData").where("email", isEqualTo: _search.text)
        .get()
        .then((value){
          setState(() {
            userMap=value.docs[0].data();
            isLoading=false;
          });
          print(userMap?['name']);
        });
        }catch(e){
          print("Error");
        }
        

      }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title:Text("Home"), 
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [ IconButton(onPressed: ()=>logOut(context), 
          icon: Tooltip(
             message:"Log Out", 
             textStyle: TextStyle(fontSize: 18,color: Colors.white),
             child: Icon(Icons.logout)),)]
      ),
      body: isLoading? Center(
        child: Container(
          height:size.height/20,
          width: size.width/20,
          child:CircularProgressIndicator(),
        ),
      ) : Column(
        children: [
          SizedBox(height:size.height/20 ),
          Container(
            height: size.height /14,
            width: size.width ,
            alignment:Alignment.center,
            child: Container(
              height: size.height/14,
              width: size.width/1.2,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText:"Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height:size.height/30),
          ElevatedButton(onPressed:onSearch, child: Text(
            "Search", 
            ),style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,),
          ),
          SizedBox(height:size.height/30),

          userMap!=null?Dismissible(
            key: ValueKey("Text"),
            background: Container(
              color:Color.fromARGB(255, 112, 9, 9),
              child:Icon(Icons.delete),
            ),
            child: ListTile(
              onTap: (){
                
                String roomId=chatRoomId(
                FirebaseAuth.instance.currentUser!.displayName.toString(),
                  userMap!['name']);


                Navigator.of(context).push( MaterialPageRoute(builder: (_)=>ChatRoom(
                  chatRoomId: roomId, userMap:userMap!,
                )));
              
              },
              tileColor: Color.fromARGB(255, 226, 226, 226),
              leading: Icon(Icons.account_box, color: Colors.black,),
              title: Text(userMap!['name'], style: TextStyle(
                color: Colors.black,
                fontSize:22,
                fontWeight:FontWeight.w500,
                ),),
              subtitle: Text(userMap!['email'],style: TextStyle(
                color: Colors.black,
                fontSize:16,
                ),),
              trailing:Icon(Icons.chat, color: Colors.black,),
            ),
          )
          : Container(),


        ],
      )
    );
  }
}