import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:seniordesign/TestScreen.dart';
import 'package:seniordesign/pages/CreateAdmin.dart';
import 'package:seniordesign/pages/CustomId.dart';
import 'package:seniordesign/pages/PostAddCourse.dart';
import 'package:seniordesign/pages/PostAddStudentCourse.dart';
import 'package:seniordesign/pages/Testid.dart';
import 'package:seniordesign/pages/DelAllUsers.dart';
import 'package:seniordesign/globals/globals.dart';

import 'package:seniordesign/pages/Drawer.dart';

import 'package:seniordesign/LoginScreen.dart';
import 'package:seniordesign/RegisterScreen.dart';

import 'package:seniordesign/TestScreen.dart';
// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       title: 'Flutter Demo',
//       theme: new ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: LoginScreen(),
//     );
//   }
// }

// class MainMenu extends StatefulWidget {
//   @override
//   _MainMenuState createState() => _MainMenuState();
// }

// class _MainMenuState extends State<MainMenu> {
//   PageController _controller = PageController(
//     initialPage: 0,
//   );

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PageView(
//       controller: _controller,
//       children: [
//         DrawerHomePage(),
//         CreateAdmin(),
//         CustomId(),
//         TestId(),
//         DelAllUsers(),
//         PostAddCourse(),
//         PostAddStudentCourses(),
//       ],
//     );
//   }
// }
// ///////////////////////////////////////////////

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       backgroundColor: Color(0xff65646a),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [Text("Hi")],
//       ),
//     );
//   }
// }

//////////////////////////////////////////////////////////////////////////
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginScreen(),
    );
  }
}
