import 'package:brew_crew/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

import '../models/brew_crew_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  late BrewCrewUser loggedInBrewCrewUser;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    setUser();
  }

  setUser() => FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInBrewCrewUser = BrewCrewUser.fromMap(value.data());
        setState(() {
          loading = false;
        });
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Profile"),
          centerTitle: true,
        ),
        body: Center(
            child: loading
                ? CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical :50),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                          child: Image.asset("assets/brewCrew1.jpg",
                              fit: BoxFit.contain),
                        ),
                       const Text(
                         "Welcome Back",
                         style: TextStyle(
                             fontSize: 20, fontWeight: FontWeight.bold),
                       ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text("User Name : ${loggedInBrewCrewUser.userName} ",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )),
                            const  SizedBox(
                          height: 20,
                        ),
                        Text("User Email : ${loggedInBrewCrewUser.email}",
                            style:const  TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )),
                       const  SizedBox(
                          height: 20,
                        ),
                         Text("User Drink of choice : ${loggedInBrewCrewUser.drink}",
                            style:const  TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )),
                       const  SizedBox(
                          height: 20,
                        ),
                         Text("User Password : ${loggedInBrewCrewUser.password}",
                            style:const  TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )),
                       const  SizedBox(
                          height: 20,
                        ),
                        ActionChip(
                            elevation: 5,
                            padding:const EdgeInsets.fromLTRB(80, 15, 80, 15),
                            backgroundColor: HexColor('#D5C0B1'),
                            label: const Text(
                              "Logout",
                              style: TextStyle(
                                color: Colors.white,fontSize: 18
                              ),
                            ),
                            onPressed: () {
                              logOut(context);
                            })
                      ],
                    ))));
  }

  void logOut(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogInScreen()));
  }
}
