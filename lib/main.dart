import 'package:brew_crew/mango_db/pages/add_user_page.dart';
import 'package:brew_crew/sample_json_folder/sample_json_main.dart';
import 'package:brew_crew/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' ;
import 'package:hexcolor/hexcolor.dart';

import 'mango_db/pages/home_page.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            primary: HexColor("#D5C0B1"),
          ),
          backgroundColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            elevation: 0,
            backgroundColor: HexColor("#D5C0B1"),
            )
        ),
        title : "Brew Crew For Students",
        home : LogInScreen(), 
        // home : const SampleJson(),
        // home : AddUserPage(),
        debugShowCheckedModeBanner: false,
       
    );
  }
}

