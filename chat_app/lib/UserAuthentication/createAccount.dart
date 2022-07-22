import 'package:chat_app/Screens/Home.dart';
import 'package:chat_app/UserAuthentication/logInScreen.dart';
import 'package:chat_app/UserAuthentication/methods.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final TextEditingController _name= TextEditingController();
  final TextEditingController _email= TextEditingController();
  final TextEditingController _password= TextEditingController();
  bool isLoading =false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading? 
      Container(
        height: size.height/20,
        width: size.width/20,
        child:CircularProgressIndicator(),
      )
      : SingleChildScrollView(
        child:Column(children: [


        SizedBox(height: size.height / 20),
        Container(
          width: size.width / 1.1,
          alignment: Alignment.centerLeft,
          child: IconButton(onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back_ios)),
        ),

        SizedBox(height: size.height / 50),
        Container(
          width: size.width / 1.2,
          alignment: Alignment.centerLeft,
          child: Text(
            "Welcome",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,),
          ),
        ),
        Container(
          width: size.width / 1.2,
          alignment: Alignment.centerLeft,
          child: Text(
            "Create Account to continue!",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color:Colors.grey),
          ),
        ),

        SizedBox(height: size.height / 20),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Container(
            width:size.width,
            alignment:Alignment.center,
            child: field(size, "Name", Icons.account_box, _name),
          ),
        ),

        SizedBox(height: size.height / 100),

        Container(
          width:size.width,
          alignment:Alignment.center,
          child: field(size, "Email", Icons.email, _email),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Container(
            width:size.width,
            alignment:Alignment.center,
            child: field(size, "Password", Icons.lock, _password),
          ),
        ),

        SizedBox(height: size.height / 10),
        customButton(size),


        SizedBox(height: size.height / 40),
        GestureDetector(
          onTap: (() => Navigator.push(context, MaterialPageRoute(builder: (_)=>LogInScreen()))),
          child: Text("Log In", style: TextStyle(
            color: Colors.blue,
            fontSize: 20,
          ),),
        ),


        ],)
      )
    );
  }


  Widget field(Size size, String hinttext, IconData icon, TextEditingController cont){
    return Container(
      height: size.height/15,
      width:size.width/1.1,
      child: TextField(
        controller:cont,
        decoration:InputDecoration(
          prefixIcon:Icon(icon),
          hintText: hinttext,
          hintStyle:TextStyle(color:Colors.grey, fontSize: 18),
          border:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      )
    );
  }

  Widget customButton(Size size){
    return GestureDetector(
      onTap: (){

          if(_name.text.isNotEmpty && _email.text.isNotEmpty && _password.text.isNotEmpty){
            setState(() {
              isLoading=true;
            });

            createAccount(_name.text, _email.text, _password.text).then((user){
              if(user!=null){
                setState(() {
                  isLoading=false;
                });
                print("Account Created Successfully");
                Navigator.push(context, MaterialPageRoute(builder: (_)=>Home()));
              }
              else{
                print("Log In failed");
                setState(() {
                  isLoading=false;
                });
              }
            });
          }
          else{
            print("Enter value on textfield");
          }

      },
      child: Container(
        height:size.height/18,
        width:size.width/1.1,
        decoration:BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blue,
        ),
        alignment: Alignment.center,
        child:Text("Create Account", style: TextStyle(
          fontSize:25,
          color:Colors.white,
         ),)
      ),
    );
  }


}


