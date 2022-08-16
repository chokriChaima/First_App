import 'package:brew_crew/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/brew_crew_user.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final userNameEditingController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  String? selectedDrink;

  // Firebase auth
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // User Name Field
    final userNameField = TextFormField(
      autofocus: false,
      controller: userNameEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter a user name");
        }
        return null;
      },
      onSaved: (value) => userNameEditingController.text = value!,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        //you may add icons here
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "User Name",
      ),
    );

    //Email Field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please enter your email");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please enter a valid email");
        }
        return null;
      },
      onSaved: (value) => emailController.text = value!,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        //you may add icons here
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Email",
      ),
    );

    //Password Field
    final passwordField = TextFormField(
      obscureText: true,
      autofocus: false,
      controller: passwordController,
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }
        if (!regex.hasMatch(value)) {
          return ("Enter Valid Password(Min. 6 Character)");
        }
        return null;
      },
      onSaved: (value) => passwordController.text = value!,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        //you may add icons here
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
      ),
    );

    // drop menu Gender

    final drinkDropDownField = DropdownButtonFormField<String>(
        items: <String>[
          "Espresso",
          "Americano",
          "Espresso macchiato",
          "Cappucino",
          "Latte"
        ].map((gender) {
          return DropdownMenuItem<String>(
            child: Text(gender),
            value: gender,
          );
        }).toList(),
        hint: const Text("How do you like your coffee"),
        onChanged: (value) => setState(() => selectedDrink = value));
    //SignUp  button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: HexColor('#D5C0B1'),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width - 100,
        onPressed: () {
          signUp(emailController.text, passwordController.text);
        },
        child: const Text('Sign Up',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )),
      ),
    );

    // Main Page
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Customize Your Choice",
          ),
          centerTitle: true,
          leading: const BackButton(color: Colors.white),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 25),
          child: Column(
            children: [
              Container(
                height: 250,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://media.istockphoto.com/vectors/coffee-cup-vector-vector-id472338869?k=20&m=472338869&s=612x612&w=0&h=ZPeAWjef56ld_PmRTyV6JgRzWKye-iqbMUuDbn6EzzY="))),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 25),
                      userNameField,
                      SizedBox(height: 10),
                      emailField,
                      SizedBox(height: 10),
                      passwordField,
                      SizedBox(height: 10),
                      drinkDropDownField,
                      SizedBox(height: 30),
                      signUpButton
                    ],
                  )),
            ],
          ),
        )));
  }

  Future<void> signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                // custom function
                postDetailsToFirestore()
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e.message);
      });
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sending values
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // User is a predefined class type courtesy of firebase
    User? user = _auth.currentUser;

    BrewCrewUser brewCrewUser = BrewCrewUser();

    // writing all the values
    brewCrewUser.email = user!.email;

    // user.uid is never null
    brewCrewUser.brewCrewUserUID = user.uid;

    brewCrewUser.password = passwordController.text;
    brewCrewUser.userName = userNameEditingController.text;
    brewCrewUser.drink = selectedDrink;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(brewCrewUser.toMap());
    Fluttertoast.showToast(msg: "Account successfully created");

    // Push the given route onto the navigator that most tightly encloses the given context,
    // and then remove all the previous routes until the predicate returns true
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LogInScreen()),
        (route) => false);
  }
}
