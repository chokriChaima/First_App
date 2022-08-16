import 'package:brew_crew/screens/menu_screen.dart';
import 'package:brew_crew/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

import 'profile_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  //a formState object can be used to save, reset and VALIDATE
  //every FormField found in the target form.
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Adding Firebase to the application
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
        // firebase need atleast 6 characters to create an account
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
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        //you may add icons here
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Password",
      ),
    );

    //Login button
    final logInButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: HexColor('#D5C0B1'),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width - 150,
        onPressed: () {
          logIn(emailController.text, passwordController.text);
        },
        child: const Text('Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
    return Scaffold(
      body: Center(
        // A box in which a single widget can be scrolled
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
                          SizedBox(
                            height: 230,
                            child: Image.asset("assets/brewCrew1.jpg",
                                fit: BoxFit.contain),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          emailField,
                          SizedBox(
                            height: 25,
                          ),
                          passwordField,
                          const SizedBox(
                            height: 35,
                          ),
                          logInButton,
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account ? ",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegistrationScreen()));
                                  },
                                  child: Text("SignUp",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: HexColor("4D281B"),
                                        fontSize: 17,
                                      )))
                            ],
                          )
                        ],
                      )),
                ))),
      ),
    );
  }

  Future<void> logIn(
    String email,
    String password,
  ) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Fluttertoast.showToast(msg: "Login Successful");
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MenuScreen()));
      } on FirebaseAuthException catch (e) {
        Fluttertoast.showToast(msg: "User does not exist + $e");
      }
    }
  }
}
