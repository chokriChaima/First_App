import 'package:brew_crew/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

import '../models/student.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser ;
  Student loggedInStudent = Student() ;

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
    .collection("students")
    .doc(user!.uid)
    .get()
    .then((value) {
      this.loggedInStudent = Student.fromMap(value.data());
      setState( (){});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding : EdgeInsets.all(100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 200,
                child: Image.asset("assets/brewCrew1.jpg",fit: BoxFit.contain),
              ),
              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "User Name : ${loggedInStudent.userName} ",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                )
              ),
              Text(
                "User Email : ${loggedInStudent.email}",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                )
              ),
              SizedBox(height: 20,),

              ActionChip(
                elevation: 5,
                padding: EdgeInsets.fromLTRB(20, 15, 20,15),
                backgroundColor: HexColor('#D5C0B1'),
                label:const Text("Logout",style: TextStyle(
                  color: Colors.white,
                ),), 
                onPressed: () {
                  logOut(context);
                })
            ],

          )
        )
      )
    );
  }

   void logOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LogInScreen())
    );
  }
}