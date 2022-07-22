import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {

  //varriable and functions

  final Map<String, dynamic> userMap;
  final String chatRoomId;

  ChatRoom({required this.chatRoomId, required this.userMap});

  void onSendMessage()async{
              if(_message.text.isNotEmpty){
              Map<String, dynamic> messages={
              'sendBy':FirebaseAuth.instance.currentUser!.displayName,
              'message': _message.text,
              'time' : FieldValue.serverTimestamp(),
              };
              await _firestore.collection('chatroom').doc(chatRoomId).collection('chats').add(messages);
              }else{
                print("Enter Text");
              }
          _message.clear();
  }
  
   TextEditingController _message= TextEditingController();
   FirebaseFirestore _firestore = FirebaseFirestore.instance;
   

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(

      appBar: AppBar(title: Text(userMap['name']),
      backgroundColor: Colors.deepPurple,),

      //Body part

      body: SingleChildScrollView(
        child: Column(children: [

          Container(
            height:size.height/1.25,
            width:size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('chatroom')
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy("time", descending: false)
                      .snapshots(),
              builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.data!=null){
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> map = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                   return messages(size, map);
                    
                  }
                  
                );
              }
              else{
                return Container();
              }
            }),
          ),

          Container(
            height:size.height/10,
            width:size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height/12,
              width: size.width/1.3,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: size.height/12,
                      width: size.width/1.5,
                      child: TextField(
                        controller: _message,
                        decoration: InputDecoration(
                          hintText: "Send message",
                          border:OutlineInputBorder(
                            borderRadius:BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    IconButton(onPressed: onSendMessage, icon: Icon(Icons.send)),
              
                  ],
                ),
              ),
            )
            ),
            ]),


      )
    );
  }


  Widget messages(Size size, Map <String, dynamic> map){
    return Container(
      width: size.width,
      alignment: map['sendBy']==FirebaseAuth.instance.currentUser!.displayName
      ? Alignment.centerRight
        :Alignment.centerLeft,
        
        child:Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.deepPurple,
        ),
          child: Text(map['message'], style: TextStyle(color: Colors.white, fontSize: 16),),
        )
    );
  }
}