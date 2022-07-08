import 'package:brew_crew/screens/home_screen.dart';
import 'package:brew_crew/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/student.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({ Key? key }) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final userNameEditingController = TextEditingController();
  final passwordController =  TextEditingController();
  final emailController =  TextEditingController();

  String? selectedGender ;


  // Firebase auth
  final _auth = FirebaseAuth.instance ;

  @override
  Widget build(BuildContext context) {

    // User Name Field
     final userNameField = TextFormField (
      autofocus: false,
      controller: userNameEditingController,
       validator: (value){
         if(value!.isEmpty)
         {
           return ("Please enter a user name");
         }
         return null;
       },
      onSaved: (value) => userNameEditingController.text = value!,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        //you may add icons here
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "User Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    //Email Field
     final emailField = TextFormField (
      autofocus: false,
      controller: emailController,
      validator: (value){
        if(value!.isEmpty)
        {
          return ("Please enter your email"); 
        }
        // reg expression for email validation
        if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]") .hasMatch(value))
        {
          return ("Please enter a valid email");
        }
        return null ;
      },
      onSaved: (value) => emailController.text = value!,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        //you may add icons here
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    
    //Password Field
     final passwordField = TextFormField (
      obscureText: true,
      autofocus: false,
      controller: passwordController,
      validator: (value){
        RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
      },
      onSaved: (value) => passwordController.text = value!,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        //you may add icons here
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // drop menu Gender

    final genderDropDownField = DropdownButtonFormField<String>(
      items:  <String>["Female","Male","Non-Binary"]
      .map<DropdownMenuItem<String>>( (gender) {
          return DropdownMenuItem<String>
          (child: Text(gender),
           value: gender,
          );
        }).toList(),
        hint: Text("Gender"),

      onChanged: null);
    //SignUp  button
    final SignUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: HexColor('#D5C0B1'),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20,15),
        minWidth: MediaQuery.of(context).size.width-150,
        onPressed: (){
          
          print("the selected gender is: ${selectedGender}");
          signUp(emailController.text, passwordController.text);
        },
        child: const Text(
          'Sign Up',
          textAlign: TextAlign.center,
          style : TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          )
        ),
      ),
    );

    // Main Page
    return Scaffold(
      appBar : AppBar(
        title: Text("Brew Crew "),
        centerTitle: true,
        leading: const BackButton(
          color: Colors.white
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    userNameField,
                    SizedBox(height: 10),
                    
                    SizedBox(height: 10),
                    emailField,
                    
                    SizedBox(height: 10),
                    passwordField,
                    SizedBox(height: 10),
                    Material(child: genderDropDownField),
                    SizedBox(height: 25),
                    SignUpButton
                  ],
                )
              ),
            )

          )
        ),
        )
    );
  }
  Future<void> signUp(String email,String password) async{
    if(_formKey.currentState!.validate())
    {
      await _auth
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((value) => 
      {
        // custom function
        postDetailsToFirestore() 
      })
      .catchError( (e) {
        Fluttertoast.showToast(msg: e.message);
      }) ;
    }
  }

  postDetailsToFirestore() async{
    // calling our firestore
    // calling our user model 
    // sending values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance ;
    // User is a predefined class type courtesy of firebase 
    User? user = _auth.currentUser;

    Student student = Student();

    // writing all the values 
    student.email= user!.email ;

   // user.uid is never null 
    student.studentUID = user.uid ;

   
    student.password = passwordController.text;
    student.userName = userNameEditingController.text;

    await firebaseFirestore
          .collection("students")
          .doc(user.uid)
          .set(student.toMap());
    Fluttertoast.showToast(msg: "Account successfully created") ;

    // Push the given route onto the navigator that most tightly encloses the given context,
    // and then remove all the previous routes until the predicate returns true
    Navigator.pushAndRemoveUntil(context, 
    MaterialPageRoute (builder: (context) => LogInScreen()) , (route) => false)   ;    
  }
}








